use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'SparkX::Form::BasicFields',
    license             => 'perl',
    dist_author         => 'James Laver <printf(qw[%s@%s.%s cpan jameslaver com])>',
    dist_version_from   => 'lib/SparkX/Form/BasicFields.pm',
    dist_abstract       => 'A set of basic fields for use with Spark::Form',
    build_requires => {
        'Test::More' => 0,
        'Test::MockObject' => 0,
        'Test::MockObject::Extends' => 0,
    },
    requires => {
        'Moose'          => 0,
        'HTML::Tiny'     => 0,
        'List::Util'     => 0,
        'Spark::Form'    => '0.1',
    },
    add_to_cleanup      => [ 'SparkX-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();

