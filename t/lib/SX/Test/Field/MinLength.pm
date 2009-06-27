package SX::Test::Field::MinLength;

use Moose;
extends 'Spark::Form::Field';

with 'SparkX::Form::Field::Validator::MinLength';

sub validate {}

1;
__END__

