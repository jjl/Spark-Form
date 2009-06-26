package Spark::Form::Role::Printable::HTML;

use Moose::Role;
with 'Spark::Form::Role::Printable';
requires 'to_html';

1;
__END__

=head1 NAME

Spark::Form::Role::Printable::HTML - Inherit this if your printer module prints a form in HTML

=head1 SEE ALSO

L<Spark::Form> - You probably are more interested in this

=cut
