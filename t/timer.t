use strict;
use warnings;

use Test::More;
use Time::HiRes;
use Metrics::Timer;
use Metrics::Collector::HASH;

plan tests => 2;

subtest 'flatten_name' => sub {
    plan tests => 12;

    my $collector = Metrics::Collector::HASH->new(host => '', port => '');
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

subtest 'operations' => sub {
    plan tests => 4;

    my $collector = Metrics::Collector::HASH->new(host => '', port => '');
    ok($collector, 'created a collector');

    my $load_time = Metrics::Timer->new(name => 'load_time', collector => $collector);
    ok($load_time, 'created a timer');

    is($load_time->collector->value_of('load_time'), undef, 'initial value of "load_time" is undefined');

    $load_time->reset();
    Time::HiRes::usleep(100_000); # timer reports ms not us
    $load_time->mark();
    ok($load_time->collector->value_of('load_time') >= 100, '"load_time" now has a reported timing')
        or diag('load_time = ' . $load_time->collector->value_of('load_time'));
};
