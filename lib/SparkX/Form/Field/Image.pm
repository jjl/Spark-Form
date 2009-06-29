package SparkX::Form::Field::Image;

use Moose;
use HTML::Tiny;

extends 'Spark::Form::Field';
with 'Spark::Form::Field::Role::Printable::HTML',
     'Spark::Form::Field::Role::Printable::XHTML';

has '+value' => (
    isa => 'Str',
);

has 'names' => (
    lazy => 1,
    (Moose->VERSION >= 0.84 ) ? (is => 'bare') : (),
    default => sub {
        my $self = shift;

        [$self->name . ".x", $self->name . ".y"]
    },
);

sub to_html {
    shift->_render( HTML::Tiny->new( mode => 'html' ) );
}

sub to_xhtml {
    shift->_render( HTML::Tiny->new( mode => 'xml') );
}
 
sub _render {
    my ($self,$html) = @_;
    
    $html->input({type => 'image', name => $self->name});
}

1;
__END__

=head1 NAME

SparkX::Form::Field::Image - An image field for SparkX::Form

Note that this does not support server-side image map functionality but will be treated as a submit. Patches welcome that don't break this (99% of the time desired) behaviour.

=head1 METHODS

=head2 to_html() => Str

Renders the field to html

=head2 to_xhtml() => Str

Renders the field to xhtml

=head1 SEE ALSO

L<SparkX::Form> - The forms module this is to be used with
L<SparkX::Form::BasicFields> - A collection of fields for use with C<Spark::Form>

=cut
