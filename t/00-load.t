#!perl -T

use Test::More;
use Test::UseAllModules;
use Test::NoWarnings;

plan tests => Test::UseAllModules::_get_module_list() + 1;

diag("Testing Spark::Form $Spark::Form::VERSION, Perl $], $^X");

all_uses_ok();

