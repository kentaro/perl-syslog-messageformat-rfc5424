package Syslog::MessageFormat::RFC5424::StructuredData;
use strict;
use warnings;
use Carp qw(croak);
use String::UTF8 qw(is_utf8);

use base qw(Syslog::MessageFormat::RFC5424::Base);

sub parser {}

sub parse {
    my ($class, $text) = @_;
    ($text ||= '') =~ s{^(?:\xef\xbb\xbf)}{};
    return $text if !$text;
    croak 'MSG must be ASCII bytes or utf8 octets' if  !is_utf8($text);
    $text;
}

sub to_string {
    my ($class, $string) = @_;
    $string = defined $string ? $string : '';
    "\xef\xbb\xbf$string";
}

!!1;
