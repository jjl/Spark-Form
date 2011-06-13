package Spark::Form::Loader;

use Moose;

has namespaces => (
    isa => 'ArrayRef[Str]',
    required => 1,
    default => sub { [] },
    traits => ['Array'],
    handles => {
        add_ns => 'push',
    },
);
__PACKAGE__->meta->make_immutable;
1;
