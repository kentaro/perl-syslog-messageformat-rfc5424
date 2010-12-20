use strict;
use warnings;
use Test::More;
use Syslog::MessageFormat::RFC5424::StructuredData;

my $data = {
    foo => {
        bar => 'baz',
        qux => '\"quux\"',
    },
    hoge => {
        piyo   => 'fu\\\ga',
        hogera => '[hogehoge\]',
    }
};

subtest 'to_string' => sub {
    my $string = Syslog::MessageFormat::RFC5424::StructuredData->to_string($data);

    is $string, '[foo bar="baz" qux="\"quux\""][hoge piyo="fu\\\ga" hogera="[hogehoge\]"]';
};

subtest 'parse' => sub {
    my $string = Syslog::MessageFormat::RFC5424::StructuredData->to_string($data);

    is_deeply(Syslog::MessageFormat::RFC5424::StructuredData->parse($string), $data);
    ok !Syslog::MessageFormat::RFC5424::StructuredData->parse('-');
};

done_testing;
