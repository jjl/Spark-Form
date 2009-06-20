package Spark::Form::Field::Role::Printable;

use Moose::Role;

has label => (
    isa      => 'Str',
    is       => 'rw',
    required => 0,
);

1;
__END__

=head1 NAME

Spark::Form::Field::Role::Printable - Printability for form fields

=head1 DESCRIPTION

A fairly free-form module, this is mostly used for checking that it's printable at all.
You probably want one of the roles under this hierarchy, but not just this one.

=head1 SYNOPSIS

 package MyApp::Field::CustomText;
 use Moose;
 extends 'Spark::Form::Field';
 with 'Spark::Form::Field::Role::Printable';
 
 sub to_string {
     my $self = shift;
     sprintf("%s: %s",$self->label, $self->value);
 }

=head1 VARS

=head2 label :: Str [Optional]

A label that will be printed next to said field in the printed out version

=head1 SEE ALSO

L<Spark::Form::Field::Printable::HTML> - Role for being printable under HTML4
L<Spark::Form::Field::Printable::XHTML> - Role for being printable under XHTML1

=cut