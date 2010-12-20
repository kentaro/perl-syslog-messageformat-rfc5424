package Syslog::MessageFormat::RFC5424::StructuredData;
use strict;
use warnings;
use Carp qw(croak);
use String::UTF8;
use Parse::RecDescent;

use base qw(Syslog::MessageFormat::RFC5424::Base);

our $grammer = <<'GRAMMER';
structured_data : STRUCTURED_DATA {
    $return = ref $item[1] eq 'ARRAY' ?
        +{ map { each %$_ } @{$item[1]} } : $item[1];
}
STRUCTURED_DATA : NILVALUE | SD_ELEMENT(s)
SD_ELEMENT      : '[' SD_ID SD_PARAM(s?) ']' {
    $return = {
        $item[2] => +{ map { each %$_ } @{$item[3]} }
    }
}
SD_PARAM        : PARAM_NAME '=' '"' PARAM_VALUE '"' {
    $return = {
        $item[1] => $item[4],
    }
}
SD_ID           : SD_NAME
PARAM_NAME      : SD_NAME
PARAM_VALUE     : VALUE_OCTET(s?) {
    my $string = join '', @{$item[1] || []};
    if ($string) {
        Carp::croak('PARAM-VALUE must be utf8 octets')
            if !String::UTF8::is_utf8($string);
        $return = $string;
    }
    else {
        $return = $string;
    }
}

SD_NAME         : /[\x21\x23-\x3c\x3e-\x5c\x5e-\x7e]+/
VALUE_OCTET     : '\"' | '\\' | '\]' | /[^"]/

NILVALUE        : '-'
GRAMMER

our $parser;

sub parser {
    return $parser if $parser;
    my $class = shift;
    $parser = Parse::RecDescent->new($grammer) or die $@;
}

sub parse {
    my ($class, $text) = @_;
    my $result = $class->parser->structured_data($text)
        or croak 'strunctured data: syntax error';

    if (!ref $result && ref \$result eq 'SCALAR' && $result eq '-') {
        $result =  undef;
    }

    $result;
}

sub to_string {
    my ($class, $data) = @_;
    my $string = '';

    for my $sd_id (keys %$data) {
        $string .= qq{[$sd_id};
        for my $param_name (keys %{$data->{$sd_id}}) {
            my $value = $data->{$sd_id}{$param_name};
               $value =~ s{((?<!\\)["\]\\](?!["\]\\]))}{\\$1}g;

            $string .= qq{ $param_name="$value"};
        }
        $string .= ']'
    }

    $string;
}

!!1;
