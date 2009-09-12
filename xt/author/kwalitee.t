use strict;
use warnings;

use Test::More;

BEGIN {
  eval { require Test::Kwalitee; 1 }
    or plan skip_all => "You need Test::Kwalitee installed to run this test. Its only an authortest though, so thats ok";
}
use Test::Kwalitee tests => [qw( -use_strict )];
