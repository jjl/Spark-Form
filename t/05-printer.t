use Test::More tests => 6;
use Spark::Form;

#Local lib
use lib 't/lib';
use TestApp::Form::Field::Email;
use TestApp::Form::Field::Password;
use TestApp::Form::Printer::Join;
use TestApp::Form::Custom;

#Create a form, mixing in the printer
my $form = Spark::Form->new( printer => 'TestApp::Form::Printer::Join' );

#Code cunningly copied and pasted from t/03-register.t
my $email = TestApp::Form::Field::Email->new(name => 'email', form => $form);
my $pass1 = TestApp::Form::Field::Password->new(name => 'password', form => $form);
my $pass2 = TestApp::Form::Field::Password->new(name => 'confirm_password', confirm=>'password', form => $form);

#Add the fields
$form->add($email)->add($pass1)->add($pass2);

#Can?
ok(UNIVERSAL::can($form,'to_xhtml'),"can to_xhtml");
ok(UNIVERSAL::can($form,'to_html'),"can to_html");

my $xhtml = '<input type="text" value="" /> <input type="password" /> <input type="password" />';
my $html = '<input type="text" value="" > <input type="password"> <input type="password">';

#To string
is($form->to_xhtml, $xhtml, "XHTML representation");
is($form->to_html, $html, "HTML representation");

my $form2 = TestApp::Form::Custom->new;
is($form2->to_xhtml, $xhtml, 'XHTML representation of custom form');
is($form2->to_html, $html, 'HTML representation of custom form');