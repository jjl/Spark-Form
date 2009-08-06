#!perl -T

use Test::More tests => 1;
use lib 't/lib';
use Mockform;
use SparkX::Form::Field::Submit;

my $form = Mockform->new;
my $b = SparkX::Form::Field::Submit->new(name => 'test', value => 'test', form => $form);

is($b->to_xhtml,'<input name="test" type="submit" value="test" />','Test xhtml representation');
