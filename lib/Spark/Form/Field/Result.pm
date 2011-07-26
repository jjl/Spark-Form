package Spark::Form::Field::Result;

use Moose;

has _results => (
    isa     => 'ArrayRef[Spark::Form::Field::Validator::Result]',
    is      => 'ro',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        results => 'elements',
        push    => 'push',
        first_r => 'first',
        grep_r  => 'grep',
    },
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

__PACKAGE__->meta->make_immutable;
no Moose;

1;
