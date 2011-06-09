
package ReRe::Hook::Log;
use strict;
use Moose::Role;
use Data::Dumper;

our $VERSION = '0.020'; # VERSION

sub _hook {
    my $self = shift;

    # warn $self->method;
    my $args = $self->args;
    if ( scalar( @{$args} ) ) {
        # warn Dumper($args);
    }
    #self->conn->execute('info');
    return 0;
}

1;


__END__
=pod

=head1 NAME

ReRe::Hook::Log

=head1 VERSION

version 0.020

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

