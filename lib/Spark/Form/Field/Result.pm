package Spark::Form::Field::Result;

use Moose;

has results => (
    isa => 'ArrayRef[Spark::Form::Field::Validator::Result]',
    is => 'ro',
    required => 1,
    traits => ['Array'],
    handles => {
        push => 'push',
        first_r => 'first',
        grep_r => 'grep',
    }
);

sub bool {
    my ($self) = @_;
    $self->first_r(sub {
        !$_->bool
    });
}

sub messages {
    my ($self) = @_;
    $self->grep_r(sub {
        !$_->bool && $_->message
    });
}

1;
