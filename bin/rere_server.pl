#!/usr/bin/env perl
#
# Thiago Rondon <thiago@aware.com.br>
#

package ReRe::App;

use strict;
use Mojolicious::Lite;
use ReRe;
use Try::Tiny;

# ABSTRACT: ReRe application
our $VERSION = '0.006'; # VERSION

plugin 'basic_auth';

my $config_users = '/etc/rere/users.conf';
my $rere = ReRe->new;

sub error_config_users {
    print "I don't find $config_users.\n";
    print "Please, see http://www.rere.com.br to how create this file.\n";
    exit -1;
}

sub error_server_ping {
    print "I can't connect to redis server.\n";
    print "Pleasse, see http://www.rere.com.br for more information.\n";
    exit -2;
}

sub main {
    my $self = shift;
    &error_config_users unless -r $config_users;
    $rere->start;
    try {
        $rere->server->execute('ping');
    } catch {
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

any '/redis/:method/:var/:value/:extra' => { var => '', value => '', extra =>
''} => sub {
    my $self   = shift;
    my $method = $self->stash('method') || $self->param('method');
    my $var    = $self->stash('var') || $self->param('var');
    my $value  = $self->stash('value') || $self->param('value');
    my $extra = $self->stash('extra') || $self->param('extra');
    my $username = $self->session('name') || '';

#    return $self->render_json( { err => 'no_method' } )
#      unless $rere->server->has_method($method);

    $username = $rere->user->auth_ip( $self->tx->remote_address )
        unless $username;

    return $self->render_json( { err => 'no_auth' } )
        unless $username or $self->basic_auth( realm => sub {
                my ($http_username, $http_password) = @_;
                $rere->user->auth( $http_username, $http_password);
            } );

    return $self->render_json( { err => 'no_permission' } )
      unless $rere->user->has_role( $username, $method );

    my $ret;
    if ( $method eq 'set' ) {
        $ret = $rere->server->execute( $method, $var => $value );
        return $self->render_json( { $method => { $var => $value } } );
    }
    elsif ( $extra ) {
        my @ret = ( $rere->server->execute( $method, $var, $value, $extra ) );
        return $self->render_json( { $method => [ @ret ] } );
    }
    elsif ( $value ) {
        $ret = $rere->server->execute( $method, $var, $value );
        return $self->render_json( { $method => { $var => $value } } );
    }
    elsif ( $var ) {
        $ret = $rere->server->execute( $method, $var );
        return $self->render_json( { $method => { $var => $ret } } );
    }
    else {
        $ret = $rere->server->execute( $method );
        return $self->render_json( { $method => $ret } );
    }

} => 'redis';

main;

__END__
=pod

=head1 NAME

ReRe::App - ReRe application

=head1 VERSION

version 0.006

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

