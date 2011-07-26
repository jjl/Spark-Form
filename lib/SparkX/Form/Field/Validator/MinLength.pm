use strict;
package SparkX::Form::Field::Validator::MinLength;

# ABSTRACT: Validates a field is at least a given size

use Moose::Role;

has min_length => (
    isa      => 'Maybe[Int]',
    is       => 'rw',
    required => 0,
    default  => 0,
);

has errmsg_too_short => (
    isa      => 'Str',
    is       => 'rw',
    required => 0,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        return $self->human_name .
          ' must be at least ' .
          $self->min_length .
          ' characters long';
    },
);

sub _min_length {
    my ($self) = @_;

    return unless $self->min_length;

    if (length $self->value < $self->min_length) {
        $self->error($self->errmsg_too_short);
    }
    return $self;
}

after '_validate' => sub { return shift->_min_length };

1;
__END__

=head1 DESCRIPTION

A minimum length enforcement mix-in. Adds two fields plus action.
Makes sure that C<value> is at least C<min_length> characters long.

=head1 ACCESSORS

=head2 min_length => Int

The minimum length you desire. Required. In a subclass, you can:

 has '+min_length' => (required => 0,default => sub { $HOW_LONG });

if you want to have it optional with a default

=head2 errmsg_too_short => Str

Error message to be shown if C<value> is too short.

=cut
