SET SESSION group_concat_max_len = 10;

SELEcT group_id, genome_1, genome_2, genome_3, other_strep,
(SELECT GROUP_CONCAT(t3.value SEPARATOR ';') FROM orthomcl AS t2 INNER JOIN feature_tag AS t3 USING(feature_id) 
WHERE t2.genome_id = 1 AND t2.group_id = t1.group_id AND t3.tag = 'locus_tag') AS locus1,
(SELECT GROUP_CONCAT(t5.value SEPARATOR ';') FROM orthomcl AS t4 INNER JOIN feature_tag AS t5 USING(feature_id) 
WHERE t4.genome_id = 2 AND t4.group_id = t1.group_id AND t5.tag = 'locus_tag') AS locus2,
(SELECT GROUP_CONCAT(t7.value SEPARATOR ';') FROM orthomcl AS t6 INNER JOIN feature_tag AS t7 USING(feature_id) 
WHERE t6.genome_id = 3 AND t6.group_id = t1.group_id AND t7.tag = 'locus_tag') AS locus3,
(SELECT GROUP_CONCAT(t8.genome_name SEPARATOR ';') FROM genome_name AS t8 INNER JOIN orthomcl AS t9 USING(genome_id)
WHERE t8.genome_id > 3 AND t9.group_id = t1.group_id) AS other
INTO OUTFILE '/tmp/pattern.txt'
FROM orthomcl_pattern_short AS t1
