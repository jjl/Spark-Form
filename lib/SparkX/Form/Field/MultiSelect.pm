package SparkX::Form::Field::MultiSelect;

# ABSTRACT: A multiple select drop-down field for SparkX::Form

use Moose;
use HTML::Tiny;
use List::Util 'first';

extends 'Spark::Form::Field';
with 'Spark::Form::Field::Role::Printable::HTML',
  'Spark::Form::Field::Role::Printable::XHTML';

has '+value' => (
    isa => 'ArrayRef[Str]',
);

has options => (
    isa      => 'ArrayRef',
    is       => 'rw',
    required => 0,
    lazy     => 1,
    default  => sub { return shift->value },
);

sub to_html {
    return shift->_render(HTML::Tiny->new(mode => 'html'));
}

sub to_xhtml {
    return shift->_render(HTML::Tiny->new(mode => 'xml'));
}

sub _is_selected {
    my ($self, $value) = @_;

    return first { $value eq $_ } @{$self->value};
}

sub _render_option {
    my ($self, $html, $option) = @_;
    return $html->option({
            value => $option,
            ($self->_is_selected($option) ? (selected => 'selected') : ()),
    });
}

sub _render {
    my ($self, $html) = @_;
    my @options = map { $self->_render_option($html, $_) } @{$self->options};

    return $html->select(
        {name => $self->name, multiple => 'multiple'}, join q{ }, @options
    );
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
