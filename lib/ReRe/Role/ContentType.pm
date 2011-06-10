
package ReRe::Role::ContentType;

use strict;
use Moose::Role;

our $VERSION = '0.021'; # VERSION

requires 'content_type';
requires 'pack';
requires 'unpack';

has data => (
    is      => 'rw',
    isa     => 'Any',
    default => ''
);

has args => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { [] }
);

1;


__END__
=pod

=head1 NAME

ReRe::Role::ContentType

=head1 VERSION

version 0.021

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

