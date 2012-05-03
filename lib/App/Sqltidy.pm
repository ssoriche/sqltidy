use strict;
use warnings;
use v5.12;

# ABSTRACT: Main Application Class for sqltidy

package App::Sqltidy;

use Parse::RecDescent;

use Data::Printer;

sub new {
  my $this  = shift;
  my $args  = shift;
  my $class = ref($this) || $this;
  my $self  = {};
  bless $self, $class;

  foreach(keys(%$args)) {
    $self->$_($args->{$_});
  }

  return $self;
}

sub parser_trace {
  my $self = shift;
  my $value = shift;

  if(defined($value)) {
    $self->{parser_trace} = $value;
  }

  return $self->{parser_trace};
}

sub grammar {
  my $self = shift;

  my $grammar = <<'END_OF_GRAMMAR';

  {
    my ( @elements );

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
        elements  => \@elements,
    }
  }

  eofile : /^\Z/

  statement : command COLUMN(s) TABLE(?) SEMICOLON(?)
      | /^\Z/ | { _err ($thisline, $text) }

  command : SELECT
        | INSERT

  SELECT : /select/i { push(@elements,"SELECT") }
  INSERT : /insert into/i

  FROM : /from/i { push (@elements,"FROM") }
  SEMICOLON : ';'
  COMMA : ','
  COLUMN : ...!FROM NAME column_alias(?) COMMA(?) {
    if($item[3][0]) {
      push(@elements, $item[2] . ' ' . $item[3][0]);
    }
    else {
      push(@elements, $item[2]);
    }
  }
  TABLE : FROM NAME { push(@elements, $item[2] )}
  column_alias: AS(?) ...!FROM NAME {
    if($item[1][0]) {
      $return = $item[1][0] . ' ' . $item[3];
    }
    else {
      $return = $item[2];
    }
  }
  AS : /as/i { $return = 'AS' }
  NAME : /["']?(\w+)["']?/ { $return = $1 }

END_OF_GRAMMAR

  return $grammar;
}

sub parse {
  my $self = shift;
  my $sql = shift;

  if($self->parser_trace) {
    $::RD_TRACE = 1;
  }

  # Enable warnings within the Parse::RecDescent module.
  $::RD_ERRORS = 1; # Make sure the parser dies when it encounters an error
  $::RD_WARN   = 1; # Enable warnings. This will warn on unused rules &c.
  $::RD_HINT   = 1; # Give out hints to help fix problems.

  my $parser = Parse::RecDescent->new($self->grammar);

  return $parser->startrule($sql);
}

sub tidy {
  my $self = shift;
  my $sql = shift;

  # XXX More work required on the grammar before this can be uncommented.
  # my $elements = $self->parse($sql);

  return "";
}

1;
