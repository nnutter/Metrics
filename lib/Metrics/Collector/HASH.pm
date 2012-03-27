use strict;
use warnings;

package Metrics::Collector::HASH;
use base 'Metrics::Collector';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->{VALUE} = {};
    return $self;
}

sub value_of {
    my $self = shift;
    my $name = shift;
    return $self->{VALUE}{$name};
}

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
    my $sname = flatten_name($name);
    $self->{VALUE}{$sname} += 1;
    return;
}

sub decrement {
    my ($self, $name) = @_;
    my $sname = flatten_name($name);
    $self->{VALUE}{$sname} -= 1;
    return;
}

# TIMER METHODS

sub timing {
    my ($self, $name, $value) = @_;
    my $sname = flatten_name($name);
    $self->{VALUE}{$sname} = $value;
    return;
}

1;
