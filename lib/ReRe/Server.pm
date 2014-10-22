
package ReRe::Server;

use Moose;
use Redis;
use ReRe::Config;
use ReRe::Hook;

our $VERSION = '0.017'; # VERSION

has file => (
    is  => 'rw',
    isa => 'Str'
);

around 'file' => sub {
    my $orig = shift;
    my $self = shift;
    return $self->$orig() unless @_;
    my ($file) = shift;
    $self->_builder_file( ReRe::Config->new( { file => $file } ) );
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

has password => (
    is        => 'rw',
    isa       => 'Str',
    default   => '',
    predicate => 'has_password'
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

sub _builder_file {
    my ( $self, $config ) = @_;
    my %parse = $config->parse;
    $self->$_( $parse{server}{$_} ) for grep { defined( $parse{server}{$_} ) } qw(host port admin);

    map { $self->add_hook($_) } split( ' ', $parse{server}{hooks} )
        if defined( $parse{server}{hooks} );
}


sub execute {
    my $self = shift;
    my $method = shift or return '';
    foreach my $hook ( $self->all_hooks ) {
        my $ret;
        eval {
            my $class
                = ReRe::Hook->with_traits( '+ReRe::Role::Hook', $hook )
                ->new( method => $method, args => [@_], conn => $self->conn );
            $ret = $class->process;
        };
        warn $@ if $@;
        return $ret if $ret;
    }
    $self->conn->auth( $self->password ) if $self->has_password;

    my @args = grep {!/^$/} @_;
    return @args ? $self->conn->$method(@args) : $self->conn->$method;
}

1;


__END__
=pod

=head1 NAME

ReRe::Server

=head1 VERSION

version 0.017

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

