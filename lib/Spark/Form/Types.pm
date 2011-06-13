use strict;
use warnings;

package Spark::Form::Types;

# ABSTRACT: Utility Type-Library for Spark::Form

use MooseX::Types::Moose qw(:all);
use MooseX::Types -declare => [
    qw(
      PluginNamespaceList
      SparkFormField
      SparkForm
      LabelledObject
      NamedObject
      SCouplet
      SForm
      SField
      SFieldValidator
      )
];

subtype PluginNamespaceList, as ArrayRef [Str];

coerce PluginNamespaceList, from Str, via { [$_] };

coerce PluginNamespaceList, from Undef, via { [] };

class_type SparkFormField, {class => 'Spark::Form::Field'};

class_type SparkForm, {class => 'Spark::Form'};

subtype LabelledObject, as Object, where {
    $_->can('label') and $_->label;
};

subtype NamedObject, as Object, where {
    $_->can('name') and $_->name;
};
class_type SCouplet,        {class => 'Spark::Couplet'};
class_type SForm,           {class => 'Spark::Form'};
class_type SField,          {class => 'Spark::Form::Field'};
class_type SFieldValidator, {class => 'Spark::Form::Field::Validator'};

1;
__END__
