package Spark::Form::Field::Mandatory;

use Any::Moose;
with 'Spark::Form::Field';
with 'Spark::Form::Field::Role::NotEmpty';
with 'Spark::Form::Field::Role::Regex';
with 'Spark::Form::Field::Role::MinLength';
with 'Spark::Form::Field::Role::MaxLength';
with 'Spark::Form::Field::Role::Confirm';

has '+regex' => (
    required => 0,
    default  => sub {undef},
);

has '+min_length' => (
    required => 0,
    default  => sub {undef},
);

has '+max_length' => (
    required => 0,
    default  => sub {undef},
);

has '+confirm' => (
    required => 0,
    default  => sub {undef},
);

sub validate {
    #Will be overridden by ::Role::Regex if necessary
    shift->valid(1);
}

1;
__END__

=head1 DESCRIPTION

A basic, mandatory form field for Spark::Form.
Implements Spark::Form::Field::Role::{{Min,Max}Length,NotEmpty,Regex,Confirm}

=head1 SYNOPSIS

 use Spark::Form;
 $form = Spark::Form->new;
 $form->add(
     'mandatory','username',
     min_length=>6,
     max_length=>2,
     regex=>qr/^[a-zA-Z_-]+$/
 );
 $form->data({username => 'Test'});
 $form->validate;
 print join "\n",("Errors:",@{$form->errors}) unless $form->valid;

=head1 METHODS

=head2 validate ($value)

1;

=head1 OPTIONS

=head1 SEE ALSO

L<Spark::Form::Field::Role::Regex>
L<Spark::Form::Field::Role::MinLength>
L<Spark::Form::Field::Role::MaxLength>
L<Spark::Form::Field::Role::NotEmpty>
L<Spark::Form::Field::Role::Confirm>

=cut
