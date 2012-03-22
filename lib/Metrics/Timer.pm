use strict;
use warnings;

package Metrics::Timer;
use base 'Metrics';
use Time::HiRes;

sub start {
    my $self = shift;
    $self->{start} = [Time::HiRes::gettimeofday];
    return;
}

sub stop {
    my $self = shift;
    my $elapsed_ms = int(Time::HiRes::tv_interval($self->{start}) * 1000);
    $self->collector->timing($self->name, $elapsed_ms);
    return;
}

1;
