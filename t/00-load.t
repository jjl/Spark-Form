#!perl -T

use Test::More;

my @fields = qw(
    Button Checkbox File Hidden Image
    MultiSelect Password Radio Reset
    Select Submit Text Textarea
);

BEGIN {
    plan tests => (1 + scalar @fields);
    use_ok( "SparkX::Form::Field::$_" ) foreach @fields;
	use_ok( 'SparkX::Form::BasicFields' );
}

