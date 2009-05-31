# Something looking a bit more real-world
use Test::More;
eval q{
     use SparkX::Form::Field::Email;
     use SparkX::Form::Field::Password;
};
if ($@) {
    plan skip_all =>
        "SparkX::Form::Field::{Email,Password} are required for this test";
} else {
    plan tests => 13;
}
use Spark::Form;

#Create a form
my $form = Spark::Form->new;

#First off, verify there are no fields in an empty form
is_deeply($form->fields_a,[],"Fields are not yet populated");

#Add an email
$form->add('email','email');
cmp_ok(scalar @{$form->fields_a},'==',1,"Email field added");

#Add a username
$form->add('mandatory','username',
    min_length => 6, max_length => 12, regex => qr/^[a-zA-Z_-]+$/
);
cmp_ok(scalar @{$form->fields_a},'==',2,"Username field added");

#Add a password
$form->add('password','password',min_length=>8);
cmp_ok(scalar @{$form->fields_a},'==',3,"Password field added");

#And a confirm password
$form->add('password','password_confirm',min_length=>1,confirm=>'password');
cmp_ok(scalar @{$form->fields_a},'==',4,"Password confirm field added");

#DATA SET 1 - 4 errory fields, some tripping multiple conditions
my %data = (
    email => 'blah',
    username => '12345',
    password => 'abc',
    password_confirm => 'def',
);
$form->data(\%data);
$form->validate;
cmp_ok($form->valid,'==',0,"Dataset 1 is invalid");
cmp_ok(scalar @{$form->errors},'==',5,"Dataset 1 has 5 errors");

#DATA SET 2 - 4 errory fields, each tripping one condition
%data = (
    email => 'blah',
    username => '12345678',
    password => 'abc',
    password_confirm => 'ijk',
);
$form->data(\%data);
$form->validate;
cmp_ok($form->valid,'==',0,"Dataset 2 is invalid");
cmp_ok(scalar @{$form->errors},'==',4,"Dataset 2 has 4 errors");

#DATA SET 3 - 1 errory field, tripping multiple conditions
%data = (
    email => 'test@example.org',
    username => '123',
    password => 'abcdefgh',
    password_confirm => 'abcdefgh',
);
$form->data(\%data);
$form->validate;
cmp_ok($form->valid,'==',0,"Dataset 3 is invalid");
cmp_ok(scalar @{$form->errors},'==',2,"Dataset 3 has 2 errors");

#DATA SET 4 - No errors
%data = (
    email => 'test@example.org',
    username => 'abcdefgh',
    password => 'abcdefgh',
    password_confirm => 'abcdefgh',
);
$form->data(\%data);
$form->validate;
cmp_ok($form->valid,'==',1,"Dataset 4 is valid");
is_deeply($form->errors,[],"Dataset 4 has no errors");
