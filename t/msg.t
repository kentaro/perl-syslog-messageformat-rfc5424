use strict;
use warnings;
use Test::More;
use Syslog::MessageFormat::RFC5424::Msg;

subtest 'to_string' => sub {
    my $string = Syslog::MessageFormat::RFC5424::StructuredData->to_string('foo');

    is $string, "\xef\xbb\xbffoo";
};

subtest 'parse' => sub {
    my $utf8_octets = "\xef\xbb\xbffoo";
    my $octets      = 'foo';

    is(Syslog::MessageFormat::RFC5424::StructuredData->parse($utf8_octets), 'foo');
    is(Syslog::MessageFormat::RFC5424::StructuredData->parse($octets), 'foo');
};

done_testing;
