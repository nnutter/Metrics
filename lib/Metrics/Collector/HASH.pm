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

sub serialize_name {
    my $name = shift;
    if (ref($name) eq 'ARRAY') {
        $name = join('.', @$name);
    }
    return $name;
}

sub increment {
    my ($self, $name) = @_;
    my $sname = serialize_name($name);
    return $self->{VALUE}{$sname} += 1;
}

sub decrement {
    my ($self, $name) = @_;
    my $sname = serialize_name($name);
    return $self->{VALUE}{$sname} -= 1;
}

1;
