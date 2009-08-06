package SparkX::Form::Printer::List;

# ABSTRACT: A list-printer for SparkX::Form. Spouts out form elements in a (X)HTML list.

use Moose::Role;
with 'Spark::Form::Printer';

use HTML::Tiny;

sub to_xhtml {
    shift->_render('to_xhtml',HTML::Tiny->new( mode => 'xml' ),@_);
}

sub to_html {
    shift->_render('to_html',HTML::Tiny->new( mode => 'html' ),@_);
}

sub _render {
    my ($self,$func,$html,@params) = @_;
    $html->ul(join(' ',$self->_get_lis($func,$html)));
}

sub _get_lis {
    my ($self,$func,$html) = @_;
    map {
        $html->li($html->label($_->human_name)) =>
        $html->li($_->$func)
    } $self->fields;
}

1;
__END__

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 to_html

Prints the form to html

=head2 to_xhtml

Prints the form to xhtml

=head1 ACKNOWLEDGEMENTS

=cut
