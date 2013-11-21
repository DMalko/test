#!/usr/bin/perl

use strict;
use warnings;

use BioTools::Parser::MultiFasta;

my $infile = $ARGV[0];
$infile ||= 'prot.fa';

my %fdescr = ();
my $multifasta = BioTools::Parser::MultiFasta->new($infile);
while (my $fasta = $multifasta->get_next()) {
    my $id = $fasta->{id};
    my $seq = $fasta->{seq};
    my ($genome_id) = split(/\|/, $id);
    if (not exists $fdescr{$genome_id}) {
        
        open($fdescr{$genome_id}, "> $genome_id.fasta") || die;
        
    }
    print {$fdescr{$genome_id}} '>', $id, "\n", $seq, "\n";
}

print qq/...OK\n/;


