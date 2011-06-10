
package ReRe::ContentType::JSON;

use strict;
use Moose::Role;
use Mojo::JSON;

our $VERSION = '0.021'; # VERSION


sub content_type { 'application/json' }


sub unpack {
}


sub pack {
    my $self = shift;
    my $json = Mojo::JSON->new;
    return $json->encode( $self->data );
}

1;


__END__
=pod

=head1 NAME

ReRe::ContentType::JSON

=head1 VERSION

version 0.021

=head1 METHODS

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

