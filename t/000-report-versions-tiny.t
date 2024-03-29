use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

my $v = "\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = "any version";
    my $pv = ($^V || $]);
    $v .= "perl: $pv (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    $wanted = " (want $wanted)";
    my $pmver;
    eval "require $module;";
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('Data::Dumper','any version') };
eval { $v .= pmver('Data::MessagePack','any version') };
eval { $v .= pmver('English','any version') };
eval { $v .= pmver('Exporter','any version') };
eval { $v .= pmver('ExtUtils::MakeMaker','6.30') };
eval { $v .= pmver('File::Find','any version') };
eval { $v .= pmver('File::Temp','any version') };
eval { $v .= pmver('FindBin','any version') };
eval { $v .= pmver('List::Util','any version') };
eval { $v .= pmver('Mojo::IOLoop','any version') };
eval { $v .= pmver('Mojo::JSON','any version') };
eval { $v .= pmver('Mojo::UserAgent','any version') };
eval { $v .= pmver('Mojolicious::Lite','any version') };
eval { $v .= pmver('Mojolicious::Plugin::BasicAuth','0.05') };
eval { $v .= pmver('Moose','any version') };
eval { $v .= pmver('Moose::Role','any version') };
eval { $v .= pmver('MooseX::SimpleConfig','any version') };
eval { $v .= pmver('MooseX::Traits','any version') };
eval { $v .= pmver('Net::CIDR::Lite','any version') };
eval { $v .= pmver('POSIX','any version') };
eval { $v .= pmver('Redis','any version') };
eval { $v .= pmver('Test::Exception','any version') };
eval { $v .= pmver('Test::Mock::Redis','any version') };
eval { $v .= pmver('Test::Mojo','any version') };
eval { $v .= pmver('Test::More','0.88') };
eval { $v .= pmver('Try::Tiny','any version') };
eval { $v .= pmver('vars','any version') };



# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve you problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;
