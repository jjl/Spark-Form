package SparkX::Form::Field::Dummy;

# ABSTRACT: A Dummy field for SparkX::Form

use Moose;
use HTML::Tiny;

extends 'Spark::Form::Field';

has '+value' => (
    isa => 'Str',
);

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 PURPOSE

Right now, for hanging arbitrary validations against other fields off. This will be fixed

=head1 METHODS

=head2 validate() => Bool

Validates the field. Before composition with validators, always returns 1.

=head1 SEE ALSO

L<SparkX::Form> - The forms module this is to be used with
L<SparkX::Form::BasicFields> - A collection of fields for use with C<Spark::Form>

=cut
