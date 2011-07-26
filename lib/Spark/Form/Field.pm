use strict;
package Spark::Form::Field;

# ABSTRACT: Superclass for all Form Fields

use Moose 0.90;
use MooseX::Types::Moose qw( :all );
use Spark::Form::Types qw( :all );
use MooseX::LazyRequire;
use Spark::Util qw(field_result field_validator_result);

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

has _validators => (
    isa => 'ArrayRef[Spark::Form::Field::Validator]',
    is => 'rw',
    default => sub { [] },
    traits => ['Array'],
    handles => {
        'validators' => 'elements',
    }
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
    my ($self,$gpc) = @_;
    my $result = Spark::Form::Field::Result->new;
    if ($self->can('_validate')) {
        my @ret = $self->_validate($gpc);
	$result->push(field_result(@ret));
    }
    foreach my $v (@{$self->validators}) {
        my @ret = $v->validate($self,$gpc);
        $result->push(field_validator_result(@ret));
    }

    return $return;
}

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
     my ($self,$result,$value) = @_;

     # Really simple validation...
     # Implicit result is success, so ignore that case
     if (!$value) {
         $result->fail('no value');
     }

     #And return the result object
     return $result;
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
