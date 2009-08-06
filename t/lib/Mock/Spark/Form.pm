package Mock::Spark::Form;

use Test::MockObject::Extends;

sub new {
    my $t = Test::MockObject::Extends->new('Spark::Form');
    $t;
}
