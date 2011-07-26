use strict;
package Spark::Form;

# ABSTRACT: A simple yet powerful forms validation system that promotes reuse.

use Moose 0.90;
use MooseX::Types::Moose qw( :all );
use MooseX::LazyRequire;
use Spark::Form::Types qw( :all );
use List::MoreUtils 'all';
use Spark::Couplet ();
use Carp          ();
use Scalar::Util qw( blessed );
use Spark::Util qw(form_result form_validator_result);

with 'MooseX::Clone';
with 'Spark::Form::Role::Validity';
with 'Spark::Form::Role::ErrorStore';

has _fields => (
    isa      => 'Spark::Couplet',
    is       => 'ro',
    required => 0,
    default  => sub { Spark::Couplet->new },
    traits   => ['Clone',],
    reader   => 'field_couplet',
    handles  => {
        get       => 'value',
        get_at    => 'value_at',
        keys      => 'keys',
        fields    => 'values',
        remove    => 'unset_key',
        remove_at => 'unset_at',
    },
);

has _plugins => (
    isa        => 'Module::Pluggable::Object',
    is         => 'ro',
    init_arg   => undef,
    lazy_build => 1,
    handles    => {
        'field_mods' => 'plugins',
    },
);

# Extra-orinary user-defined search spaces

has plugin_ns => (
    isa     => PluginNamespaceList,
    coerce  => 1,
    is      => 'ro',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        '_plugin_nses' => 'elements',
    },
);

# Our search domains that are used everywhere
has plugin_default_ns => (
    isa      => PluginNamespaceList,
    init_arg => undef,
    is       => 'ro',
    default  => sub { ['SparkX::Form::Field', 'Spark::Form::Field'] },
    traits   => ['Array'],
    handles  => {
        '_plugin_default_nses' => 'elements',
    },
);

has '_printer' => (
    isa           => Str,
    is            => 'ro',
    lazy_required => 1,
    init_arg      => 'printer',
    predicate     => '_has_printer',
);
has '_printer_class' => (isa => RoleName, is => 'ro', lazy_build => 1, init_arg => undef,);
has '_printer_meta' => (isa => 'Moose::Meta::Role', is => 'ro', lazy_build => 1, init_arg => undef,);

sub BUILD {
    my ($self) = @_;
    if ($self->_has_printer) {
        $self->_printer_meta->apply($self);
    }
    return;
}

sub _build__plugins {
    my ($self) = @_;
    require Module::Pluggable::Object;
    return Module::Pluggable::Object->new(
        search_path => [$self->_plugin_nses, $self->_plugin_default_nses],
        required => 1,
    );
}

sub _build__printer_class {
    my ($self, @rest) = @_;
    my $printer = $self->_printer;
    eval "require $printer; 1" or Carp::croak("Require of $printer failed, $@");
    return $printer;
}

sub _build__printer_meta {
    my ($self, @rest) = @_;
    return $self->_printer_class->meta;
}

sub add {
    my ($self, $item, @args) = @_;

    #Dispatch to the appropriate handler sub

    #1. Regular String. Should have a name and any optional args
    if (is_Str($item)) {
        Carp::croak('->add expects [Scalar, List where { items > 0 }] or [Ref].') unless (scalar @args);
        $self->_add_by_type($item, @args);
        return $self;
    }

    #2. Array - loop. This will spectacularly fall over if you are using string-based creation as there's no way to pass multiple names yet
    if (is_ArrayRef($item)) {
        $self->add($_, @args) for @{$item};
        return $self;
    }

    #3. Custom field. Just takes any optional args
    if (is_SparkFormField($item)) {
        $self->_add_custom_field($item, @args);
        return $self;
    }

    #Unknown thing
    Carp::croak(q(Spark::Form: Don\'t know what to do with a ) . ref $item . q(/) . (blessed $item|| q()));
}

sub validate {
    my ($self,$gpc) = @_;
    my $result = Spark::Form::Result->new;
    if ($self->can('_validate')) {
        my @ret = $self->_validate($gpc);
	$result->push(form_result(@ret));
    }
    foreach my $f (@{$self->fields}) {
        my $ret = $v->validate($self,$gpc);
        $result->push($ret);
    }
    foreach my $v (@{$self->validators}) {
        my @ret = $v->validate($self,$gpc);
        $result->push(form_validator_result(@ret));
    }

    return $result;
}

sub data {
    my ($self, $fields) = @_;
    while (my ($k, $v) = each %{$fields}) {
        if ($self->get($k)) {
            $self->get($k)->value($v);
        }
    }

    return $self;
}

sub _add_custom_field {
    my ($self, $item, %opts) = @_;

    #And add it.
    $self->_add($item, $item->name, %opts);

    return $self;
}

sub _add_by_type {
    my ($self, $type, $name, %opts) = @_;

    #Default name is type itself
    $name ||= $type;

    #Create and add it
    $self->_add($self->_create_type($type, $name, %opts), $name);

    return $self;
}

sub _add {
    my ($self, $field, $name) = @_;

    Carp::carp("Field name $name exists in form.") if $self->field_couplet->value($name);

    #Add it onto the ArrayRef
    $self->field_couplet->set($name, $field);

    return 1;
}

sub _mangle_modname {
    my ($self, $mod) = @_;

    #Strip one or the other. This is the cleanest way.
    #It also doesn't matter that class may be null

    foreach my $ns ($self->_plugin_default_nses, $self->_plugin_nses) {
        last if $mod =~ s/^${ns}:://;
    }

    #Regulate.
    $mod =~ s/::/-/g;
    $mod = lc $mod;

    return $mod;
}

sub _find_matching_mod {
    my ($self, $wanted) = @_;

    #Just try and find something that, when mangled, eq $wanted
    foreach my $mod ($self->field_mods) {
        return $mod if $self->_mangle_modname($mod) eq $wanted;
    }

    #Cannot find
    return 0;
}

sub _create_type {
    my ($self, $type, $name, %opts) = @_;
    my $mod = $self->_find_matching_mod($type) or Carp::croak("Could not find field mod: $type");
    eval qq{ use $mod; 1 } or Carp::croak("Could not load $mod, $@");

    return $mod->new(name => $name, form => $self, %opts);
}

sub clone_all {
    my ($self) = @_;
    my $new = $self->clone;
    $_->form($self) foreach $new->fields;

    return $new;
}

sub clone_except_names {
    my ($self, @fields) = @_;
    my $new = $self->clone_all;
    $new->remove($_) foreach @fields;

    return $new;
}

#
# ->_except( \@superset , \@things_to_get_rid_of )
#

sub _except {
    my ($self, $input_list, $exclusion_list) = @_;
    my %d;
    @d{@{$exclusion_list}} = ();

    return grep {
        !exists $d{$_}
    } @{$input_list};
}

sub clone_only_names {
    my ($self, @fields) = @_;
    my @all = $self->keys;
    my @excepted = $self->_except(\@all, \@fields);
    return $self->clone_except_names(@excepted);
}

sub clone_except_ids {
    my ($self, @ids) = @_;
    my $new = $self->clone_all;
    $new->remove_at(@ids);

    return $new;
}

sub clone_only_ids {
    my ($self, @ids) = @_;
    my @all = 0 .. $self->field_couplet->last_index;

    return $self->clone_except_ids($self->_except(\@all, \@ids));
}

sub clone_if {
    my ($self, $sub) = @_;
    my (@all) = ($self->field_couplet->key_values_paired);
    my $i = 0 - 1;

    # Filter out items that match
    # coderef->( $current_index, $key, $value );
    @all = grep {
        $i++;
        !$sub->($i, @{$_});
    } @all;

    return $self->clone_except_names(map { $_->[0] } @all);
}

sub clone_unless {
    my ($self, $sub) = @_;
    my (@all) = $self->field_couplet->key_values_paired;
    my $i = 0 - 1;

    # Filter out items that match
    # coderef->( $current_index, $key, $value );

    @all = grep {
        $i++;
        $sub->($i, @{$_});
    } @all;
    return $self->clone_except_names(map { $_->[0] } @all);
}

sub compose {
    my ($self, $other) = @_;
    my $new = $self->clone_all;
    my $other_new = $other->clone_all;
    foreach my $key ($other_new->keys) {

            $new->add($other_new->get($key));
    }
    return $new;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 SYNOPSIS

 use Spark::Form;
 use CGI; #Because it makes for a quick and oversimplistic example
 use Third::Party::Field;
 $form = Spark::Form->new(plugin_ns => 'MyApp::Field');
 # Add a couple of inbuilt modules
 $form->add('email','email',confirm_field => 'email-confirm')
      ->add('email','email-confirm')
      ->add('password','password',regex => qr/^\S{6,}$/),
      #This one will be autoloaded from MyApp::Field::Username
      ->add('username','username')
      # And this shows how you can use a third party field of any class name
      ->add(Third::Party::Field->new(name => 'blah'));
 #Pass in a HashRef of params to populate the virtual form with data
 $form->data(CGI->new->params);
 #And do the actual validation
 if ($form->validate) {
     print "You are now registered";
 } else {
     print join "\n", $form->errors;
 }

and over in MyApp/Field/Username.pm...

 package MyApp::Form::Field::Username;
 use base Spark::Form::Field;

 sub _validate {

   my ($self,$v) = @_;

   if (length $v < 6 or length $v > 12) {
     $self->error("Usernames must be 6-12 characters long");
   } elsif ($v =~ /[^a-zA-Z0-9_-]/) {
     $self->error("Usernames may contain only a-z,A-Z,0-9, _ and -");
   } else {
     $self->error(undef);
   }
   $self->valid(!!$self->error());
 }

=head1 INSTABILITY

Periodically the API may break. I'll try to make sure it's obvious so it doesn't silently malfunction.

By 0.5, we shouldn't have to do this.

=head1 DEPENDENCIES

Moose. I've dropped using Any::Moose. If you need the performance increase, perhaps it's time to start thinking about shifting off CGI.

=head1 METHODS

=head2 import (%options)

Allows you to set some options for the forms class.

=over 4

=item class => String

Optional, gives the basename for searching for form plugins.

Given 'MyApp', it will try to load form plugins from MyApp::Form::Field::*

=item source => String

Optional, names a plugin to try and extract form data from.

If unspecified, you will need to call $form->data(\%data);

=back

=head2 add ($thing,@rest)

If $thing is a string, attempts to instantiate a plugin of that type and add it
to the form. Requires the second argument to be a string name for the field to identify it in the form. Rest will become %kwargs
If it is an ArrayRef, it loops over the contents (Useful for custom fields, will probably result in bugs for string field names).@rest will be passed in each iteration.
If it looks sufficiently like a field (implements Spark::Form::Field),
then it will add it to the list of fields. @rest will just become %kwargs

Uses 'field name' to locate it from the data passed in.

This is a B<streaming interface>, it returns the form itself.

=head2 validate

Validates the form. Sets C<valid> and then also returns the value.

=head2 data

Allows you to pass in a HashRef of data to populate the fields with before validation. Useful if you don't use a plugin to automatically populate the data.

This is a B<streaming interface>, it returns the form itself.

=head2 fields () => Fields

Returns a list of Fields in the form in their current order

=head2 BUILD

Moose constructor. Test::Pod::Coverage made me do it.
Adds C<class> to the search path for field modules.

=head2 get (Str)

Returns the form field of that name

=head2 get_at (Int)

Returns the form field at that index (counting from 0)

=head2 keys () :: Array

Returns the field names

=head2 field_couplet () :: Data::Couplet

Returns the Data::Couplet used to store the fields. Try not to use this too much.

=head2 remove (Array[Str]) :: Spark::Form

Removes the field(s) bearing the given name(s) from the form object. Silently no-ops any that do not exist.

=head2 remove_at (Array[Int]) :: Spark::Form

Removes the field at the given ID(s) from the form object. Silently no-ops any that do not exist.

WARNING: Things will get re-ordered when you do this. If you have a form with
IDs 0..3 and you remove (1, 3), then (0, 2) will remain but they will now be
(0, 1) as L<Data::Couplet> will move them to keep a consistent array.

=head2 clone_all () :: Spark::Form

Returns a new copy of the form with freshly instantiated fields.

=head2 clone_except_names (Array[Str]) :: Spark::Form

Clones, removing the fields with the specified names.

=head2 clone_only_names (Array[Str]) :: Spark::Form

Clones, removing the fields without the specified names.

=head2 clone_except_ids (Array[Int]) :: Spark::Form

Clones, removing the fields with the specified IDs.

=head2 clone_only_ids (Array[Int]) :: Spark::Form

Clones, removing the fields without the specified IDs.

=head2 clone_if (SubRef[(Int, Str, Any) -> Bool]) :: Spark::Form

Clones, removing items for which the sub returns false. Sub is passed (Id, Key, Value).

=head2 clone_unless (SubRef[(Int, Str, Any) -> Bool]) :: Spark::Form

Clones, removing items for which the sub returns true. Sub is passed (Id, Key, Value).

=head2 compose (Spark::Form) :: Spark::Form

Clones the current form object and copies fields from the supplied other form to the end of that form.
Where names clash, items on the current form take priority.

=head1 Docs?

L<http://sparkengine.org/docs/forms/>

=head2 Source?

L<http://github.com/jjl/Spark-Form/>

=head1 THANKS

Thanks to the Django Project, whose forms module gave some inspiration.

=head1 SEE ALSO

The FAQ: L<Spark::Form::FAQ>
L<Data::Couplet> used to hold the fields (see C<field_couplet>)

=cut
