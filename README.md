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
