package Spark::GPC;

use Carp qw();
use Moose;

### ABSTRACT: A container for Get/Post/Cookie values

### Pure list of values
has items_a => (
    isa     => 'ArrayRef[Str]',
    is      => 'ro',
    traits  => ['Array'],
    handles => {
        push_a => 'push',
    },
);

### List of indices in the array from which to pick values for the given key
has items_h => (
    isa     => 'HashRef[ArrayRef[Int]]',
    is      => 'ro',
    traits  => ['Hash'],
    handles => {
        set_h => 'set',
        get_h => 'get',
        del_h => 'delete',
    },
);

# Push hash-like lists of values (to permit multiple values per key)

sub pairwise {
    my ($self, @values) = @_;

    Carp::croak('Uneven number of values') if (@values % 2);

    # Roughly equivalent to smalltalk's inject.
    # even iterations are keys, odd are values
    my ($i, $k);
    for my $v (@values) {
        $self->push($last, $v) if $i++ % 2;
        $last = $v;
    }
}

# Push a single key, value pair

sub push {
    my ($self, $key, $value) = @_;

    Carp::croak('Key must not be null') unless ($key && defined $value);

    my $index = ($self->push_a($value)) - 1;
    $self->set_h([
            $key,

            # I hate the way this looks, but you know what it does
            # Perhaps I should invest in a better font?
            (@{$self->get_h($key) || []}, $index),
    ]);
}

sub get {
    my ($self, $key) = @_;

    Carp::croak('Key must not be null') unless ($key);

    my @keys = @{$self->get_h($key) || []};
    map { $self->get($_) } @keys;
}

sub get_one {
    my ($self, $key) = @_;

    Carp::croak('Key must not be null') unless ($key);

    my @results = $self->get($key);
    Carp::carp("Too many results, one requested for key: $key") if (@results > 1);

    @results ? pop @results : ();
}

# There you go, Kent, I have implemented the essentials of Data::Couplet in a fast way in <100 clear, commented loc. I'll take my trophy back now, kthx.
#
# Lol. Needs More Crack -- kentnl

__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

