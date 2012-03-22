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

sub increment {
    my ($self, $name) = @_;
    local $Net::Statsd::HOST = $self->host;
    local $Net::Statsd::PORT = $self->port;
    Net::Statsd::increment(flatten_name($name));
    return;
}

sub decrement {
    my ($self, $name) = @_;
    local $Net::Statsd::HOST = $self->host;
    local $Net::Statsd::PORT = $self->port;
    Net::Statsd::decrement(flatten_name($name));
    return;
}

# TIMER METHODS

sub timing {
    my ($self, $name, $value) = @_;
    local $Net::Statsd::HOST = $self->host;
    local $Net::Statsd::PORT = $self->port;
    Net::Statsd::timing($name, $value);
    return;
}

1;
