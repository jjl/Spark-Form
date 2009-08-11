package Spark::Form::Field;

use Moose;
use MooseX::AttributeHelpers;

has name  => (
    isa      => 'Str',
    is       => 'ro',
    required => 1,
);

has form => (
    isa      => 'Spark::Form',
    is       => 'rw',
    required => 1,
);

has value => (
    is       => 'rw',
    required => 0,
);

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

sub human_name {
    my ($self) = @_;

    $self->can('label') && $self->label or $self->name or '';
}

sub validate {
    my ($self) = @_;
    $self->_clear_errors;
    $self->valid(1);
    #Set a default of the empty string, suppresses a warning
    $self->value($self->value||'');        
    $self->_validate;
}

sub _validate { 1 }
1;
__END__

=head1 DESCRIPTION

Field superclass. Must subclass this to be considered a field.

=head1 SYNOPSIS

 package My::Field;
 use Moose;
 require Spark::Form::Field;
 extends 'Spark::Form::Field';
 with 'Spark::Form::Field::Role::Validateable';
 with 'Spark::Form::Field::Role::Printable::XHTML';
 
 sub validate {
     my $self = shift;
     
     #validate existence of data
     if ($self->value) {
         #If we're valid, we should say so
         $self->valid(1);
     } else {
         #error will call $self->valid(0) and also set an error.
         $self->error('no value')
     }
     
     #And we should return boolean validity
     $self->valid
 }
 
 sub to_xhtml {
     #Rather poorly construct an XHTML tag
     '<input type="checkbox" value="' . shift-value . '">';
 }
 
Note that you might want to look into HTML::Tiny.
Or better still, L<SparkX::Form::Field::Plugin::StarML>.

There are a bunch of prebuilt fields you can actually use in
L<SparkX::Form::BasicFields>.

=head1 ACCESSORS

=head2 name => Str

Name of the field in the data source. Will be slurped on demand.
Required at validation time, not at construction time.

=head2 form => Spark::Form

Reference to the form it is a member of.

=head2 value => Any

Value in the field.

=head2 valid => Bool

Treat as readonly. Whether the field is valid.

=head2 errors => ArrayRef

Treat as readonly. The list of errors generated in validation.

=head1 METHODS

=head2 human_name

Returns the label if present, else the field name.

=head2 validate

Returns true always. Subclass to do proper validation.

=head2 error (Str)

Adds an error to the current field's list.

=head1 SEE ALSO

L<Spark::Form::Field::Role::Validateable> - Fields that can be validated
L<Spark::Form::Field::Role::Printable> - Fields that can be printed
L<SparkX::Form::BasicValidators> - Set of validators to use creating fields
L<SparkX::Form::BasicFields> - Ready to use fields
=cut
