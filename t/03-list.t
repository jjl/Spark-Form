use Test::More tests => 4;
use Spark::Form;

#Local lib
use lib 't/lib';
use TestApp::Form::Field::Email;
use TestApp::Form::Field::Password;
use SparkX::Form::Printer::List;

#Create a form, mixing in the printer
my $form = Spark::Form->new( printer => 'SparkX::Form::Printer::List' );

#Code cunningly copied and pasted from t/03-register.t
my $email = TestApp::Form::Field::Email->new(name => 'email', form => $form);
my $pass1 = TestApp::Form::Field::Password->new(name => 'password', form => $form);
my $pass2 = TestApp::Form::Field::Password->new(name => 'confirm_password', confirm=>'password', form => $form);

#Add the fields
$form->add($email)->add($pass1)->add($pass2);

#Can?
ok(UNIVERSAL::can($form,'to_xhtml'),"can to_xhtml");
ok(UNIVERSAL::can($form,'to_html'),"can to_html");

my $xhtml = '<ul><li><label>email</label></li> <li><input type="text" value="" /></li> <li><label>password</label></li> <li><input type="password" /></li> <li><label>confirm_password</label></li> <li><input type="password" /></li></ul>';
my $html = '<ul><li><label>email</label></li> <li><input type="text" value="" ></li> <li><label>password</label></li> <li><input type="password"></li> <li><label>confirm_password</label></li> <li><input type="password"></li></ul>';

#To string
is($form->to_xhtml, $xhtml, "XHTML representation");
is($form->to_html, $html, "HTML representation");

