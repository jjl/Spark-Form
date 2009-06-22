package SparkX::Form::Field::MultiSelect;

use Moose;
use HTML::Tiny;
use List::Util 'first';

extends 'Spark::Form::Field';
with 'Spark::Form::Field::Role::Printable::HTML',
     'Spark::Form::Field::Role::Printable::XHTML';

has '+value' => (
    isa => 'ArrayRef[Str]',
);

has options => (
    isa => 'ArrayRef',
    is => 'rw',
    required => 0,
    lazy => 1,
    default => sub { shift->value },
);

sub to_html {
    shift->_render( HTML::Tiny->new( mode => 'html') );
}

sub to_xhtml {
    shift->_render( HTML::Tiny->new( mode => 'xml') );
}

sub _is_selected {
    my ($self,$value) = @_;

    first {$value eq $_} @{$self->value};
}

sub _render {
    my ($self,$html) = @_;
    $html->select({name => $self->name, multiple=>'multiple'},
        join(' ',
            map {
                my $__ = $_;
                $html->option({
                    value => $_,
                    ($self->_is_selected($_) ? (selected => 'selected') : ()),
                })
            } @{$self->options}
        )
    );
}

1;
__END__

=head1 NAME

SparkX::Form::Field::MultiSelect - A multiple select dropdown field for SparkX::Form

=head1 METHODS

=head2 to_html() => Str

Renders the field to html

=head2 to_xhtml() => Str

Renders the field to xhtml

=head1 SEE ALSO

L<SparkX::Form> - The forms module this is to be used with
L<SparkX::Form::BasicFields> - A collection of fields for use with C<Spark::Form>

=cut
