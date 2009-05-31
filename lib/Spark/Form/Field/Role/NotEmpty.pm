package Spark::Form::Field::Role::NotEmpty;

use Any::Moose '::Role';

has errmsg_empty => (
    isa      => 'Str',
    is       => 'ro',
    required => 0,
    default  => sub {
        my $self = shift;
        $self->human_name .
        " must be provided."
    },
);

sub _not_empty {
    my ($self) = @_;

    unless ($self->value) {
        $self->error($self->errmsg_empty);
    }
}

after 'validate' => sub {shift->_not_empty};

1;
__END__

=head1 DESCRIPTION

A not empty enforcement mixin. Adds one field plus action.
Makes sure that C<value> is not empty.

=head1 ACCESSORS

=head2 errmsg_empty => Str

Error message to be shown to the user if C<value> is empty.

=cut
