
package ReRe::Client::Methods;

use strict;
use warnings;
use vars qw(@ISA @EXPORT_OK $VERSION @EXPORT_FAIL);
require Exporter;

our $VERSION = '0.021'; # VERSION

@ISA       = qw(Exporter);
@EXPORT_OK = qw(method_num_of_args);

my $methods = {
    set => { args => 2 },
    get => { args => 1 },
    'exists' => { args => 1 },
};


sub method_num_of_args {
    my $method = shift;
    return '' unless defined($methods->{$method});
    return $methods->{$method}{args} || 0;
}

1;


__END__
=pod

=head1 NAME

ReRe::Client::Methods

=head1 VERSION

version 0.021

=head1 DESCRIPTION

=head2 method_num_of_args

Return the number of arguments the method need.

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

