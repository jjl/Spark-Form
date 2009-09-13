package Spark::Form::Printer::HTML;

# ABSTRACT: the interface a HTML-printing form printer needs to implement
use Moose::Role;
with 'Spark::Form::Printer';

requires 'to_html';

1;
__END__

=head1 SEE ALSO

=over 4

=item L<Spark::Form> - The forms module that started it all

=item L<SparkX::Form::BasicPrinters> - Set of pre-canned form printers

=back

=cut
