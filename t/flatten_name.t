use strict;
use warnings;

use Test::More tests => 2;
use Time::HiRes;
use Metrics::Timer;
use Metrics::Counter;
use Metrics::Collector::HASH;

subtest 'Metric::Counter' => sub {
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

subtest 'Metrics::Timer' => sub {
    plan tests => 12;

    my $collector = Metrics::Collector::HASH->new();
    ok($collector, 'created a collector');

    my $name = ['timer', 'beans'];
    my $timer = Metrics::Timer->new(name => $name, collector => $collector);
    ok($timer, 'created a timer');

    $timer->reset();
    Time::HiRes::usleep(100_000); # timer reports ms not us
    $timer->mark();
    ok($timer->collector->value_of($name) >= 0, 'accessed value by arrayref');

    my $flat_name = Metrics::Collector::HASH::flatten_name($name);
    like($flat_name, qr/$name->[0]/, "flat_name is like $name->[0]");
    like($flat_name, qr/$name->[1]/, "flat_name is like $name->[1]");
    ok($timer->collector->value_of($flat_name) >= 0, 'accessed value by flat_name');

    my $bag_one = ['bag', 'one'];
    $timer->mark($bag_one);
    ok($timer->collector->value_of([@$name, @$bag_one]) >= 0, 'accessed value by arrayref');

    $flat_name = Metrics::Collector::HASH::flatten_name([@$name, @$bag_one]);
    like($flat_name, qr/$name->[0]/, "flat_name is like $name->[0]");
    like($flat_name, qr/$name->[1]/, "flat_name is like $name->[1]");
    like($flat_name, qr/$bag_one->[0]/, "flat_name is like $bag_one->[0]");
    like($flat_name, qr/$bag_one->[1]/, "flat_name is like $bag_one->[1]");
    ok($timer->collector->value_of($flat_name) >= 0, 'accessed value by flat_name');
};
