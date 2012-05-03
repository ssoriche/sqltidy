#!/usr/bin/env perl

use Test::More tests => 3;

use_ok 'App::Sqltidy';

my $parser = App::Sqltidy->new;
isa_ok($parser, 'App::Sqltidy');

my $sql = <<'END_OF_SQL';
SELECT columnA, columnB,
columnC, tablea.* FROM tablea
INNER JOIN tableb b on
tablea.columnZ = b.foo
and b.bar = 'baz';
END_OF_SQL

my $tidied = <<'END_OF_SQL';
SELECT
    columnA,
    columnB,
    columnC,
    tablea.*
  FROM tablea
  INNER JOIN tableb b
    ON tablea.columnZ = b.foo
      AND b.bar = 'baz'
;
END_OF_SQL

TODO: {
  local $TODO = "This is the stated inital goal of the project.";
  is($parser->tidy($sql),$tidied);
}
