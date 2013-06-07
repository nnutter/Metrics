use strict;
use warnings;

use Test::More tests => 5;
use Metrics::Gauge;
use Metrics::Collector::HASH;

my $collector = Metrics::Collector::HASH->new();
ok($collector, 'created a collector');

my $pennies = Metrics::Gauge->new(name => 'pennies', collector => $collector);
ok($pennies, 'created a counter');

is($pennies->collector->value_of('pennies'), undef, 'initial value of "pennies" is undefined');

$pennies->log(5);
is($pennies->collector->value_of('pennies'), 5, 'value is 5');

$pennies->log(7);
is($pennies->collector->value_of('pennies'), 7, 'value is 7');
