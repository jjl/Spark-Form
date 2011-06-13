package Spark::Form::Field::Role::NewValidator;

use Moose::Role;
use Spark::Form::Types ':all';
use MooseX::Types::Moose ':all';

requires '_validate';

has _validators => (
    isa => ArrayRef[SFieldValidator],
    is => 'rw',
    init_arg => undef,
    default => sub { [] },
    traits => ['Array'],
    handles => {
        validators => 'elements',
    },
);

after _validate => sub {
    my ($self) = @_;
    $_->validate for $self->validators;
};

__PACKAGE__->meta->make_immutable;
1;
__END__
