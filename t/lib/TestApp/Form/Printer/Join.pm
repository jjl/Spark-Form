package TestApp::Form::Printer::Join;
use Moose::Role;
with 'Spark::Form::Printer';

use HTML::Tiny;

our $VERSION = '0.01';

sub to_xhtml {
    shift->_render('to_xhtml',HTML::Tiny->new( mode => 'xml' ),@_);    
}

sub to_html {
    shift->_render('to_html',HTML::Tiny->new( mode => 'html' ),@_);    
}

sub _render {
    my ($self, $func, $html, @params) = @_;

    join(' ', $self->_get_items($func,$html));
}

sub _get_items {
    my ($self,$func,$html) = @_;

    map {
        $_->$func();
    } $self->fields_a;
}

1;
__END__

