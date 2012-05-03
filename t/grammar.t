#!/usr/bin/env perl

use Test::More tests => 7;
use Test::Deep;

use v5.12;
use Data::Printer;

use_ok 'App::Sqltidy';

my $parser = App::Sqltidy->new;
isa_ok($parser, 'App::Sqltidy');

my $res;
$res = $parser->parse('SELECT b;');
cmp_deeply($res->{elements}, ['SELECT','b'], 'simple select');

$res = $parser->parse('SELECT b FROM y;');
cmp_deeply($res->{elements}, ['SELECT','b','FROM','y'], 'simple select w/from');

$res = $parser->parse('SELECT a,b FROM y;');
cmp_deeply($res->{elements}, ['SELECT','a','b','FROM','y'], 'simple multi-column select w/from');

# $parser->parser_trace(1);
$res = $parser->parse('SELECT a as c FROM DUAL;');
cmp_deeply($res->{elements}, ['SELECT','a AS c','FROM','DUAL'], 'simple single column select w/alias & from');

$res = $parser->parse('SELECT a as c,b FROM DUAL;');
cmp_deeply($res->{elements}, ['SELECT','a AS c','b','FROM','DUAL'], 'simple multi-column select w/alias & from');

