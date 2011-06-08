
package ReRe::Websocket;

use Moose;
use ReRe::Config;

our $VERSION = '0.018'; # VERSION

has file => (
    is  => 'rw',
    isa => 'Str'
);

around 'file' => sub {
    my $orig = shift;
    my $self = shift;
    return $self->$orig() unless @_;
    my ($file) = shift;
    $self->_builder_file( ReRe::Config->new( { file => $file } ) );
};

has active => (
    is      => 'rw',
    isa     => 'Bool',
    default => '0'
);

sub _builder_file {
    my ( $self, $config ) = @_;
    my %parse = $config->parse;
    $self->$_( $parse{websocket}{$_} ) for grep { defined( $parse{server}{$_} ) } qw(active);
}

1;


__END__
=pod

=head1 NAME

ReRe::Websocket

=head1 VERSION

version 0.018

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

