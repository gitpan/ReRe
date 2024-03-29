#!/usr/bin/env perl
#
# Thiago Rondon <thiago@aware.com.br>
#

package ReRe::App;

use strict;
use Mojolicious::Lite;
use ReRe;
use Try::Tiny;
use Mojo::JSON;
use Data::Dumper;
use ReRe::ContentType;

# ABSTRACT: ReRe application
our $VERSION = '0.021'; # VERSION

plugin 'basic_auth';

my $rere = ReRe->new;

sub error_config_users {
    print "I don't find /etc/rere/users.conf\n";
    print "Please, see http://www.rere.com.br to how create this file.\n";
    exit -1;
}

sub error_server_ping {
    print "I can't connect to redis server.\n";
    print "Please, see http://www.rere.com.br for more information.\n";
    exit -2;
}

sub main {
    my $self = shift;
    &error_config_users unless -r $rere->config_users();
    $rere->start;
    try {
        $rere->server->execute('ping');
    }
    catch {
        &error_server_ping;
    };

    app->start;
}

get '/login' => sub {
    my $self     = shift;
    my $username = $self->param('username') || '';
    my $password = $self->param('password') || '';

    return $self->render_json( { login => 0 } )
      unless $rere->user->auth( $username, $password );

    $self->session( name => $username );
    $self->render_json( { login => 1 } );
} => 'login';

get '/logout' => sub {
    my $self = shift;
    $self->session( expires => 1 );
    $self->render_json( { logout => 1 } );
} => 'logout';

any '/redis/:method/:var/:value/:extra' => {
    var   => '',
    value => '',
    extra => ''
  } => sub {
    my $self     = shift;
    my $method   = $self->stash('method') || $self->param('method');
    my $var      = $self->stash('var') || $self->param('var');
    my $value    = $self->stash('value') || $self->param('value');
    my $extra    = $self->stash('extra') || $self->param('extra');
    my $callback = $self->param('callback') || '';
    my $type     = $self->param('type') || 'JSON'; # text/xml, image/[png,jpeg], ...

    $type = 'JSONP' if $callback;

    my $username = $self->session('name') || '';

    $username = $rere->user->auth_ip( $self->tx->remote_address )
      unless $username;

    return $self->render_json( { err => 'no_auth' } )
      unless $username
          or $self->basic_auth(
              realm => sub {
                  my ( $http_username, $http_password ) = @_;
                  $rere->user->auth( $http_username, $http_password );
              }
          );

    my $data = $rere->process( $username, $method, $var, $value, $extra );
    my $content = ReRe::ContentType->with_traits( '+ReRe::Role::ContentType', $type )
        ->new( data => $data, args => [ $callback ] );

    return $self->render_text( $content->pack );

  } => 'redis';

if ( $rere->websocket->active ) {
    websocket '/ws' => sub {
        my $self = shift;

        my $username = 'userrw';

        #    my $username = $rere->user->auth_ip( $self->tx->remote_address );
        #
        #    return $self->render_json( { err => 'no_auth' } )
        #      unless $username
        #          or $self->basic_auth(
        #              realm => sub {
        #                  my ( $http_username, $http_password ) = @_;
        #                  $rere->user->auth( $http_username, $http_password );
        #              }
        #          );
        app->log->debug( sprintf 'Client connected: %s',
            $self->tx->remote_address );

        $self->on_message(
            sub {
                my ( $self, $message ) = @_;
                warn $message;
                my ( $method, $var, $value, $extra ) = split( ' ', $message );
                my $ret =
                  $rere->process( $method, $var, $value, $extra, $username );
                $self->send_message(
                    defined( $ret->{$method} )
                    ? $ret->{$method}
                    : ( defined( $ret->{err} ) ? $ret->{err} : () )
                );
                $self->finish;
            }
        );

    };
}

any '/' => sub {
    my $self = shift;
    return $self->render_json( {} );
} => 'index';

main;

__END__
=pod

=head1 NAME

ReRe::App - ReRe application

=head1 VERSION

version 0.021

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

