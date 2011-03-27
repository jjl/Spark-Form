#!perl -T

use Test::More tests => 1;
use lib 't/lib';
use Spark::Form;
use SparkX::Form::Field::RadioGroup;

my $form = Spark::Form->new;
my $b = SparkX::Form::Field::RadioGroup->new(
    name => 'test', form => $form,
    options => [
        'Radio Button 1', => 'r1',
        'Radio Button 2', => 'r2',
        'Radio Button 3', => 'r3',
    ],
    value => 'test-2',
);

is($b->to_xhtml,
   '<label for="test-1">Radio Button 1</label>
<input id="test-1" type="radio" value="r1" />
<label for="test-2">Radio Button 2</label>
<input id="test-2" type="radio" value="r2" />
<label for="test-3">Radio Button 3</label>
<input id="test-3" type="radio" value="r3" />','Test xhtml representation');
