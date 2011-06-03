
package ReRe::Server;

use Moose;
use Redis;
use ReRe::Config;

our $VERSION = '0.009'; # VERSION

has file => (
    is  => 'rw',
    isa => 'Str'
);

around 'file' => sub {
    my $orig = shift;
    my $self = shift;
    return $self->$orig() unless @_;
    my ($file) = shift;
    warn $file;
    my $config = ReRe::Config->new( { file => $file } );
    $self->server( $config->{server}{host} ) if defined( $config->{server}{host} );
    $self->port( $config->{server}{port} )   if defined( $config->{server}{port} );
};

has server => (
    is      => 'rw',
    isa     => 'Str',
    default => '127.0.0.1'
);

has port => (
    is      => 'rw',
    isa     => 'Int',
    default => '6379'
);

has conn => (
    is      => 'rw',
    isa     => 'Object',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $host = join( ':', $self->server, $self->port );
        return Redis->new( server => $host );
    }
);



sub has_method {
    my ( $self, $method ) = @_;
    return $self->conn->can($method);
}


sub execute {
    my $self = shift;
    my $method = shift or return '';
    return @_ ? $self->conn->$method(@_) : $self->conn->$method;
}

1;


__END__
=pod

=head1 NAME

ReRe::Server

=head1 VERSION

version 0.009

=head1 METHODS

=head2 has_method

Check if method is available in L<Redis>.

=head2 execute

Wrapper for L<Redis>.

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

