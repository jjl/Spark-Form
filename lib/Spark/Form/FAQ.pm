1;
__END__

=head1 Frequently Asked Questions

=head2 Why another forms module?

None of the others met my needs. This is CPAN, people reinvent wheels
properly so you don't have to.

Essentially the only real viable alternative I've come across is HTML::FormFu 
and I wanted a pure-perl solution, no YAML.

=head2 Why Spark::Form?

Why not?

=over 4

=item Simple to use

Designed to be really simple, while still being flexible.

=item Framework independent

It doesn't rely on Catalyst, Jifty, CGI::Application etc. Plug it into anything.

=item Simple Plugin Architecture

It's B<really> simple to write a new field plugin. So simple and quick, you'll
want to define all your fields as plugins so they can be re-used.

=item Promotes re-use

Define fields once and re-use them to compose different forms that will all
enforce the same validation.

=item Pure Perl (and pretty at that)

No YAML files, no other language to learn. Just simple Perl.

=item Quality code

Easy to read and built with L<Moose> and L<Module::Pluggable>.

=back

=head2 Why do you depend on Moose?

It made writing this module a lot quicker and the code a lot cleaner. And it 
will make maintenance a lot easier.

=head2 Will there be a non-Moose version?

No. Feel free to create and maintain a fork.

=cut
