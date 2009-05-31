package Spark::Form::Field;

use Any::Moose '::Role';

requires 'validate';

has name  => (
    isa      => 'Str',
    is       => 'ro',
    required => 1,
);

has label => (
    isa      => 'Str',
    is       => 'rw',
    required => 0,
);

has valid => (
    isa      => 'Bool',
    is       => 'rw',
    required => 0,
    default  => 0,
);

has errors => (
    isa      => 'ArrayRef[Str]',
    is       => 'rw',
    required => 0,
    default  => sub{[]},
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

sub error {
    my ($self,$error) = @_;

    $self->valid(0);
    push @{$self->errors}, $error;
}

sub human_name {
    my ($self) = @_;

    return ($self->label || $self->name||'');
}

before 'validate' => sub {
    shift->errors([]);
};

1;
__END__

=head1 DESCRIPTION

Field role. Must implement this to be considered a field.

=head1 ACCESSORS

=head2 name => Str

Name of the field in the data source. Will be slurped on demand.
Required at validation time, not at construction time.

=head2 label => Str

Optional. Human readable label for the field.

=head2 valid => Bool

Treat as readonly. Whether the field is valid.

=head2 errors => ArrayRef

Treat as readonly. The list of errors generated in validation.

=head2 form => Spark::Form

Reference to the form it is a member of.

=head2 value => Any

Value in the field.

=head1 METHODS

=head2 error (Str)

Adds an error to the current field's list.

=head2 human_name

Returns the label if present, else the field name.

=head1 INTERFACE

To be considered a field, you need to implement this role.

It requires the following methods:

=head2 validate

This should take C<value> and set C<valid> to 1 or call C<error>.

=head1 SEE ALSO

L<Spark::Form::Field::Role::Comparable> - Fields that need to match (eg. email)
L<Spark::Form::Field::Role::Regexp> - Fields validated by a simple regexp

=cut
