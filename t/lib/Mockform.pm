package Mockform;

use Test::MockObject::Extends;

our @ISA = ('Test::MockObject');

sub new {
    my ($package, %opts) = @_;
    my $mock = Test::MockObject::Extends->new('Spark::Form');
}
