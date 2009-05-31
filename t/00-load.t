#!perl -T

use Test::More tests => 2;

BEGIN {
    
	use_ok($_) foreach (qw[
        Spark::Form
        Spark::Form::Field
    ]);
}

diag( "Testing Spark::Form $Spark::Form::VERSION, Perl $], $^X" );
