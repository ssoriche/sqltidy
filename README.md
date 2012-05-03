sqltidy
=======

Make your SQL statements pretty

Primary goal convert:
---------------------

    SELECT columnA, columnB,
    columnC, tablea.* FROM tablea
    INNER JOIN tableb b on
    tablea.columnZ = b.foo
    and b.bar = 'baz';

Into:

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

After getting the formatting like above, then start adding options
to make the formating customizable.

Want to help out?
-----------------

Please fork it, and add tests into grammar.t. I go through a lot of SQL in a day
but I don't see every combination.
