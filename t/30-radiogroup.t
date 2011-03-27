#!perl

use Test::More tests => 1;
use lib 't/lib';
use Spark::Form;
use SparkX::Form::Field::RadioGroup;

my $form = Spark::Form->new;
my $b = SparkX::Form::Field::RadioGroup->new(
    name => 'test', form => $form,
    options => ['test-1','test-2','test-3'],
    value => 'test-2',
);

is($b->to_xhtml,
   '<label for="test-1"></label>
<input id="test-1" type="radio" value="test-1" />
<label for="test-2"></label>
<input id="test-2" type="radio" value="test-2" />
<label for="test-3"></label>
<input id="test-3" type="radio" value="test-3" />','Test xhtml representation');
