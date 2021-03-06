use strict;
use warnings;

package Metrics::Collector::HASH;
use base 'Metrics::Collector';

sub new {
    my $class = shift;
    my %params = @_;

    unless (exists $params{host}) {
        $params{host} = '';
    }

    unless (exists $params{port}) {
        $params{port} = '';
    }

    my $self = $class->SUPER::new(%params);
    $self->{VALUE} = {};
    return $self;
}

sub value_of {
    my $self = shift;
    my $name = shift;
    $name = flatten_name($name);
    return $self->{VALUE}{$name};
}

sub flatten_name {
    my $name = shift;
    if (ref($name) eq 'ARRAY') {
        $name = join('.', @$name);
    }
    return $name;
}

sub assign_value {
    my ($self, $name, $value) = @_;
    my $sname = flatten_name($name);
    $self->{VALUE}{$sname} = $value;
    return;
}

# COUNTER METHODS

sub update_counter {
    my ($self, $name, $value) = @_;
    my $sname = flatten_name($name);
    $self->{VALUE}{$sname} += $value;
    return;
}

sub increment {
    my ($self, $name, $value) = @_;
    return shift->update_counter($name, $value);
}

sub decrement {
    my ($self, $name, $value) = @_;
    return $self->update_counter($name, -1 * $value);
}

# TIMER METHODS

sub timing {
    my ($self, $name, $value) = @_;
    $self->assign_value($name, $value);
}

# GAUGE METHODS

sub gauge {
    my ($self, $name, $value) = @_;
    $self->assign_value($name, $value);
}

1;
