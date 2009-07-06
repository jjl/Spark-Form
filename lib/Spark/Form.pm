package Spark::Form;

our $VERSION = 0.2;

use Moose;
use MooseX::AttributeHelpers;
use List::MoreUtils 'all';

has _fields_a => (
    metaclass => 'Collection::Array',
    isa       => 'ArrayRef',
    is        => 'rw',
    required  => 0,
    default   => sub {[]},
    provides  => {
        push     => '_add_fields_a',
        elements => 'fields_a',
        clear    => '_clear_fields_a',
    },
);

has _fields_h => (
    metaclass => 'Collection::Hash',
    isa       => 'HashRef',
    is        => 'rw',
    required  => 0,
    default   => sub {+{}},
    provides  => {
        set     => '_set_fields_h',
        get     => '_get_fields_h',
        delete  => '_delete_fields_h',
        exists  => '_has_fields_h',
    },
);

has plugin_ns => (
    isa      => 'Str',
    is       => 'ro',
    required => 0,
);

has _errors   => (
    metaclass => 'Collection::Array',
    isa       => 'ArrayRef',
    is        => 'ro',
    required  => 0,
    default   => sub {[]},
    provides  => {
        push     => '_add_error',
        elements => 'errors',
        clear    => '_clear_errors',
    },);

has valid    => (
    isa      => 'Bool',
    is       => 'rw',
    required => 0,
    default  => 0,
);

has '_printer'  => (
    isa      => 'Maybe[Str]',
    required => 0,
    is       => 'ro',
    init_arg => 'printer',
);

sub BUILD {
    my ($self) = @_;
    my @search_path = (
        #This will load anything from SparkX::Form::Field
        'SparkX::Form::Field',
    );
    if ($self->plugin_ns) {
        unshift @search_path, ($self->plugin_ns);
    }

    eval q{
        use Module::Pluggable (
            search_path => \@search_path,
            sub_name    => 'field_mods',
            required    => 1,
        );
        1
    } or die("Spark::Form: Could not instantiate Module::Pluggable, $@");

    if (defined $self->_printer) {
        eval {
            #Load the module, else short circuit. There were strange antics with qq{} and this is tidier than the alternative
            eval sprintf("require %s; 1",$self->_printer) or die();
            #Apply the role (failure will short circuit). Return 1 so the 'or' won't trigger
            $self->_printer->meta->apply($self); 1
        } or die("Could not apply printer " . $self->_printer . " $@");
    }
}

sub _error {
    my ($self,$error) = @_;

    $self->valid(0);
    $self->_add_error($error);
}

sub add {
    my $self = shift;
    my $item = shift;
    
    #Dispatch to the appropriate handler sub

    #1. Regular String. Should have a name and any optional args
    return do { die unless scalar @_; $self->_add_by_type($item,@_); $self }
      unless ref $item;
    #2. Array - loop. This will spectacularly fall over if you are using string-based creation as there's no way to pass multiple names yet
    return do { $self->add($_,@_) for @$item; $self }
      if ref $item eq 'ARRAY';
    #3. Custom field. Just takes any optional args
    return do { $self->_add_custom_field($item,@_); $self }
      if $self->_valid_custom_field($item);

    #Unknown thing
    die("Spark::Form: Don't know what to do with a " . ref $item);
}

sub get {
    my ($self, $key) = @_;

    $self->_get_fields_h($key);
}

sub validate {
    my ($self) = @_;
    #Clear out
    $self->valid(1);
    $self->_clear_errors();
    if (all { $_->meta->does_role('Spark::Form::Field::Role::Validateable') } $self->fields_a) {
        foreach my $field ($self->fields_a) {
            $field->validate;
            unless ($field->valid) {
                $self->_error($_) foreach $field->errors;
            }
        }
        $self->valid;
    } else {
        die ("Not all fields in this form are validateable.");
    }
}

sub data {
    my ($self,$fields) = @_;
    while (my ($k,$v) = each %$fields) {
        if ($self->_has_fields_h($k)) {
            $self->_get_fields_h($k)->value($v);
        }
    }

    $self;
}

sub _valid_custom_field {
    my ($self,$thing) = @_;
    eval {
        $thing->isa('Spark::Form::Field')
    } or 0;
}

sub _add_custom_field {
    my ($self,$item,%opts) = @_;

    #And add it.
    $self->_add($item,$item->name,%opts);
}

sub _add_by_type {
    my ($self,$type,$name,%opts) = @_;

    #Default name is type itself
    $name ||= $type;

    #Create and add it
    $self->_add($self->_create_type($type,$name,%opts),$name);
}

sub _add {
    my ($self,$field,$name) = @_;

    #
    die("Field name $name exists in form.") if $self->_has_fields_h($name);

    #Add it onto the arrayref
    $self->_add_fields_a($field);

    #And the hashref
    $self->_set_fields_h($name, $field);
    1;
}

sub _mangle_modname {
    my ($self, $mod) = @_;

    #Strip one or the other. This is the cleanest way.
    #It also doesn't matter that class may be null
    my @namespaces = (
        "SparkX::Form::Field",
        "Spark::Form::Field",
    );

    push @namespaces,$self->plugin_ns if $self->plugin_ns;

    foreach my $ns (@namespaces) {
        last if $mod =~ s/^${ns}:://;
    }

    #Regulate.
    $mod =~ s/::/-/g;
    $mod = lc $mod;

    $mod;
}

sub _find_matching_mod {
    my ($self,$wanted) = @_;

    #Just try and find something that, when mangled, eq $wanted
    foreach my $mod ($self->field_mods) {
        return $mod if $self->_mangle_modname($mod) eq $wanted;
    }

    #Cannot find
    0;
}

sub _create_type {
    my ($self,$type,$name,%opts) = @_;
    my $mod = $self->_find_matching_mod($type) or die("Could not find field mod: $type");
    eval qq{ use $mod; 1 } or die("Could not load $mod, $@");
    $mod->new(name => $name, form => $self,%opts);
}

1;
__END__

=head1 NAME

Spark Form - A simple yet powerful forms validation system that promotes reuse.

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
 #Pass in a hashref of params to populate the virtual form with data
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
 
 sub validate {
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
If it is an arrayref, it loops over the contents (Useful for custom fields, will probably result in bugs for string field names).@rest will be passed in each iteration.
If it looks sufficiently like a field (implements Spark::Form::Field),
then it will add it to the list of fields. @rest will just become %kwargs

Uses 'field name' to locate it from the data passed in.

This is a B<streaming interface>, it returns the form itself.

=head2 validate

Validates the form. Sets C<valid> and then also returns the value.

=head2 data

Allows you to pass in a hashref of data to populate the fields with before validation. Useful if you don't use a plugin to automatically populate the data.

This is a B<streaming interface>, it returns the form itself.

=head2 BUILD

Moose constructor. Test::Pod::Coverage made me do it.
Adds C<class> to the search path for field modules.

=head2 get (Str)

Returns the form field of that name

=head1 Docs?

L<http://sparkengine.org/docs/forms/>

=head2 Source?

L<http://github.com/jjl/Spark-Form/>

=head1 AUTHOR

James Laver. L<http://jameslaver.com/>.

Thanks to the Django Project, whose forms module gave some inspiration.

=head1 SEE ALSO

The FAQ: L<Spark::Form::FAQ>

=head1 LICENSE

Copyright (C) 2009 James Laver

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
