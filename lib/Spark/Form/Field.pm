use strict;
package Spark::Form::Field;

# ABSTRACT: Superclass for all Form Fields

use Moose 0.90;
use MooseX::Types::Moose qw( :all );
use Spark::Form::Types qw( :all );
use MooseX::LazyRequire;
use Spark::Form::Field::Result;

with 'MooseX::Clone';
with 'Spark::Form::Role::Validity';
with 'Spark::Form::Role::ErrorStore';

has name => (
    isa      => Str,
    is       => 'ro',
    required => 1,
);

has form => (
    isa           => SparkForm,
    is            => 'rw',
    lazy_required => 1,
    weak_ref      => 1,              #De-circular-ref
    traits        => ['NoClone'],    #Argh, what will it be set to?
);

has value => (
    is       => 'rw',
    required => 0,
);

sub human_name {
    my ($self) = @_;

    if (is_LabelledObject($self)) {
        return $self->label;
    }
    if (is_NamedObject($self)) {
        return $self->name;
    }
    return q();
}

sub validate {
    my ($self) = @_;
    my $result = Spark::Form::Field::Result->new;
    $self->_clear_errors;
    $self->valid(1);

    #Set a default of the empty string, suppresses a warning
    $self->value($self->value || q());
    $self->_validate;
    # This for moose roles interaction
    return $self->valid;
}

sub _validate { return 1 }

__PACKAGE__->meta->make_immutable;
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

 sub _validate {
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

There are a bunch of pre-built fields you can actually use in
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

Treat as read-only. Whether the field is valid.

=head2 errors => ArrayRef

Treat as read-only. The list of errors generated in validation.

=head1 METHODS

=head2 human_name

Returns the label if present, else the field name.

=head2 validate

Returns true always. Subclass and fill in C<_validate> to do proper validation. See the synopsis.

=head1 SEE ALSO

=over 4

=item L<Spark::Form::Field::Role::Printable> - Fields that can be printed

=item L<SparkX::Form::BasicValidators> - Set of validators to use creating fields

=item L<SparkX::Form::BasicFields> - Ready to use fields

=back

=cut
