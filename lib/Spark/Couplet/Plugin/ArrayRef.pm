package Spark::Couplet::Plugin::ArrayRef;

# ABSTRACT: A plugin giving an easy way to aggregate items based on a key name.

use Moose::Role;
with 'Data::Couplet::Role::Plugin';

sub add_arrayref {
    my ($self, $key, $value) = @_;
    my $v = $self->value($key) || [];
    return $self->set($key, [@{$v}, $value]);
}

sub get_arrayref {
    my ($self, $key) = @_;
    return @{$self->value($key) || []};
}

no Moose::Role;

1;
__END__
