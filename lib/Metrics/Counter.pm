use strict;
use warnings;

package Metrics::Counter;
use base 'Metrics';

use overload (
    '++' => \&increment,
    '--' => \&decrement,
    fallback => 1,
);

sub increment {
    my $self = shift;
    $self->collector->increment($self->name);
}

sub decrement {
    my $self = shift;
    $self->collector->decrement($self->name);
}

1;
