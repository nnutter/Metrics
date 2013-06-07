use strict;
use warnings;

package Metrics::Collector::Statsd;
use base 'Metrics::Collector';

require Net::Statsd;

sub flatten_name {
    my $name = shift;
    if (ref($name) eq 'ARRAY') {
        $name = join('.', @$name);
    }
    return $name;
}

# COUNTER METHODS

sub update_counter {
    my ($self, $name, $value) = @_;
    local $Net::Statsd::HOST = $self->host;
    local $Net::Statsd::PORT = $self->port;
    Net::Statsd::update_stats(flatten_name($name), $value);
    return;
}

sub increment {
    my ($self, $name, $value) = @_;
    return $self->update_counter($name, $value);
}

sub decrement {
    my ($self, $name, $value) = @_;
    return $self->update_counter($name, -1 * $value);
}

# TIMER METHODS

sub timing {
    my ($self, $name, $value) = @_;
    local $Net::Statsd::HOST = $self->host;
    local $Net::Statsd::PORT = $self->port;
    Net::Statsd::timing(flatten_name($name), $value);
    return;
}

# GAUGE METHODS

sub gauge {
    my ($self, $name, $value) = @_;
    local $Net::Statsd::HOST = $self->host;
    local $Net::Statsd::PORT = $self->port;
    Net::Statsd::gauge(flatten_name($name), $value);
    return;
}

1;
