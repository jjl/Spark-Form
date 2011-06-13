package Spark::Form::Field::Validator;

use Moose;

has field => (
    isa      => 'Spark::Form::Field',
    is       => 'rw',
    required => 1,
    weak_ref => 1,
);

sub validate {
    require Carp;
    Carp::carp('Spark::Form::Field::Validator must be subclassed, not used directly');
    return;
}

__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 NAME

Spark::Form::Field::Validator - Base class for field validator objects

=head1 SYNOPSIS

 package MyApp::Validator::Numeric;
 use Moose;
 extends 'Spark::Form::Field::Validator';

 sub validate {
   my $self = shift;
   unless ($self->field =~ /^[0-9]+$/) {
     $self->field->error("$self->field->human_name is not numeric");
   }
 }

=head1 COPYRIGHT

Copyright 2011 James Laver

=head1 LICENCE

Licensed under the same terms as Perl itself.

=cut
