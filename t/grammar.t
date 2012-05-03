#!/usr/bin/env perl

use Test::More tests => 3;
use Test::Deep;

use v5.12;
use Data::Printer;

use_ok 'App::Sqltidy';

my $parser = App::Sqltidy->new;
isa_ok($parser, 'App::Sqltidy');

my $res;
$res = $parser->parse('SELECT b FROM y;');
cmp_deeply($res->{elements}, ['SELECT','b','FROM','y'], 'simple select w/from');
say p $res;
# $res = $parser->parse('SELECT a,b FROM x;');
# say p $res;
# $res = $parser->parse('SELECT a as c FROM DUAL');
# say p $res;
