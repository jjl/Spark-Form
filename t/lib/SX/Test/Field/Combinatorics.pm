package SX::Test::Field::Combinatorics; #Because it's a cool name, stolen from another module and this vaguely combines stuff

use Moose;
extends 'Spark::Form::Field';

with 'SparkX::Form::Field::Validator::Confirm';
with 'SparkX::Form::Field::Validator::NotEmpty';
with 'SparkX::Form::Field::Validator::MinLength';
with 'SparkX::Form::Field::Validator::MaxLength';
with 'SparkX::Form::Field::Validator::Regex';


has '+errmsg_confirm' => (
    default => 'Confirm does not match',
);

has '+errmsg_too_long' => (
    default => 'Too long',
);

has '+errmsg_too_short' => (
    default => 'Too short',
);

has '+errmsg_empty' => (
    default => 'Empty field',
);

has '+errmsg_regex' => (
    default => 'Regex fails',
);

sub validate {}

1;
__END__
