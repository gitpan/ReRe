
package ReRe::Role::Hook;

use strict;
use Moose::Role;
our $VERSION = '0.020'; # VERSION

requires '_hook';

has method => (
    is      => 'rw',
    isa     => 'Str',
    default => ''
);

has args => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { [] }
);

has conn => (
    is => 'rw',
    isa => 'Object',
    default => sub {},
);

1;


__END__
=pod

=head1 NAME

ReRe::Role::Hook

=head1 VERSION

version 0.020

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

