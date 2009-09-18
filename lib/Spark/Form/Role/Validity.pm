use strict;
use warnings;

package Spark::Form::Role::Validity;

# ABSTRACT: Common Code for determining the validity of a thing.

use Moose::Role;
use MooseX::Types::Moose qw( :all );
use namespace::autoclean;

has valid => (
  isa      => Bool,
  is       => 'rw',
  required => 0,
  default  => 0,
);

1;

