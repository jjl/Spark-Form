package SparkX::Form::Field::Validator::Regex;

# ABSTRACT: Validates a field matches a regular expression

use Moose::Role;

has regex => (
    isa      => 'Maybe[RegexpRef]',
    is       => 'rw',
    required => 0,
    default  => undef,
);

has errmsg_regex => (
    isa      => 'Str',
    is       => 'rw',
    required => 0,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        $self->human_name . ' failed the regex.'
    },
);

sub _regex {
    my ($self) = @_;

    return unless $self->regex;

    if ($self->value !~ $self->regex) {
        $self->error($self->errmsg_regex);
    }
    return $self;
}

after '_validate' => sub { return shift->_regex };

1;
__END__

=head1 DESCRIPTION

A regular expression validation mix-in. Adds two fields plus action.
Makes sure that C<value> matches the expression.

=head1 ACCESSORS

=head2 regex => Str

RegexRef to match.
Required, no default.

=head2 errmsg_regex => Str

Allows you to provide a custom error message for when the match fails.
Required, no default.

=cut
