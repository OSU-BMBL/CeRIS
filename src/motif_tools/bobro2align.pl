#!/usr/bin/env perl
# Transfer a bobro output file (*.closures) to alignment format, which could be used by bbs
# read stdin, write stdout
use strict;
use warnings;

my $motif_now = '';
while(<>) {
  chomp;
  next unless (s/^>//);

  my ($motif, $seq) = (split)[0, 4];

  if($motif eq $motif_now) {
    print $seq, "\n";
  } else {
    $motif_now = $motif;
    print ">$motif\n";
    print $seq, "\n";
  }
}
print ">end\n";


