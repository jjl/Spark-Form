package SparkX::Form::Field::Text

use Moose;
with 'Spark::Form::Field';

sub to_html {
    shift->render( HTML::Tiny->new( mode => 'html') );
}

sub to_xhtml {
    shift->render( HTML::Tiny->new( mode => 'xml') );
}
 
sub render {
    my ($self,$html) = @_;
    
    $html->input({type => 'text', value => $self->value});
}
