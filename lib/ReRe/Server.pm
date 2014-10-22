
package ReRe::Server;

use Moose;
use Redis;
use ReRe::Config;
use ReRe::Hook;

our $VERSION = '0.016'; # VERSION

has file => (
    is  => 'rw',
    isa => 'Str'
);

around 'file' => sub {
    my $orig = shift;
    my $self = shift;
    return $self->$orig() unless @_;
    my ($file) = shift;
    my $config = ReRe::Config->new( { file => $file } );
    my %parse = $config->parse;
    $self->host( $parse{server}{host} ) if defined( $parse{server}{host} );
    $self->port( $parse{server}{port} ) if defined( $parse{server}{port} );

    map { $self->add_hook($_) } split( ' ', $parse{server}{hooks} )
      if defined( $parse{server}{hooks} );
};

has host => (
    is      => 'rw',
    isa     => 'Str',
    default => '127.0.0.1'
);

has port => (
    is      => 'rw',
    isa     => 'Int',
    default => '6379'
);

has conn => (
    is      => 'rw',
    isa     => 'Object',
    lazy    => 1,
    builder => '_builder_conn'
);

has hooks => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        all_hooks => 'elements',
        add_hook  => 'push'
    }
);

sub _builder_conn {
    my $self = shift;
    my $host = join( ':', $self->host, $self->port );
    return Redis->new( server => $host );
}


sub execute {
    my $self = shift;
    my $method = shift or return '';
    foreach my $hook ( $self->all_hooks ) {
        eval {
            my $class =
              ReRe::Hook->with_traits( '+ReRe::Role::Hook', $hook )
              ->new( method => $method, args => [ @_ ], conn => $self->conn  );
            $class->process;
        };
        warn $@ if $@;
    }

    return @_ ? $self->conn->$method(@_) : $self->conn->$method;
}

1;


__END__
=pod

=head1 NAME

ReRe::Server

=head1 VERSION

version 0.016

=head1 METHODS

=head2 execute

Wrapper for L<Redis>.

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

