package Syslog::MessageFormat::RFC5424::Base;
use strict;
use warnings;

sub parser    { die 'parser() should be implemented by subclass'    }
sub parse     { die 'parse() should be implemented by subclass'     }
sub to_string { die 'to_string() should be implemented by subclass' }

!!1;
