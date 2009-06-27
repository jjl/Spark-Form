#!perl -T

use Spark::Form;
use Test::More tests => 4;
use lib 't/lib';

use SX::Test::Field::Combinatorics;

my $f = Spark::Form->new();

my $test = SX::Test::Field::Combinatorics->new(
    form => $f,
    name => 'test',
    regex => qr/^[A-Z]+[0-9]$/,
    min_length => 6,
    max_length => 6,
    confirm => 'test',
);
$f->add($test);
$f->data({test => ''});
$f->validate;
is(scalar $f->errors,3,"Three errors, unset");
$f->data({test => 'ABCDE'});
$f->validate;
is(scalar $f->errors,2,"Two errors");
$f->data({test => 'ABCDEFG'});
$f->validate;
is(scalar $f->errors,2,"Two errors,");
$f->data({test => 'ABCDE1'});
$f->validate;
is(scalar $f->errors,0,"No errors");
