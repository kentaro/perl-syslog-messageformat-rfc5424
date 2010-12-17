package Syslog::MessageFormat::RFC5424::StructuredData;
use strict;
use warnings;
use Parse::RecDescent;

use base qw(Syslog::MessageFormat::RFC5424::Base);

our $GRAMMER = <<'GRAMMER';
structured_data : STRUCTURED_DATA
STRUCTURED_DATA : NILVALUE | SD_ELEMENT(s)
SD_ELEMENT      : '[' SD_ID SD_PARAM(s?) ']' {
    $return = {
        $item[2] => $item[3],
    }
}
SD_PARAM        : PARAM_NAME '=' '"' PARAM_VALUE '"' {
    $return = {
        $item[1] => $item[4],
    }
}
SD_ID           : SD_NAME
PARAM_NAME      : SD_NAME
PARAM_VALUE     : UTF8_STRING

SD_NAME         : /[\x21\x23-\x3c\x3e-\x5c\x5e-\x7e]+/
UTF8_STRING     : OCTET(s?)

OCTET           : /([\x20\x21\x23-\x5c\x5e-\x7e]|\\"|\\|\\])+/
NILVALUE        : '-'
GRAMMER

our $parser;

sub parser {
    return $parser if $parser;
    my $class = shift;
    $parser = Parse::RecDescent->new($GRAMMER) or die $@;
}

sub parse {
    my ($class, $text) = @_;
    my $result = $class->parser->structured_data($text) || {};

    if ($result && ref $result eq 'ARRAY') {
        my $result_hash = {};
        for my $first (@$result) {
            my $first_key = (keys %$first)[0];
            my $array = $first->{$first_key};
            delete $first->{$first_key};
            for my $second (@$array) {
                my $second_key = (keys %$second)[0];
                $result_hash->{$first_key}{$second_key} = $second->{$second_key}[0];
            }
        }
        return $result_hash;
    }

    $result;
}

sub to_string {
    my ($class, $data) = @_;
    my $string = '';

    for my $sd_id (keys %$data) {
        $string .= qq{[$sd_id};
        for my $param_name (keys %{$data->{$sd_id}}) {
            $string .= qq{ $param_name="$data->{$sd_id}{$param_name}"};
        }
        $string .= ']'
    }

    $string;
}

!!1;
