# Test custom fields
use Test::More tests => 9;

use lib 't/lib';
use TestApp::Form::Field::Custom;
use Spark::Form;

#Create a form
my $form = Spark::Form->new;

#First off, verify there are no fields in an empty form
is_deeply($form->fields_a,[],"Fields are not yet populated");

my $custom_1 = TestApp::Form::Field::Custom->new(
    name => 'gt6',
    form => $form
);
my $custom_2 = TestApp::Form::Field::Custom->new(
    name => 'gt2',
    form => $form,
    min_length => 2,
);

#Add two custom fields
$form->add($custom_1);
cmp_ok(scalar @{$form->fields_a},'==',1,"Custom field 1 added");
$form->add($custom_2);
cmp_ok(scalar @{$form->fields_a},'==',2,"Custom field 2 added");

#DATASET 1 - two fail
my %data = (
    gt6 => '1',
    gt2 => '1',
);
$form->data(\%data);
$form->validate;
cmp_ok($form->valid,'==',0,"Dataset 1 is invalid");
cmp_ok(scalar @{$form->errors},'==',2,"Dataset 1 has 2 errors");

#DATASET 2 - one fail
%data = (
    gt6 => '12',
    gt2 => '12',
);
$form->data(\%data);
$form->validate;
cmp_ok($form->valid,'==',0,"Dataset 2 is invalid");
cmp_ok(scalar @{$form->errors},'==',1,"Dataset 2 has 1 error");


#DATASET 3 - No errors
%data = (
    gt6 => '123456',
    gt2 => '12',
);
$form->data(\%data);
$form->validate;
cmp_ok($form->valid,'==',1,"Dataset 3 is valid");
is_deeply($form->errors,[],"Dataset 3 has no errors");
