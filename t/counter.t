use strict;
use warnings;

use Test::More;

my $total_tests = 0;

do {
    $total_tests += 7;

    use_ok('Metrics::Collector::HASH');

    my $collector = Metrics::Collector::HASH->new(host => '', port => '');
    ok($collector, 'created a collector');

    use_ok('Metrics::Counter');

    my $pennies = Metrics::Counter->new(name => 'pennies', collector => $collector);
    ok($pennies, 'created a counter');

    is($pennies->collector->value_of('pennies'), undef, 'initial value of "pennies" is undefined');

    $pennies++;
    is($pennies->collector->value_of('pennies'), 1, 'incremented "pennies" counter');

    $pennies--;
    is($pennies->collector->value_of('pennies'), 0, 'decremented "pennies" counter');
};

done_testing($total_tests);
