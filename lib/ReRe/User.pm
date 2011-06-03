
package ReRe::User;

use Moose;
use ReRe::Config;
use Net::CIDR::Lite;

our $VERSION = '0.009'; # VERSION

has file => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

has _users => (
    is      => 'ro',
    isa     => 'HashRef[HashRef]',
    traits  => ['Hash'],
    default => sub { {} },
    handles => {
        _add_user  => 'set',
        _find_user => 'get',
        _all_users => 'elements'
    }
);

sub _parse_config {
    my $self = shift;
    my $config = ReRe::Config->new( { file => $self->file } );
    return $config->parse;
}

sub _setup {
    my $self   = shift;
    my %config = $self->_parse_config;
    foreach my $username ( keys %{$config{users}} ) {
        my $password = $config{users}{$username}{password};
        my $roles    = $config{users}{$username}{roles};
        my $allow    = $config{users}{$username}{allow};
        $self->_add_user(
            $username => {
                $password ? ( password => $password ) : (),
                $allow ? ( allow => [ split( ' ', $allow ) ] ) : (),
                roles => [ split( ' ', $roles ) ]
            }
        );
    }

}

sub _check_cidr {
    my $self  = shift;
    my $ip    = shift;
    my @allow = @_;

    foreach my $network (@allow) {
        my $cidr = Net::CIDR::Lite->new;
        my $flag = 0;
        eval {
            $cidr->add($network);
            $flag++ if $cidr->find($ip);
        };
        return 1 if $flag;
    }
}



sub auth {
    my ( $self, $username, $password ) = @_;
    return 0 unless $username and $password;
    my $user = $self->_find_user($username) or return 0;
    my $mem_password = $user->{password};
    return $mem_password eq $password ? $username : 0;
}


sub auth_ip {
    my ( $self, $ip ) = @_;
    return 0 unless $ip;
    my %users = $self->_all_users;
    foreach my $user ( keys %users ) {
        my ( @roles, @allow );
        @allow = @{ $users{$user}{allow} } if defined( $users{$user}{allow} );
        @roles = @{ $users{$user}{roles} } if defined( $users{$user}{roles} );
        return $user if grep( /$ip|all/, @allow );
        return $user if $self->_check_cidr( $ip, @allow );
    }
    return 0;
}


sub has_role {
    my ( $self, $username, $role, $ip ) = @_;
    return 0 unless $role;
    return $self->_user_has_role( $username, $role, $ip ) if $username;
    return $self->_ip_has_role( $role, $ip ) if $ip;
    return 0;
}

sub _ip_has_role {
    my ( $self, $role, $ip ) = @_;
    my %users = $self->_all_users;
    foreach my $user ( keys %users ) {
        my ( @roles, @allow );
        @allow = @{ $users{$user}{allow} } if defined( $users{$user}{allow} );
        @roles = @{ $users{$user}{roles} } if defined( $users{$user}{roles} );
        return 1 if grep( /$ip|all/, @allow ) and grep( /$role|all/, @roles );
        return 1 if $self->_check_cidr( $ip, @allow );
    }
    return 0;
}

sub _user_has_role {
    my ( $self, $username, $role, $ip ) = @_;
    my $user = $self->_find_user($username);
    my ( @roles, @allow );
    @roles = @{ $user->{roles} } if defined( $user->{roles} );
    @allow = @{ $user->{allow} } if defined( $user->{allow} );
    return grep( /$role|all/, @roles ) or grep( /$ip|all/, @allow ) ? 1 : 0;
}


sub process {
    my $self = shift;
    $self->_setup;
}

1;

__END__
=pod

=head1 NAME

ReRe::User

=head1 VERSION

version 0.009

=head1 METHODS

=head2 auth

Authentication

(username, password)

=head2 auth_ip

Authentication by IP

($ip)

=head2 has_role

Autorization

(username, role)

=head2 process

Initial process for acl.

=head1 AUTHOR

Thiago Rondon <thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Thiago Rondon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

