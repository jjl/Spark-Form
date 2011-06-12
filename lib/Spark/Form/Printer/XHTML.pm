use strict;
package Spark::Form::Printer::XHTML;

# ABSTRACT: the interface an XHTML-printing form printer needs to implement

use Moose::Role;
with 'Spark::Form::Printer';

requires 'to_xhtml';

1;
__END__

=head1 SEE ALSO

=over 4

=item L<Spark::Form> - The forms module that started it all

=item L<SparkX::Form::BasicPrinters> - Set of pre-canned form printers

=back

=cut
