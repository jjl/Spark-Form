package Spark::Form::Field::Role::Confirm;

use Any::Moose '::Role';

has confirm => (
    isa      => 'Maybe[Str]',
    is       => 'ro',
    required => 0,
    lazy     => 1,
    default  => sub { undef },
);

has errmsg_confirm => (
    isa      => 'Str',
    is       => 'ro',
    required => 0,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        $self->human_name .
        " must match " .
        $self->_confirm_human_name
    },
);

sub _confirm_field {
    my ($self) = @_;
    
    $self->form->get($self->confirm);
}

sub _confirm_human_name {
    my ($self) = @_;
    
    $self->_confirm_field->human_name;
}

sub _confirm {
    my ($self) = @_;

    return unless $self->confirm;

    if ($self->value ne $self->_confirm_field->value) {
        $self->error($self->errmsg_confirm);
    }
}

after 'validate' => sub {shift->_confirm};

1;
__END__

=head1 DESCRIPTION

A confirmation comparison mixin. Adds two fields plus action.
Makes sure that the selected C<confirm> field matches this one.

=head1 ACCESSORS

=head2 confirm => Str

Name of the field whose value must match.
Required, no default.

=head2 errmsg_confirm => Str

Allows you to provide a custom error message for when the fields do not match.
Optional, Default = $human_name must match $confirm_human_name

=cut
