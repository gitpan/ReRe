
package ReRe::ContentType::MessagePack;

use strict;
use Moose::Role;
use Data::MessagePack;

our $VERSION = '0.021'; # VERSION

sub content_type { 'application/msgpack' }

sub unpack {
    return Data::MessagePack->unpack ( shift->data );
}

sub pack {
    return Data::MessagePack->pack( shift->data );
}

1;


__END__
=pod

=head1 NAME

ReRe::ContentType::MessagePack

=head1 VERSION

version 0.021

=head1 METHOD

=head2 content_type

=head2 unpack

=head2 pack

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

