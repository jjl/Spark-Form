#!perl -T

use Spark::Form;
use Test::More tests => 3;
use lib 't/lib';

use SX::Test::Field::MinLength;

my $f = Spark::Form->new();

my $test = SX::Test::Field::MinLength->new(
    form => $f,
    name => 'test',
    min_length => 3,
);
$f->add($test);
$f->data({test => 'qu'});
$f->validate;
is(scalar $f->errors,1,"One error, borderline");
$f->data({test => 'quu'});
$f->validate;
is(scalar $f->errors,0,"No errors, borderline");
$f->data({test => 'quux'});
$f->validate;
is(scalar $f->errors,0,"One error");
