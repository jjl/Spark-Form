package Spark::Couplet;

use Data::Couplet::Extension -with => [qw(KeyCount BasicReorder)];
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 NAME

Spark::Couplet - A Spark-specific subclass of Data::Couplet

=cut
