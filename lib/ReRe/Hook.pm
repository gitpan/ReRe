
package ReRe::Hook;

use strict;
use Moose;
with 'MooseX::Traits';

our $VERSION = '0.021'; # VERSION

has '+_trait_namespace' => ( default => 'ReRe::Hook' );


no Moose;
1;


__END__
=pod

=head1 NAME

ReRe::Hook

=head1 VERSION

version 0.021

=head1 DESCRIPTION

Hooking, you can alter the behavior of an request method. See L<ReRe::Hook::Log> for example.

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

