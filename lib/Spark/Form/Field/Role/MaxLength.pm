package Spark::Form::Field::Role::MaxLength;

use Any::Moose '::Role';

has max_length => (
    isa      => 'Maybe[Int]',
    is       => 'ro',
    required => 1,
);
    
has errmsg_too_long => (
    isa      => 'Str',
    is       => 'ro',
    required => 0,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        $self->human_name .
        " must be no more than " .
        $self->max_length .
        " characters long";
    },
);

sub _max_length {
    my ($self) = @_;

    return unless $self->max_length;

    if (length $self->value > $self->max_length) {
        $self->error($self->errmsg_too_long);
    }
}

after 'validate' => sub {shift->_max_length};

1;
__END__

=head1 DESCRIPTION

A maximum length enforcement mixin. Adds two fields plus action.
Makes sure that C<value> is at most C<max_length> characters long.

=head1 ACCESSORS

=head2 max_length => Int

The maximum length you desire. Required. In a subclass, you can:

 has '+max_length' => (required => 0,default => sub { $HOW_LONG });

if you want to have it optional with a default

=head2 errmsg_too_long => Str

Error message to be shown if C<value> is too long.

=cut
