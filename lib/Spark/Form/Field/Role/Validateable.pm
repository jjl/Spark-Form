package Spark::Form::Field::Role::Validateable;

use Moose::Role;
use MooseX::AttributeHelpers;

requires 'validate';

has valid => (
    isa      => 'Bool',
    is       => 'rw',
    required => 0,
    default  => 0,
);

has _errors => (
    metaclass => 'Collection::Array',
    isa       => 'ArrayRef[Str]',
    is        => 'ro',
    required  => 0,
    default   => sub{[]},
    provides  => {
        push     => '_add_error',
        elements => 'errors',
        clear    => '_clear_errors',
    },
);

sub error {
    my ($self,$error) = @_;

    $self->valid(0);
    $self->_add_error($error);
}

before 'validate' => sub {
    my ($self) = @_;
    $self->_clear_errors;
    $self->valid(1);
    #Set a default of the empty string, suppresses a warning
    $self->value($self->value||'');
};

1;
__END__

=head1 NAME

Spark::Form::Field::Role::Validateable - Fields that can be validated.

=head1 SYNOPSIS

 package MyApp::Field::CustomText;
 use Moose;
 extends 'Spark::Form::Field';
 with 'Spark::Form::Field::Role::Validateable';
 
 sub validate {
     my $self = shift;
     
     if ($self->value eq 'password') {
         $self->valid(1);
         return 1;
     } else {
         $self->error('password is password');
         return 0;
     }
 }
 
=head1 ACCESSORS

=head2 valid => Bool

Treat as readonly. Whether the field is valid.

=head2 errors => ArrayRef

Treat as readonly. The list of errors generated in validation.

=head1 METHODS

=head2 error (Str)

Adds an error to the current field's list.

=head1 INTERFACE

To be considered validateable, you must implement this role.

It requires the following methods:

=head2 validate

This should take C<value> and set C<valid> to 1 or call C<error>.
It should also return C<valid>.

=head1 SEE ALSO

=cut
