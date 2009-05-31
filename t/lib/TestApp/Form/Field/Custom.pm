package TestApp::Form::Field::Custom;

use Any::Moose;
with 'Spark::Form::Field';
with 'Spark::Form::Field::Role::MinLength';

has '+min_length' => (
    required => 0,
    default  => 6,
);

has '+errmsg_too_short' => (
    default  => "Failed"
);

sub validate {
    my ($self) = @_;
    #This will be overridden by ::Role::MinLength if necessary.
    $self->valid(1);
}

1;
