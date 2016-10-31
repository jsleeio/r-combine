#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;

sub from_si {
  my $input = shift;
  my %si = (k => 1000, m => 1000000, g => 1000000000, t => 1000000000000);
  if ($input =~ /^(\d+)([kmgt])$/i) {
    return $1 * $si{lc $2};
  }
  return $input;
}

# one R value per line with [KMGT] SI suffixes.
# non-conforming lines (eg. #comments) summarily ignored
sub read_stock {
  my $stockfile = shift;
  open(my $stockfh, '<', $stockfile) or die "can't read $stockfile\n";
  my @stock = grep /^[^#]/, map { y/A-Z/a-z/; s/^\s*//; s/\s*$//; chomp; $_ } <$stockfh>;
  return @stock;
}

sub r_combine {
  my ($r1, $r2) = map { from_si($_) } @_;
  return 1 / ( 1/$r1 + 1/$r2 );
}

my %CONFIG = (
  stockfile => 'r-combine.stock',
  tolerance => 0.01,
  verbose => 0
);

GetOptions(\%CONFIG, qw(stockfile=s tolerance=f verbose))
  or die "usage: r-combine.pl [--stockfile=filename] [--tolerance=0.01] [--verbose]\n";

my @stock = read_stock($CONFIG{stockfile});

DESIRED: for my $r_desired (map { from_si($_) } @ARGV) {
  my $r_lower = $r_desired - ( $r_desired * $CONFIG{tolerance} );
  my $r_upper = $r_desired + ( $r_desired * $CONFIG{tolerance} );
  for my $r1 (@stock) {
    if (from_si($r1) == $r_desired) {
      printf "r-desired %s exact match found in stock\n", $r_desired;
      next DESIRED;
    }
    for my $r2 (@stock) {
      my $rc = r_combine($r1, $r2);
      if ($rc >= $r_lower && $rc <= $r_upper) {
        printf "r-desired %d candidate r1 %s r2 %s result %d\n",
          $r_desired, $r1, $r2, $rc;
      } else {
        printf "r-desired %d reject r1 %s r2 %s result %d\n",
          $r_desired, $r1, $r2, $rc if $CONFIG{verbose}
      }
    }
  }
}
