use Test::More tests => 1;
use Spark::Form;

#Local lib
use lib 't/lib';
use TestApp::Form::Field::Email;
use TestApp::Form::Field::Password;

#Create a form, mixing in the printer
eval {
    my $form = Spark::Form->new( printer => 'SparkX::Form::Printer::List' );
};
is($@,'',"$@ is empty");