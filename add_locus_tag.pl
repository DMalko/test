#!/usr/bin/perl -w
use strict;


my $infile = 'Holospora undulata.gb';
my $outfile = 'Holospora undulata.tagged.gb';
my $tag = 'HUNDU_';

open(IN, "< $infile") || die;
open(OUT, "> $outfile") || die;

my $n = 0;
while (my $str = <IN>) {
    
    if ($str =~ m/     (?:CDS) +(.*)/) {
        print OUT q/     gene            /;
        print OUT $1, "\n";
        print OUT q/                     \/locus_tag="/;
        print OUT $tag;
        print OUT sprintf("%05i", ++$n);
        print OUT qq/"\n/;
                
        print OUT $str;
        print OUT q/                     \/locus_tag="/;
        print OUT $tag;
        print OUT sprintf("%05i", $n);
        print OUT qq/"\n/;
        next;
    }
    print OUT $str;
}

print qq/...OK\n/;
