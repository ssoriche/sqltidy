#!/usr/bin/env perl

use Test::More tests => 6;
use v5.12;
use Data::Printer;

use_ok 'App::Sqltidy';

my $parser = App::Sqltidy->new;
isa_ok($parser, 'App::Sqltidy');

is($parser->parser_trace(1),1,'simple accessor');
is($parser->parser_trace,1,'simple accessor return');

$parser = App::Sqltidy->new({parser_trace => 1});
isa_ok($parser, 'App::Sqltidy');

is($parser->parser_trace,1,'simple accessor return');
