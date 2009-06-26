package TestApp::Form::Field::Custom;

use Moose;
extends 'Spark::Form::Field';
with 'Spark::Form::Field::Role::Validateable';

has 'min_length' => (
    isa => 'Int',
    is => 'rw',
    required => 0,
    default  => 6,
);

sub validate {
    my ($self) = @_;
    if ($self->min_length > length $self->value) {
        $self->error('Customs must be at least ' . $self->min_length . ' characters long.');
    }
}

1;
