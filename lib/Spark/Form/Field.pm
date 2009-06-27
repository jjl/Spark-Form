package Spark::Form::Field;

use Moose;

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

sub human_name {
    my ($self) = @_;

    $self->can('label') && $self->label or $self->name or '';
}

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
     #validate existence of data
     !!shift->value;
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

=head1 METHODS

=head2 human_name

Returns the label if present, else the field name.

=head1 SEE ALSO

L<Spark::Form::Field::Role::Validateable> - Fields that can be validated
L<Spark::Form::Field::Role::Printable> - Fields that can be printed
L<SparkX::Form::BasicValidators> - Set of validators to use creating fields
L<SparkX::Form::BasicFields> - Ready to use fields
=cut
