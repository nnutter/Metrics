use strict;
use warnings;

use Test::More tests => 4;
use Time::HiRes;
use Metrics::Timer;
use Metrics::Collector::HASH;

my $collector = Metrics::Collector::HASH->new();
ok($collector, 'created a collector');

my $load_time = Metrics::Timer->new(name => 'load_time', collector => $collector);
ok($load_time, 'created a timer');

is($load_time->collector->value_of('load_time'), undef, 'initial value of "load_time" is undefined');

$load_time->reset();
Time::HiRes::usleep(100_000); # timer reports ms not us
$load_time->mark();
ok($load_time->collector->value_of('load_time') >= 100, '"load_time" now has a reported timing')
    or diag('load_time = ' . $load_time->collector->value_of('load_time'));
