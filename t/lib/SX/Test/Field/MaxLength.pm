package SX::Test::Field::MaxLength;

use Moose;
extends 'Spark::Form::Field';

with 'SparkX::Form::Field::Validator::MaxLength';

sub validate {}

1;
__END__

