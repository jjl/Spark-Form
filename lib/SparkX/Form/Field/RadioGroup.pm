package SparkX::Form::Field::RadioGroup;

# ABSTRACT:  A Radio group field for SparkX::Form

use Moose;
use HTML::Tiny;
use Spark::Types qw(SCouplet);
extends 'Spark::Form::Field';
with 'Spark::Form::Field::Role::Printable::HTML',
  'Spark::Form::Field::Role::Printable::XHTML';

has '+value' => (
    isa => 'Str',
);

has options => (
    isa      => SCouplet,
    is       => 'rw',
    coerce   => 1,
    required => 0,
    lazy     => 1,
    default  => sub { return shift->value },
    handles  => {
        options_kv => 'key_values_paired',
    },
);

sub to_html {
    return shift->_render(HTML::Tiny->new(mode => 'html'));
}

sub to_xhtml {
    return shift->_render(HTML::Tiny->new(mode => 'xml'));
}

sub _render_element {
    my ($self, $html, $name, $value, $count) = @_;
    my $id = (join q{-}, $self->name, $count);
    my $label = $html->label({for => $id}, $name);
    my $input = $html->input({
            type  => 'radio',
            value => $value,
            id    => $id,
    });
    return (join qq{\n}, $label, $input);
}

sub _render {
    my ($self, $html) = @_;
    my $count;    # We use this to generate unique IDs for the labels
    my @options = map {
        $self->_render_element(
            $html,       # HTML::Tiny
            @{$_},       # Key, Value strings
            ++$count,    # Uniquifier
        );
    } $self->options_kv;
    return join "\n", @options;
}
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 ATTRIBUTES

=head2 options => L<Spark::Couplet>

Text => value pairs. Coerces from ArrayRef with regular list inside

=head1 METHODS

=head2 to_html() => Str

Renders the field to HTML

=head2 to_xhtml() => Str

Renders the field to XHTML

=head2 validate() => Bool

Validates the field. Before composition with validators, always returns 1.

=head1 SEE ALSO

L<SparkX::Form> - The forms module this is to be used with
L<SparkX::Form::BasicFields> - A collection of fields for use with C<Spark::Form>

=cut
