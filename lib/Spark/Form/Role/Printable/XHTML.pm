package Spark::Form::Role::Printable::XHTML;

use Moose::Role;
with 'Spark::Form::Role::Printable';
requires 'to_xhtml';

1;
__END__

=head1 NAME

Spark::Form::Role::Printable::XHTML - Inherit this if your printer module prints a form in XHTML

=head1 SEE ALSO

L<Spark::Form> - You probably are more interested in this

=cut
