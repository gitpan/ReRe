
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Simple Redis Rest Interface',
  'AUTHOR' => 'Thiago Rondon <thiago@nsms.com.br>',
  'BUILD_REQUIRES' => {
    'English' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'FindBin' => '0',
    'Mojo::IOLoop' => '0',
    'POSIX' => '0',
    'Test::Exception' => '0',
    'Test::Mock::Redis' => '0',
    'Test::Mojo' => '0',
    'Test::More' => '0.88'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.30'
  },
  'DISTNAME' => 'ReRe',
  'EXE_FILES' => [
    'bin/rere_server.pl'
  ],
  'LICENSE' => 'perl',
  'NAME' => 'ReRe',
  'PREREQ_PM' => {
    'Data::Dumper' => '0',
    'Exporter' => '0',
    'List::Util' => '0',
    'Mojo::JSON' => '0',
    'Mojo::UserAgent' => '0',
    'Mojolicious::Lite' => '0',
    'Mojolicious::Plugin::BasicAuth' => '0.05',
    'Moose' => '0',
    'Moose::Role' => '0',
    'MooseX::SimpleConfig' => '0',
    'MooseX::Traits' => '0',
    'Net::CIDR::Lite' => '0',
    'Redis' => '0',
    'Try::Tiny' => '0',
    'vars' => '0'
  },
  'VERSION' => '0.020',
  'test' => {
    'TESTS' => 't/*.t t/client/*.t t/hooks/*.t t/redis/*.t t/websocket/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



