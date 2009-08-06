package SX::Test::Field::Regex;

use Moose;
extends 'Spark::Form::Field';

with 'SparkX::Form::Field::Validator::Regex';

sub validate {}

1;
__END__

