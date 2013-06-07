use strict;
use warnings;

package Metrics::Collector::STDOUT;
use base 'Metrics::Collector::HASH';

sub flatten_name {
    return Metrics::Collector::HASH::flatten_name(@_);
}

# COUNTER METHODS

sub update_counter {
    my ($self, $name, $value) = @_;
    $self->SUPER::update_counter($name, $value);
    printf(qq(%s = %s\n), flatten_name($name), $self->value_of($name));
}

sub increment {
    my ($self, $name, $value) = @_;
    return shift->update_counter($name, $value);
}

sub decrement {
    my ($self, $name, $value) = @_;
    return $self->update_counter($name, -1 * $value);
}

# TIMER METHODS

sub timing {
    my ($self, $name, $value) = @_;
    $self->SUPER::timing($name, $value);
    printf(qq(%s = %s\n), flatten_name($name), $self->value_of($name));
}

1;
