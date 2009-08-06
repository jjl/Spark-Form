#!perl -T

use Spark::Form;
use Test::More tests => 2;
use lib 't/lib';

use SX::Test::Field::Confirm;
use SX::Test::Field::Basic;

my $f = Spark::Form->new();

my $basic = SX::Test::Field::Basic->new(form => $f, name => 'basic');
my $confirm = SX::Test::Field::Confirm->new(form => $f, confirm => 'basic', name => 'confirm');
$f->add($basic)->add($confirm);
$f->data({basic => 'foo', confirm => 'bar'});
$f->validate;
is(scalar $f->errors,1,"One error");
$f->data({basic => 'foo', confirm => 'foo'});
$f->validate;
is(scalar @{$f->errors},0,"No errors");
