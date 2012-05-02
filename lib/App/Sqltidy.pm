use strict;
use warnings;
use v5.12;

package App::Sqltidy;

use Parse::RecDescent;

use Data::Printer;

sub new {
  my $this  = shift;
  my $class = ref($this) || $this;
  my $self  = {};
  bless $self, $class;

  return $self;
}

sub grammar {
  my $self = shift;

  my $grammar = <<'END_OF_GRAMMAR';

  {
    my ( @tables, $table_order, @table_comments, @views, @triggers, @columns );

    sub _err {
      my $max_lines = 5;
      my @up_to_N_lines = split (/\n/, $_[1], $max_lines + 1);
      die sprintf ("Unable to parse line %d:\n%s\n",
        $_[0],
        join "\n", (map { "'$_'" } @up_to_N_lines[0..$max_lines - 1 ]), @up_to_N_lines > $max_lines ? '...' : ()
      );
    }

  }

  startrule : statement(s) eofile {
    $return      = {
        columns  => \@columns,
        tables   => \@tables,
        views    => \@views,
        triggers => \@triggers,
    }
  }

  eofile : /^\Z/

  statement : command COLUMN(s) FROM TABLE SEMICOLON(?)
      | /^\Z/ | { _err ($thisline, $text) }

  command : SELECT
        | INSERT

  SELECT : /select/i
  INSERT : /insert into/i

  FROM : /from/i
  SEMICOLON : ';'
  COMMA : ','
  COLUMN : ...!FROM NAME COMMA(?) { push(@columns, $item[2] )}
  TABLE : NAME { push(@tables, $item[1] )}
  AS : /as/i
  NAME : /["']?(\w+)["']?/ { $return = $1 }

END_OF_GRAMMAR

  return $grammar;
}

sub parse {
  my $self = shift;
  my $sql = shift;

  # $::RD_TRACE = 1;
  my $parser = Parse::RecDescent->new($self->grammar);

  return $parser->startrule($sql);
}

1;
