package Spark::Form::Field::Validator::Result;

use Moose;

has bool => (
    isa => 'Bool',
    is => 'ro',
    required => 1,
);

has message => (
    isa => 'Str',
    is => 'ro',
    default => '',
);

1;
