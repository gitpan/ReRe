
package ReRe;

use Moose;
use ReRe::User;
use ReRe::Server;

# ABSTRACT: Simple Redis Rest Interface
our $VERSION = '0.013'; # VERSION

has config_user => (
    is => 'rw',
    isa => 'Str',
    default => sub { -r '/etc/rere/users.conf' ? '/etc/rere/users.conf' : 'etc/users.conf' }
);

has user => (
    is => 'ro',
    isa => 'ReRe::User',
    lazy => 1,
    default => sub { ReRe::User->new( { file => shift->config_user }) }
);

has server => (
    is => 'rw',
    isa => 'ReRe::Server',
    predicate => 'has_server',
);


sub start {
    my $self = shift;
    $self->user->process;
    my $config_server = '/etc/rere/server.conf';
    if (-r $config_server) {
        $self->server(ReRe::Server->new({ file => $config_server }));
    } else {
        $self->server(ReRe::Server->new);
    }
}



sub process {
    my ($self, $method, $var, $value, $extra, $username) = @_;

    return { err => 'no_permission' }
      unless $self->user->has_role( $username, $method );

    my $ret;
    if ( $method eq 'set' ) {
        $ret = $self->server->execute( $method, $var => $value );
    }
    elsif ( $extra ) {
        $ret = ( $self->server->execute( $method, $var, $value, $extra ) );
    }
    elsif ( $value ) {
        $ret = $self->server->execute( $method, $var, $value );
    }
    elsif ( $var ) {
        $ret = $self->server->execute( $method, $var );
    }
    else {
        $ret = $self->server->execute( $method );
    }
    return { $method => $ret };
}


1;


__END__
=pod

=head1 NAME

ReRe - Simple Redis Rest Interface

=head1 VERSION

version 0.013

=head1 DESCRIPTION

ReRe is a simple redis rest interface write in Perl and L<Mojolicious>,
with some features like:

=over

=item Access your Redis database directly from Javascript.

=item Config file for store users and access control list.

=item REST interface to make your life more easy in some world.

=item Support to run as daemon (simple web-service), CGI, FastCGI or PSGI.

=item Simple to install and use

=back

More information, you can read in L<http://www.rere.com.br>.

=head1 METHODS

=head2 start

Start ReRe.

=head2 process

Process the request to redis server.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

perldoc ReRe
perldoc ReRe::Config
perldoc ReRe::Server
perldoc ReRe::User

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=ReRe>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/ReRe>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/ReRe>

=item * Search CPAN

L<http://search.cpan.org/dist/ReRe>

=back

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

