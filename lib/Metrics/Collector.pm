use strict;
use warnings;

package Metrics::Collector;
use Carp 1.20;

sub new {
    my $class = shift;
    my %params = @_;

    my $host = delete $params{host};
    unless (defined $host) {
        Carp::carp 'host is required';
        return;
    }

    my $port = delete $params{port};
    unless (defined $port) {
        Carp::carp 'port is required';
        return;
    }

    my @param_keys = keys %params;
    if (@param_keys) {
        Carp::carp 'unrecognized parameters: ' . join(', ', @param_keys);
        return;
    }

    my $self = bless {
        host => $host,
        port => $port,
    }, $class;
    return $self;
}

sub host { return shift->{host} }
sub port { return shift->{port} }

1;
