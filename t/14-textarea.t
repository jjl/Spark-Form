#!perl -T

use Test::More tests => 1;
use lib 't/lib';
use Mockform;
use SparkX::Form::Field::Textarea;

my $form = Mockform->new;
my $b = SparkX::Form::Field::Textarea->new(name => 'test', form => $form, value=>'test');

is($b->to_xhtml,'<textarea name="test">test</textarea>','Test xhtml representation');
