use strict;
use warnings;

use Test::More tests => 5;
use Metrics::Timer;
use Metrics::Collector::HASH;
use Metrics::Collector::STDOUT;

my $default_collector = Metrics::Collector->default_collector;
ok(!$default_collector, 'no default_collector yet');

my $timer = eval { Metrics::Timer->new(name => 'timer') };
ok(!$timer, 'cannot create timer without collector');

Metrics::Collector::HASH->init();

$default_collector = Metrics::Collector->default_collector;
ok($default_collector, 'after init default_collector is set');

$timer = eval { Metrics::Timer->new(name => 'timer') };
ok($timer, 'after init can create timer without collector');

Metrics::Collector::STDOUT->init();

my $new_default_collector = Metrics::Collector->default_collector;
isnt($new_default_collector, $default_collector, 'default collector changed');
