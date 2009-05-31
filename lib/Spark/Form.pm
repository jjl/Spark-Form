package Spark::Form;

our $VERSION = 0.01;

use Any::Moose;

has fields_a => (
    isa      => 'ArrayRef',
    is       => 'rw',
    required => 0,
    default  => sub {[]},
);

has fields_h => (
    isa      => 'HashRef',
    is       => 'rw',
    required => 0,
    default  => sub {+{}},
);

has plugin_ns => (
    isa      => 'Str',
    is       => 'ro',
    required => 0,
);

has errors   => (
    isa      => 'ArrayRef',
    is       => 'rw',
    required => 0,
    default  => sub {[]},
);

has valid    => (
    isa      => 'Bool',
    is       => 'rw',
    required => 0,
    default  => 0,
);

sub BUILD {
    my ($self) = @_;
    my @search_path = (
        #This will load Email and Password etc.
        'SparkX::Form::Field',
        #This will load Mandatory, Optional and any specific type plugins
        'Spark::Form::Field'
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
}

sub add {
    my ($self,$item,$name,%opts) = @_;
    #Dispatch to the appropriate handler sub

    #1. Regular String
    return do { $self->_add_by_type($item,$name,%opts); $self }
      unless ref $item;
    #2. Array - loop.
    return do { $self->add($_,$name,%opts) for @$item; $self }
      if ref $item eq 'ARRAY';
    #3. Custom field
    return do { $self->_add_custom_field($item,%opts); $self }
      if $self->_valid_custom_field($item);

    #Unknown thing
    die("Spark::Form: Don't know what to do with a " . ref $item);
}

sub get {
    my ($self, $key) = @_;
    confess unless $key;
    $self->fields_h->{$key};
}

sub validate {
    my ($self) = @_;

    my @errors;
    foreach my $field (@{$self->fields_a}) {
        $field->validate;
        unless ($field->valid) {
            push @errors, @{$field->errors};
        }
    }
    $self->errors(\@errors);
    $self->valid(!@errors);
    
    $self->valid;
}

sub data {
    my ($self,$fields) = @_;
    while (my ($k,$v) = each %$fields) {
        if (defined $self->fields_h->{$k}) {
            $self->fields_h->{$k}->value($v);
        }
    }

    $self;
}

sub _valid_custom_field {
    my ($self,$thing) = @_;
    eval {
        #Minimum spec for a field:
        #  implements:
        #    - Spark::Form::Field
        $thing->meta->does_role('Spark::Form::Field')
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
    
    die("Field name $name exists in form.") if defined $self->fields_h->{$name};
    #Add it onto the arrayref
    push @{$self->fields_a}, $field;
    #And the hashref
    $self->fields_h->{$name} = $field;
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
    
    if ($self->plugin_ns) {
        use Data::Dumper 'Dumper';
        die Dumper $self->_mangle_modname('TestApp::Form::Field::Custom');
        die Dumper $self->field_mods;
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
 use CGI; #Because it makes for a quick and oversimplisticn example
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

This module uses L<Any::Moose>. If you don't want to install L<Moose>
(it can take a while to install all the deps), install L<Mouse> instead.

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

=head2 add ($thing,$field_name,%opts)

If $thing is a string, attempts to instantiate a plugin of that type and add it
to the form.
If it is an arrayref, it loops over the contents (Useful for custom fields).
If it looks sufficiently like a field (implements Spark::Form::Field),
then it will add it to the list of fields.

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

=head1 LICENSE

Copyright (C) 2009 James Laver

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
