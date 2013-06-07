use strict;
use warnings;

package Metrics::Timer;
use base 'Metrics';
use Time::HiRes;

sub reset {
    my $self = shift;
    $self->{start} = [Time::HiRes::gettimeofday];
    return;
}

sub mark {
    my $self = shift;
    my $subname = shift;

    my $name = $self->name;
    if ($subname) {
        if (ref($name) eq 'ARRAY') {
            $name = [@$name, $subname];
        } else {
            $name = [$name, $subname];
        }
    }

    my $elapsed_ms = int(Time::HiRes::tv_interval($self->{start}) * 1000);
    $self->collector->timing($name, $elapsed_ms);
    return;
}

1;
