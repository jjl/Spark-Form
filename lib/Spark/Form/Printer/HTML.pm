package Spark::Form::Printer::HTML;

use Moose::Role;
with 'Spark::Form::Printer';

requires 'to_html';

1;
__END__

=head1 NAME

Spark::Form::Printer::HTML - the interface a HTML-printing form printer needs to implement

=head1 SEE ALSO

L<Spark::Form> - The forms module that started it all
L<SparkX::Form::BasicPrinters> - Set of pre-canned form printers

=cut
