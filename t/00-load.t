#!perl -T

use Test::More;

my @fields = qw(
    Button Checkbox File Hidden Image
    MultiSelect Password Radio Reset
    Select Submit Text Textarea
);

BEGIN {
    plan tests => ( 4 + scalar @fields );

	use_ok($_) foreach (qw[
        Spark::Form
        Spark::Form::Field
    ]);
    use_ok( "SparkX::Form::Field::$_" ) foreach @fields;
	use_ok( 'SparkX::Form::BasicFields' );
	use_ok( 'SparkX::Form::Printer::List' );
}

diag( "Testing Spark::Form $Spark::Form::VERSION, Perl $], $^X" );
