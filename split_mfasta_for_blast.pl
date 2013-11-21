#!/usr/bin/perl -w

use strict;

my $input_file = $ARGV[0]; # multi-fasta file
my $num = $ARGV[1];        # chunk number

die "ERROR: not enough arguments!\n" if not defined $input_file and not defined $num;

my $total = 0;
open(IN, "< $input_file") || die "can't open file: $input_file\n";
while(my $str = <IN>){
	$total++ if $str =~ m/^>/;
}
close IN;

my $chunk = int($total / $num);
open(IN, "< $input_file") || die;
my $curr_num = 0;
my $written = 0;
my $ext = 0;
while(my $str = <IN>){
	if($str =~ m/^>/){
		$curr_num++;
		$written++;
		if($written == 1 || $curr_num > $chunk && $total - $written > $chunk / 2){
			$ext++;
			open(OUT, "> $input_file.part$ext") || die "can't open file: $input_file.part$ext\n";
			$curr_num = 0;
		}
	}
	print OUT $str;
}

print "$total records in $ext parts\n...done\n";
