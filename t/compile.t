use strict;
use warnings;
use Test::More;

my @modules = qw(
    Syslog::MessageFormat::RFC5424
    Syslog::MessageFormat::RFC5424::Base
    Syslog::MessageFormat::RFC5424::StructuredData
);

use_ok $_ for @modules;

done_testing;
