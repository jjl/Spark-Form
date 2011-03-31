package Spark::Form::Field::Role::NewValidator;

use Moose::Role;
use Spark::Form::Types ':all';

requires '_validate';

has _validators => (
    isa => ArrayRef[SFFieldValidator],
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
	
1;
__END__
