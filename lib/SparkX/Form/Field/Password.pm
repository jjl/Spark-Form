use strict;
package SparkX::Form::Field::Password;

# ABSTRACT: A Password field for SparkX::Form

use Moose;
use HTML::Tiny;

extends 'Spark::Form::Field';
with 'Spark::Form::Field::Role::Printable::HTML',
  'Spark::Form::Field::Role::Printable::XHTML';

has '+value' => (
    isa => 'Str',
);

sub to_html {
    return shift->_render(HTML::Tiny->new(mode => 'html'));
}

sub to_xhtml {
    return shift->_render(HTML::Tiny->new(mode => 'xml'));
}

sub _render {
    my ($self, $html) = @_;

    return $html->input({type => 'password', name => $self->name});
}

__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 METHODS

=head2 to_html() => Str

Renders the field to HTML

=head2 to_xhtml() => Str

Renders the field to XHTML

=head2 validate() => Bool

Validates the field. Before composition with validators, always returns 1.

=head1 SEE ALSO

=over 4

=item L<SparkX::Form> - The forms module this is to be used with

=item L<SparkX::Form::BasicFields> - A collection of fields for use with C<Spark::Form>

=back

=cut
