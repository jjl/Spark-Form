use Test::More tests => 1;

use strict;
use warnings;

use lib 't/lib';
use Spark::Form;
use SparkX::Form::Field::Checkbox;

my $form = Spark::Form->new;
my $c = SparkX::Form::Field::Checkbox->new(name => 'test1', form => $form);
my $c2 = SparkX::Form::Field::Checkbox->new(name => 'test2', form => $form, value => 1);

$form->data({test => 'yes'});
$form->validate;
ok($form->valid,"Form is valid");