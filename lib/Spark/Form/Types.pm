use strict;
use warnings;

package Spark::Form::Types;

# ABSTRACT: Utility Type-Library for Spark::Form

use MooseX::Types::Moose qw(:all);
use MooseX::Types -declare => [
  qw(
    PluginNamespaceList
    FormField
    )
];

subtype PluginNamespaceList, as ArrayRef [Str];

coerce PluginNamespaceList, from Str, via { [$_] };

coerce PluginNamespaceList, from Undef, via { [] };

classtype FormField, { class => 'Spark::Form::Field' };

1;

