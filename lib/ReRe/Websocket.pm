
package ReRe::Websocket;

use Moose;
with 'MooseX::SimpleConfig';
use ReRe::Config;

our $VERSION = '0.019'; # VERSION

has active => (
    is      => 'rw',
    isa     => 'Bool',
    default => '0'
);

1;


__END__
=pod

=head1 NAME

ReRe::Websocket

=head1 VERSION

version 0.019

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

