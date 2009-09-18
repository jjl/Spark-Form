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
    )
];

subtype PluginNamespaceList, as ArrayRef [Str];

coerce PluginNamespaceList, from Str, via { [$_] };

coerce PluginNamespaceList, from Undef, via { [] };

class_type SparkFormField, { class => 'Spark::Form::Field' };

class_type SparkForm, { class => 'Spark::Form' };

subtype LabelledObject, as Object, where {
  $_->can('label') and $_->label;
};

subtype NamedObject, as Object, where {
  $_->can('name') and $_->name;
};

1;

