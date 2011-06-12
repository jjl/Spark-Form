use strict;
package Spark::Form::Role::ErrorStore;

# ABSTRACT: A mix-in for adding an internal error storage mechanism.

use Moose::Role 0.90;
use namespace::autoclean;

requires 'valid';

=head2 errors()  : Array[Str]

Returns a list of all errors encountered so far

=cut

has _errors => (
    isa      => 'ArrayRef[Str]',
    is       => 'ro',
    required => 0,
    default  => sub { [] },
    traits   => [qw( Array )],
    handles  => {
        '_add_error'    => 'push',
        'errors'        => 'elements',
        '_clear_errors' => 'clear',
    },
);

=head2 error ( Str )

Adds an error to the current field's list.

=cut

sub error {
    my ($self, $error) = @_;

    $self->valid(0);
    $self->_add_error($error);

    return $self;
}

1;

