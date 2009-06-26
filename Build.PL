use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Spark::Form',
    license             => 'perl',
    dist_author         => 'James Laver <sprintf qw(%s@%s.%s cpan jameslaver com)>',
    dist_version_from   => 'lib/Spark/Form.pm',
    build_requires => {
        'Test::More'        => 0,
    },
    requires       => {
        'Module::Pluggable'        => 0,
        'Moose'                    => 0,
        'HTML::Tiny'               => 0,
        'MooseX::AttributeHelpers' => 0,
        'List::MoreUtils'          => 0,
    },
    add_to_cleanup      => [ 'Spark-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
