# Ensures basic form validation, including inter-field stuff works
# This tests with manually created fields only
use Test::More;
plan tests => 9;

use Spark::Form;

use Test::MockObject::Extends;

#Create a form
my $form = Spark::Form->new;

#Field 1, foo => bar
my $f1 = Test::MockObject::Extends->new('Spark::Form::Field');
$f1->set_always('foo','bar');
$f1->set_always('name','foo');

#Field 2, bar => baz
my $f2 = Test::MockObject::Extends->new('Spark::Form::Field');
$f2->set_always('bar','baz');
$f2->set_always('name','bar');

#Field 3, baz => quux
my $f3 = Test::MockObject::Extends->new('Spark::Form::Field');
$f3->set_always('baz','quux');
$f3->set_always('name','baz');

#Field 4, baz => quux -- Clash!
my $f4 = Test::MockObject::Extends->new('Spark::Form::Field');
$f4->set_always('baz','quux');
$f4->set_always('name','baz');


#First off, verify there are no fields in an empty form
is_deeply([$form->fields_a],[],"Fields are not yet populated");

        
#Form 1
$form->add($f1);
cmp_ok(scalar $form->fields_a,'==',1,"One field");

#Pull it back out again
$f5 = $form->get('foo');
#Same thing, right?
is($f5->foo,'bar',"Has not changed");

#Form 2
$form->add($f2);
cmp_ok(scalar $form->fields_a,'==',2,"Two fields");

#Pull it back out again
$f6 = $form->get('bar');
#Same thing, right?
is($f6->bar,'baz',"Has not changed");

#Form 3
$form->add($f3);
cmp_ok(scalar $form->fields_a,'==',3,"Three fields");

#Pull it back out again
$f7 = $form->get('baz');
#Same thing, right?
is($f7->baz,'quux',"Has not changed");

#If field doesn't exist, undef is returned
is($form->get('quux'),undef,"Undef eq nonexistent");

eval {
    $form->add($f4);
};

ok(!!$@,"Adding a duplicate field name errors");
