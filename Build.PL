use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'SparkX::Form::BasicPrinters',
    license             => 'perl',
    dist_author         => 'James Laver <printf(qw[%s@%s.%s cpan jameslaver com])>',
    dist_version_from   => 'lib/SparkX/Form/BasicPrinters.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'SparkX-Form-BasicPrinters-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
