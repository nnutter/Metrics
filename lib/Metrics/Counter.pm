use strict;
use warnings;

package Metrics::Counter;
use base 'Metrics';

use overload (
    '+=' => \&increment,
    '-=' => \&decrement,
    '++' => \&increment,
    '--' => \&decrement,
    fallback => 1,
);

sub validate_overload_inputs {
    my ($self, $other, $swap) = @_;

    if ($swap) {
        Carp::croak('swap is not implemented');
    }

    $other ||= 1;
    if ($other < 0) {
        Carp::croak('other argument supplied to ' . __PACKAGE__ . '::increment must be a positive value');
    }

    return ($self, $other, $swap);
}

sub increment {
    my ($self, $amount, $swap) = shift->validate_overload_inputs(@_);
    $self->collector->increment($self->name, $amount);
    return $self;
}

sub decrement {
    my ($self, $amount, $swap) = shift->validate_overload_inputs(@_);
    $self->collector->decrement($self->name, $amount);
    return $self;
}

1;
