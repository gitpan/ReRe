
package ReRe::Client;

use Moose;
use Mojo::UserAgent;
use Data::Dumper;

our $VERSION = '0.014'; # VERSION


our $AUTOLOAD;

sub DESTROY { }

sub AUTOLOAD {
    my $self = shift;
    my $command = $AUTOLOAD;
    $command =~ s/.*://;
    my @args = @_;
    $self->_get_rere($command, @args);
}

has url => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has username => (
    is => 'rw',
    isa => 'Str',
    default => ''
);

has password => (
    is => 'rw',
    isa => 'Str',
    default => ''
);

has ua => (
    is => 'rw',
    isa => 'Object',
    lazy => 1,
    default => sub { Mojo::UserAgent->new }
);

sub _get_rere {
    my ($self, $method, $var, $value, $extra) = @_;

    my $username = $self->username;
    my $password = $self->password;

    my $userpass = $username && $password ? "$username:$password\@" : '';
    my $base_url = "http://$userpass" .
        join('/', $self->url, 'redis', $method, $var);

    if ($value) {
        $base_url .= '/' . $value;;
        $base_url .= '/' . $extra if $extra;
    }

    my $json = $self->ua->get($base_url)->res->json;
    return $json->{$method};
}


1;


__END__
=pod

=head1 NAME

ReRe::Client

=head1 VERSION

version 0.014

=head1 DESCRIPTION

This client try to work the same as L<Redis>.

=head1 METHODS

The same of L<Redis>.

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

