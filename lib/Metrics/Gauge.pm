use strict;
use warnings;

package Metrics::Gauge;
use base 'Metrics';

sub log {
    my $self = shift;
    my $value = shift;

    $self->collector->gauge($self->name, $value);
    return;
}

1;

__END__

=pod

=head1 NAME

Metrics::Gauge - A gauge is an instantaneous measurement of a value.

=head1 VERSION

version ALPHA

=head1 SYNOPSIS

    my $pending_gauge = Metrics::Gauge->new(name => 'pending', collector => $statsd);
    ...
    $pending_gauge->log($pending_count);

=head1 DESCRIPTION

This module delegates gauge entries to a collector for aggregation, e.g.
StatsD.

=cut
