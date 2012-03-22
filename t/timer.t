use strict;
use warnings;

use Test::More;

my $total_tests = 0;

do {
    $total_tests += 7;

    use_ok('Metrics::Collector::HASH');

    my $collector = Metrics::Collector::HASH->new(host => '', port => '');
    ok($collector, 'created a collector');

    use_ok('Metrics::Timer');

    my $load_time = Metrics::Timer->new(name => 'load_time', collector => $collector);
    ok($load_time, 'created a timer');

    is($load_time->collector->value_of('load_time'), undef, 'initial value of "load_time" is undefined');

    $load_time->start;

    use_ok('Time::HiRes');
    Time::HiRes::usleep(100_000); # timer reports ms not us

    $load_time->stop;
    ok($load_time->collector->value_of('load_time') >= 100, '"load_time" now has a reported timing')
        or diag('load_time = ' . $load_time->collector->value_of('load_time'));
};

done_testing($total_tests);
