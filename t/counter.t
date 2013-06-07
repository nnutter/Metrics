use strict;
use warnings;

use Test::More tests => 7;
use Metrics::Counter;
use Metrics::Collector::HASH;

my $collector = Metrics::Collector::HASH->new();
ok($collector, 'created a collector');

my $pennies = Metrics::Counter->new(name => 'pennies', collector => $collector);
ok($pennies, 'created a counter');

is($pennies->collector->value_of('pennies'), undef, 'initial value of "pennies" is undefined');

$pennies++;
is($pennies->collector->value_of('pennies'), 1, 'incremented "pennies" counter');

$pennies--;
is($pennies->collector->value_of('pennies'), 0, 'decremented "pennies" counter');

$pennies += 4;
is($pennies->collector->value_of('pennies'), 4, 'incremented "pennies" counter by four');

$pennies -= 2;
is($pennies->collector->value_of('pennies'), 2, 'decremented "pennies" counter by two');
