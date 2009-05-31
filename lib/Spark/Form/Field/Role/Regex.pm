package Spark::Form::Field::Role::Regex;

use Any::Moose '::Role';

has regex => (
    isa      => 'Maybe[Regexp]',
    is       => 'ro',
    required => 0,
    default  => sub {undef},
);

has errmsg_regex => (
    isa      => 'Str',
    is       => 'ro',
    required => 0,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        $self->human_name . " failed the regex."
    },
);

sub _regex {
    my ($self) = @_;

    return unless $self->regex;

    if ($self->value !~ $self->regex) {
        $self->error($self->errmsg_regex);
    }
}

after 'validate' => sub {shift->_regex};

1;
__END__

=head1 DESCRIPTION

A regex validation mixin. Adds two fields plus action.
Makes sure that C<value> matches the regex.

=head1 ACCESSORS

=head2 regex => Str

RegexRef to match.
Required, no default.

=head2 errmsg_regex => Str

Allows you to provide a custom error message for when the match fails.
Required, no default.

=cut
