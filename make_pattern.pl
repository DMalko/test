#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use File::Temp;
use Getopt::Long;

my $db_name;
my $host;
my $login;
my $password;

GetOptions(
	'db=s' => \$db_name,
	'host=s' => \$host,
	'login=s' => \$login,
	'pass=s' => \$password
);


###################################
$db_name ||= 'Holospora';
$host ||= 'localhost';
$login ||= 'root';
$password ||= '';
###################################


my $dbh = DBI->connect("DBI:mysql:$db_name:$host;mysql_local_infile=1", $login, $password, {RaiseError => 1, PrintError => 0}) || die "$DBI::err($DBI::errstr)\n";
#=pod
$dbh->do(q/DROP TABLE IF EXISTS orthomcl_pattern/);
$dbh->do(q/
    CREATE TABLE orthomcl_pattern
    SELECT 
    group_id,
    SUM(IF(genome_id = 1, 1, 0)) AS genome_1,
    SUM(IF(genome_id = 2, 1, 0)) AS genome_2,
    SUM(IF(genome_id = 3, 1, 0)) AS genome_3,
    SUM(IF(genome_id = 4, 1, 0)) AS genome_4,
    SUM(IF(genome_id = 5, 1, 0)) AS genome_5,
    SUM(IF(genome_id = 6, 1, 0)) AS genome_6,
    SUM(IF(genome_id = 7, 1, 0)) AS genome_7,
    SUM(IF(genome_id = 8, 1, 0)) AS genome_8,
    SUM(IF(genome_id = 9, 1, 0)) AS genome_9,
    SUM(IF(genome_id = 10, 1, 0)) AS genome_10,
    SUM(IF(genome_id = 11, 1, 0)) AS genome_11,
    SUM(IF(genome_id = 12, 1, 0)) AS genome_12,
    SUM(IF(genome_id = 13, 1, 0)) AS genome_13,
    SUM(IF(genome_id = 14, 1, 0)) AS genome_14,
    SUM(IF(genome_id = 15, 1, 0)) AS genome_15,
    SUM(IF(genome_id = 16, 1, 0)) AS genome_16,
    SUM(IF(genome_id = 17, 1, 0)) AS genome_17,
    SUM(IF(genome_id = 18, 1, 0)) AS genome_18,
    SUM(IF(genome_id = 19, 1, 0)) AS genome_19,
    SUM(IF(genome_id = 20, 1, 0)) AS genome_20,
    SUM(IF(genome_id = 21, 1, 0)) AS genome_21,
    SUM(IF(genome_id = 22, 1, 0)) AS genome_22,
    SUM(IF(genome_id = 23, 1, 0)) AS genome_23,    
    SUM(IF(genome_id = 24, 1, 0)) AS genome_24,
    SUM(IF(genome_id = 25, 1, 0)) AS genome_25,
    SUM(IF(genome_id = 26, 1, 0)) AS genome_26,
    SUM(IF(genome_id = 27, 1, 0)) AS genome_27,
    SUM(IF(genome_id = 28, 1, 0)) AS genome_28,
    SUM(IF(genome_id = 29, 1, 0)) AS genome_29,
    SUM(IF(genome_id = 30, 1, 0)) AS genome_30,
    SUM(IF(genome_id = 31, 1, 0)) AS genome_31,
    SUM(IF(genome_id = 32, 1, 0)) AS genome_32,
    SUM(IF(genome_id = 33, 1, 0)) AS genome_33,
    SUM(IF(genome_id = 34, 1, 0)) AS genome_34,
    SUM(IF(genome_id = 35, 1, 0)) AS genome_35,
    SUM(IF(genome_id = 36, 1, 0)) AS genome_36,
    SUM(IF(genome_id = 37, 1, 0)) AS genome_37,
    SUM(IF(genome_id = 38, 1, 0)) AS genome_38,
    SUM(IF(genome_id = 39, 1, 0)) AS genome_39,
    SUM(IF(genome_id = 40, 1, 0)) AS genome_40,
    SUM(IF(genome_id = 41, 1, 0)) AS genome_41,
    SUM(IF(genome_id = 42, 1, 0)) AS genome_42,
    SUM(IF(genome_id = 43, 1, 0)) AS genome_43,    
    SUM(IF(genome_id = 44, 1, 0)) AS genome_44,
    SUM(IF(genome_id = 45, 1, 0)) AS genome_45,
    SUM(IF(genome_id = 46, 1, 0)) AS genome_46,
    SUM(IF(genome_id = 47, 1, 0)) AS genome_47,
    SUM(IF(genome_id = 48, 1, 0)) AS genome_48,
    SUM(IF(genome_id = 49, 1, 0)) AS genome_49,
    SUM(IF(genome_id = 50, 1, 0)) AS genome_50,
    SUM(IF(genome_id = 51, 1, 0)) AS genome_51,
    SUM(IF(genome_id = 52, 1, 0)) AS genome_52,
    SUM(IF(genome_id = 53, 1, 0)) AS genome_53,
    SUM(IF(genome_id = 54, 1, 0)) AS genome_54,
    SUM(IF(genome_id = 55, 1, 0)) AS genome_55,
    SUM(IF(genome_id = 56, 1, 0)) AS genome_56,
    SUM(IF(genome_id = 57, 1, 0)) AS genome_57
    FROM orthomcl
    GROUP BY group_id
/);

$dbh->do(q/DROP TABLE IF EXISTS orthomcl_pattern_short/);
$dbh->do(q/
    CREATE TABLE orthomcl_pattern_short
    SELECT 
    group_id,
    SUM(IF(genome_id = 1, 1, 0)) AS genome_1,
    SUM(IF(genome_id = 2, 1, 0)) AS genome_2,
    SUM(IF(genome_id = 3, 1, 0)) AS genome_3,
    IF(SUM(IF(genome_id > 3, 1, 0)), '+', '-') AS other_strep
    FROM orthomcl
    GROUP BY group_id
/);
#=cut
$dbh->do(q/DROP TABLE IF EXISTS orthomcl_pattern_count/);
$dbh->do(q/
    CREATE TABLE `orthomcl_pattern_count` (
        `pattern` char(12) DEFAULT NULL,
        `count` int(11) NOT NULL,
        `co_orth` char(12) DEFAULT NULL
    )
/);

my $select = $dbh->prepare(q/
    SELECT group_id, other_strep, genome_1, genome_2, genome_3 FROM orthomcl_pattern_short
/);

my $tmp_file = File::Temp->new();

$select->execute();
my %patterns = ();
my %co_patterns = ();
while (my ($group_id, $other_strep, @genomes) = $select->fetchrow_array()) {
    my $co_orth = 0;
    while (my ($pattern, $n) = new_pattern(\@genomes)) {
        $pattern .= $other_strep eq '+' ? 1 : 0;
        $co_orth ? ($co_patterns{$pattern} += $n) : ($patterns{$pattern} += $n);
        $co_orth = 1;
    }
}
for my $pattern (keys %patterns) {
    $tmp_file->print($pattern, "\t", $patterns{$pattern}, "\t", '\N', "\n");    
}
for my $pattern (keys %co_patterns) {
    $tmp_file->print($pattern, "\t", $co_patterns{$pattern}, "\t", 'co_ortholog', "\n");    
}
$tmp_file->close();

my $load = $dbh->prepare(q/LOAD DATA LOCAl INFILE ? INTO TABLE `orthomcl_pattern_count`/);
$load->execute($tmp_file);

print "...OK\n";

###########################
sub new_pattern {
    my $garray = shift;
    
    my $min = (sort {$b <=> $a} @$garray)[0];
    map {$_ && $_ < $min ? $min = $_ : 0} @$garray;
    
    die "ERROR: undefine value of min variable\n" if not defined $min;
    die "ERROR: negative value of min variable\n" if $min < 0;
    
    return unless $min;
    
    my $pt = '';
    for my $value (@$garray) {
        $pt .= $value == 0 ? 0 : 1;
#        $pt .= "\t";
        $value -= $min if $value;        
    }
    
    return $pt, $min;
}


