#!perl -T

use Test::More tests => 1;
use lib 't/lib';
use Mockform;
use SparkX::Form::Field::Reset;

my $form = Mockform->new;
my $b = SparkX::Form::Field::Reset->new(name => 'test', form => $form);

is($b->to_xhtml,'<input name="test" type="reset" />','Test xhtml representation');
