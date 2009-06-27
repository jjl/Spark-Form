package Spark::Form::Printer::XHTML;

use Moose::Role;
with 'Spark::Form::Printer';

requires 'to_xhtml';

1;
__END__

=head1 NAME

Spark::Form::Printer::HTML - the interface an XHTML-printing form printer needs to implement

=head1 SEE ALSO

L<Spark::Form> - The forms module that started it all
L<SparkX::Form::BasicPrinters> - Set of pre-canned form printers

=cut
