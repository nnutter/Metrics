use strict;
use warnings;

package Metrics::Collector::Statsd;
use base 'Metrics::Collector';

require Net::Statsd 0.03;

sub serialize_name {
    my $name = shift;
    if (ref($name) eq 'ARRAY') {
        $name = join('.', @$name);
    }
    return $name;
}

sub increment {
    my ($self, $name) = @_;
    local $Net::Statsd::HOST = $self->host;
    local $Net::Statsd::PORT = $self->port;
    Net::Statsd::increment(serialize_name($name));
    return;
}

sub decrement {
    my ($self, $name) = @_;
    local $Net::Statsd::HOST = $self->host;
    local $Net::Statsd::PORT = $self->port;
    Net::Statsd::decrement(serialize_name($name));
    return;
}

1;
