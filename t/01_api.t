use strict;
use warnings;

use Test::More;
use Ginger;

my $ginger = Ginger->new(
    lang => 'US',
    version => '2.0',
    api_key => '6ae0c3a0-afdc-4532-a810-82ded0054236', # This API key must not be used!
);

is $ginger->gingeration("Hello, World"), "Hello, World";
is $ginger->gingeration("this is test"), "This is a test";

done_testing;
