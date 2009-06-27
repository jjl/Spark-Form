package SX::Test::Field::NotEmpty;

use Moose;
extends 'Spark::Form::Field';

with 'SparkX::Form::Field::Validator::NotEmpty';

sub validate {}

1;
__END__

