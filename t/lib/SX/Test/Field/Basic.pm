package SX::Test::Field::Basic;

use Moose;
extends 'Spark::Form::Field';

with 'SparkX::Form::Field::Validator::Confirm';

sub validate {}

1;
__END__
