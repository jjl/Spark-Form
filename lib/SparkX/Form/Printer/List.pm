package SparkX::Form::Printer::List;

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

=head1 NAME

SparkX::Form::Printer::List - A list-printer for SparkX::Form. Spouts out form elements in a (X)HTML list.

=head1 VERSION

Version 0.01

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 to_html

Prints the form to html

=head2 to_xhtml

Prints the form to xhtml

=head1 AUTHOR

James Laver, C<< <printf(qw[%s at %s.%s cpan jameslaver com])> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-sparkx-form-printer-list at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=SparkX-Form-Printer-List>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=SparkX-Form-Printer-List>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/SparkX-Form-Printer-List>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 James Laver, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
