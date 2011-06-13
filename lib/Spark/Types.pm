package Spark::Types;

use MooseX::Types
  -declare => [qw(
      SCouplet
      SForm
      SField
      SFieldValidator
      )];

use MooseX::Types::Moose qw(ArrayRef);

use Spark::Couplet;

class_type SCouplet, {class => 'Spark::Couplet'};
coerce SCouplet,
  from ArrayRef,
  via { Spark::Couplet->new(@{$_}) };

class_type SForm,           {class => 'Spark::Form'};
class_type SField,          {class => 'Spark::Form::Field'};
class_type SFieldValidator, {class => 'Spark::Form::Field::Validator'};

1;
__END__
