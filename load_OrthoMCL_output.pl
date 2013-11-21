#!/usr/bin/perl -w

use strict;
use warnings;

use DBI;
use Getopt::Long;
use File::Temp;
use BioTools::Parser::OrthoMCL;

my $db_name;
my $host;
my $login;
my $password;

my $file;

GetOptions(
	'db=s' => \$db_name,
	'host=s' => \$host,
	'login=s' => \$login,
	'pass=s' => \$password,
        'input=s' => \$file
);

###################################
$db_name ||= 'test';
$host ||= 'localhost';
$login ||= 'root';
$password ||= '';
###################################

$file ||= 'groups.txt';

my $dbh = DBI->connect("DBI:mysql:$db_name:$host;mysql_local_infile=1", $login, $password, {RaiseError => 1, PrintError => 0}) || die "$DBI::err($DBI::errstr)\n";

my $orth = BioTools::Parser::OrthoMCL->new();
my $groups = $orth->parse($file);

$dbh->do(q/DROP TABLE IF EXISTS `orthomcl`/);
$dbh->do(q/
    CREATE TABLE IF NOT EXISTS `orthomcl` (
	`group_id` int(11) NOT NULL AUTO_INCREMENT, 
	`genome_id` int(11) NOT NULL, 
	`feature_id` int(11) NOT NULL, 
	KEY `group_id` (`group_id`),
	KEY `genome_id` (`genome_id`),
	KEY `feature_id` (`feature_id`)
    )
/);

my $tmp_file = File::Temp->new();
my $num = 0;
for my $group (@$groups) {
    $num++;
    for my $item (@$group) {
        next if $item !~ m/\|/; # skip group name of orthoMCL
        $tmp_file->print(join("\t", $num, split(/\|/, $item)), "\n");
    }
}
$tmp_file->close();

my $load = $dbh->prepare(q/LOAD DATA LOCAl INFILE ? INTO TABLE `orthomcl`/);
$load->execute($tmp_file);
print "loading...OK!\n";
print "the next step will take much time\n";
print "updating...";

$dbh->do(q/
    INSERT INTO orthomcl
    SELECT DISTINCT '\N', t3.genome_id, t1.feature_id FROM feature AS t1 INNER JOIN feature_tag AS t2 USING(feature_id)
    INNER JOIN genome AS t3 USING(seq_id)
    LEFT JOIN orthomcl AS t4 USING(genome_id, feature_id)
    WHERE t2.tag = 'translation' AND t4.group_id IS NULL
/);

print "OK!\n";
