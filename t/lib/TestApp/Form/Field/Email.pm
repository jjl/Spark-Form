package TestApp::Form::Field::Email;

use Moose;
extends 'Spark::Form::Field';
with 'Spark::Form::Field::Role::Validateable';

sub validate {
    my ($self) = @_;
    # This regexp is intentionally crap. It's a test. don't use this in real code
    my $valid = $self->value =~ /^[a-z.0-9_-]+@[a-z.0-9_-]+\.(com|org|net|museum|co\.[a-z]{2})$/;
    $self->error("That does not look like an email!") unless $valid;
}

sub to_html {
    q{<input type="text" value="} . (shift->value||'') . q{" >}
}

sub to_xhtml {
    q{<input type="text" value="} . (shift->value||'') . q{" />}
}

1;
