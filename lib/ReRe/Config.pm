
package ReRe::Config;

use Moose;
use Config::General;

our $VERSION = '0.006'; # VERSION

has file => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);



sub parse {
    my $self = shift;
    my $file = $self->file;
    die "Where is config file: $file ?" unless -r $file;
    my $conf = new Config::General( $file );
    return $conf->getall;
}

1;


__END__
=pod

=head1 NAME

ReRe::Config

=head1 VERSION

version 0.006

=head1 METHOD

=head2 parse

Parse config file with L<Config::General>.

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

