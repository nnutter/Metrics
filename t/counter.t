use strict;
use warnings;

use Test::More;
use Metrics::Counter;
use Metrics::Collector::HASH;

plan tests => 2;

subtest 'flatten_name' => sub {
    plan tests => 6;

    my $collector = Metrics::Collector::HASH->new();
    ok($collector, 'created a collector');

    my $name = ['counter', 'beans'];
    my $counter = Metrics::Counter->new(name => $name, collector => $collector);
    ok($counter, 'created a counter');

    $counter++;
    is($counter->collector->value_of($name), 1, 'accessed value by arrayref');

    my $flat_name = Metrics::Collector::HASH::flatten_name($name);
    like($flat_name, qr/$name->[0]/, "flat_name is like $name->[0]");
    like($flat_name, qr/$name->[1]/, "flat_name is like $name->[1]");
    is($counter->collector->value_of($flat_name), 1, 'accessed value by flat_name');
};

subtest 'operations' => sub {
    plan tests => 7;

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
};
