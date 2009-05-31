# Ensures basic form validation, including inter-field stuff works
# This tests with manually created fields only
use Test::More;
eval q{
     use SparkX::Form::Field::Password;
};
if ($@) {
    plan skip_all => "SparkX::Form::Field::Password is required for this test";
} else {
    plan tests => 11;
}
use Spark::Form;

#Create a form
my $form = Spark::Form->new;

#Create a base password with no confirm
my $pass1 = SparkX::Form::Field::Password->new(
    value => 'test123',
    form  => $form,
    name  => 'password',
);

#One that confirms with the previous
my $pass2 = SparkX::Form::Field::Password->new(
    value   => 'test123',
    form    => $form,
    name    => 'password_confirm',
    confirm => 'password'
);

#One that will fail it's confirm
my $pass3 = SparkX::Form::Field::Password->new(
    value   => 'test1234',
    form    => $form,
    name    => 'password_testfail',
    confirm => 'password'
);

#One that clashes with the first field's name
my $pass4 = SparkX::Form::Field::Password->new(
    value => 'test123',
    form  => $form,
    name  => 'password',
);


#First off, verify there are no fields in an empty form
is_deeply($form->fields_a,[],"Fields are not yet populated");

# FORM 1
$form->add($pass1);
cmp_ok(scalar @{$form->fields_a},'==',1,"One field");
#Verify validity
$form->validate;
cmp_ok($form->valid,'==',1,"Form 1 is valid");
is_deeply($form->errors,[],"Form 1 has no errors");

# FORM 2
$form->add($pass2);
cmp_ok(scalar @{$form->fields_a},'==',2,"Two fields");
#Verify validity
$form->validate;
cmp_ok($form->valid,'==',1,"Form 2 is valid");
is_deeply($form->errors,[],"Form 2 has no errors");

# FORM 3
$form->add($pass3);
cmp_ok(scalar @{$form->fields_a},'==',3,"Three fields");
#Verify validity
$form->validate;
cmp_ok($form->valid,'==',0,"Form 3 is invalid");
cmp_ok(scalar @{$form->errors},'==',1,"Form 3 has 1 error");

# FORM 4 - intentional fail
eval {
    $form->add($pass4);
};

ok(!!$@,"Adding a duplicate field name errors");
