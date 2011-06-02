
package ReRe::Client;

use Moose;
use Mojo::UserAgent;
use Data::Dumper;

# WARNING !!!! WARNING !!!! WARNING !!!!
# PLEASE, DON'T USE THIS !!!!!!

our $VERSION = '0.007'; # VERSION

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
    my $self = shift;
    my $method = shift;
    my $var = shift;
    my $value = shift;

    my $username = $self->username;
    my $password = $self->password;

    my $userpass = $username && $password ? "$username:$password\@" : '';
    my $base_url = "http://$userpass" .
        join('/', $self->url, 'redis', $method, $var);

    $base_url .= '/' . $value if $value;

    my $json = $self->ua->get($base_url)->res->json;
    return $json;
}



sub get {
    my ($self, $var) = @_;
    my $json = $self->_get_rere('get', $var);
    return $json->{get}{$var};
}


sub set {
    my ($self, $var, $value) = @_;
    my $json = $self->_get_rere('set', $var, $value);
    return $json->{set}{$var};
}


1;


__END__
=pod

=head1 NAME

ReRe::Client

=head1 VERSION

version 0.007

=head1 METHODS

=head2 get

=head2 set

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

