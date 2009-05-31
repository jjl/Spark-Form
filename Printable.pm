package Spark::Form::Field::Role::Printable;

use Any::Moose '::Role';
with 'Spark::Form::Field';

requires 'to_html';


