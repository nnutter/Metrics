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

__END__

=pod

=head1 NAME

Metrics::Timer - Delegates timing changes to a Metrics::Collector.

=head1 VERSION

version ALPHA

=head1 SYNOPSIS

    # Create a timer object.
    my $timer = Metrics::Timer->new(name => 'race', collector => $statsd);

    # Record elapsed time.
    $timer->mark;

    # Reset to clock (if needed for reuse).
    $timer->reset;

    # Record elapsed time of subcomponents.
    ...
    $timer->mark('prepare');
    ...
    $timer->mark('execute');

=head1 DESCRIPTION

This module delegates timings for a named timer to a collector for aggregation,
e.g. StatsD.

=cut
