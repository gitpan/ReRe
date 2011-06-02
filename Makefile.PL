
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
    'Config::General' => '0',
    'Data::Dumper' => '0',
    'Mojo::UserAgent' => '0',
    'Mojolicious::Lite' => '0',
    'Mojolicious::Plugin::BasicAuth' => '0.02',
    'Moose' => '0',
    'Redis' => '0',
    'Try::Tiny' => '0'
  },
  'VERSION' => '0.006',
  'test' => {
    'TESTS' => 't/*.t'
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



