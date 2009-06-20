use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'SparkX::Form::BasicFields',
    license             => 'perl',
    dist_author         => 'James Laver <printf(qw[%s@%s.%s cpan jameslaver com])>',
    dist_version_from   => 'lib/SparkX/Form/BasicFields.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'SparkX-Form-BasicFields-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
