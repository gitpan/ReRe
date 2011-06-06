
use Test::More tests => 3;
use ReRe::Client;
use Test::Mojo;
use FindBin;
require "$FindBin::Bin/../bin/rere_server.pl";


my $t = Test::Mojo->new;

my $conn = ReRe::Client->new( { url => '127.0.0.1:3000' } );

ok($conn);

is( $conn->set( 'foo', '2' ), 'OK' );

$conn = ReRe::Client->new(
    {   url      => '127.0.0.1:3000',
        username => 'userro',
        password => 'userro'
    } );

is( $conn->get('foo'), 2 );

