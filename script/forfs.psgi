#!/usr/bin/env perl
use strict;
use warnings;
use ForFS;

ForFS->setup_engine('PSGI');
my $app = sub { ForFS->run(@_) };

