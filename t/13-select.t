#!perl -T

use Test::More tests => 1;
use lib 't/lib';
use Spark::Form;
use SparkX::Form::Field::Select;

my $form = Spark::Form->new;
my $b = SparkX::Form::Field::Select->new(
    name => 'test', form => $form,
    options => [
        'Option 1' => 'o1',
        'Option 2' => 'o2',
        'Option 3' => 'o3',
    ],
    value => 'test-2',
);

is($b->to_xhtml,'<select name="test"><option value="o1">Option 1</option> <option value="o2">Option 2</option> <option value="o3">Option 3</option></select>','Test xhtml representation');
