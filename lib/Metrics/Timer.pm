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

    my @names;

    my $name = $self->name;
    if (ref($name) eq 'ARRAY') {
        push @names, @$name;
    } else {
        push @names, $name;
    }

    if ($subname) {
        if (ref($subname) eq 'ARRAY') {
            push @names, @$subname;
        } else {
            push @names, $subname;
        }
    }

    my $elapsed_ms = int(Time::HiRes::tv_interval($self->{start}) * 1000);
    $self->collector->timing(\@names, $elapsed_ms);
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
