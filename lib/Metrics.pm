use strict;
use warnings;

package Metrics;
use Carp 1.20;

sub new {
    my $class = shift;
    my %params = @_;

    my $name = delete $params{name};
    unless (defined $name) {
        Carp::carp 'name is required';
        return;
    }
    if (ref($name) && ref($name) ne 'ARRAY') {
        Carp::carp 'name must be a string or an ARRAY reference';
        return;
    }

    my $collector = delete $params{collector};
    unless (defined $collector) {
        Carp::carp 'collector is required';
        return;
    }
    unless ($collector->isa('Metrics::Collector')) {
        Carp::carp 'specified collector is not a Metrics::Collector';
        return;
    }

    my @param_keys = keys %params;
    if (@param_keys) {
        Carp::carp 'unrecognized parameters: ' . join(', ', @param_keys);
        return;
    }

    my $self = bless {
        name => $name,
        collector => $collector,
    }, $class;
    return $self;
}

sub name { return shift->{name} }
sub collector { return shift->{collector} }

1;
