package Spark::Form::Field::Validator::Result;

use Moose;

has bool => (
    isa      => 'Bool',
    is       => 'ro',
    required => 1,
);

has message => (
    isa     => 'Str',
    is      => 'ro',
    default => q{},
);
__PACKAGE__->meta->make_immutable;
no Moose;
1;
