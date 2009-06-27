package TestApp::Form::Custom;

use Moose;
extends 'Spark::Form';
with 'TestApp::Form::Printer::Join';

sub BUILD {
    my ($self) = @_;

    my $email = TestApp::Form::Field::Email->new(
        name => 'email',
        form => $self
    );
    my $pass1 = TestApp::Form::Field::Password->new(
        name => 'password',
        form => $self
    );
    my $pass2 = TestApp::Form::Field::Password->new(
        name => 'confirm_password',
        confirm=>'password',
        form => $self
    );

    $self->add($email)->add($pass1)->add($pass2);
}
