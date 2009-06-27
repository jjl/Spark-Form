package TestApp::Form::Field::Password;

use Moose;
extends 'Spark::Form::Field';
with 'Spark::Form::Field::Role::Validateable';

has confirm => (
    isa => 'Maybe[Str]',
    is => 'ro',
);

sub validate {
    my ($self) = @_;

    if (length ($self->value||'') < 6) {
        $self->error('Password must be at least 6 characters long');
    }
    if ($self->confirm) {
        my $other = $self->form->get($self->confirm);
        if ($other->value ne $self->value) {
            $self->error('passwords must match');
        }
    }
}

sub to_html {
    q{<input type="password">};
}

sub to_xhtml {
    q{<input type="password" />};
}


1;
