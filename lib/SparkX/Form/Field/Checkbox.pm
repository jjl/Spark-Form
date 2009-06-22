package SparkX::Form::Field::Checkbox;

use Moose;
use HTML::Tiny;

extends 'Spark::Form::Field';
with 'Spark::Form::Field::Role::Printable::HTML',
     'Spark::Form::Field::Role::Printable::XHTML';

has '+value' => (
    isa => 'Str',
);

sub to_html {
    shift->_render( HTML::Tiny->new( mode => 'html') );
}

sub to_xhtml {
    shift->_render( HTML::Tiny->new( mode => 'xml') );
}
 
sub _render {
    my ($self,$html) = @_;
    
    $html->input({
        type => 'checkbox',
        value => 1,
        ($self->value ? (checked => 'checked') : ()),
        name => $self->name
    });
}

1;
__END__

=head1 NAME

SparkX::Form::Field::Checkbox - A Checkbox field for SparkX::Form

=head1 METHODS

=head2 to_html() => Str

Renders the field to html

=head2 to_xhtml() => Str

Renders the field to xhtml

=head1 SEE ALSO

L<SparkX::Form> - The forms module this is to be used with
L<SparkX::Form::BasicFields> - A collection of fields for use with C<Spark::Form>

=cut
