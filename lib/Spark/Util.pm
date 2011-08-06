package Spark::Util;

use Spark::Form::Validator::Result;
use Spark::Form::Field::Validator::Result;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(
    form_result    form_validator_result
    field_result    field_validator_result
);

sub form_result {
    if (@_) {
        foreach my $msg (@_) {
            Spark::Form::Validator::Result->new(bool => false, message => $msg);
        }
    } else {
        Spark::Form::Validator::Result->new(bool => true);
    }
}

sub field_result {
    if (@_) {
        foreach my $msg (@_) {
            Spark::Form::Field::Validator::Result->new(bool => false, message => $msg);
        }
    } else {
        Spark::Form::Field::Validator::Result->new(bool => true);
    }
}

1;
__END__
