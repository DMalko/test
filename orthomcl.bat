#../bin/orthomclInstallSchema ./orthomcl.config ./install_schema.log
../bin/orthomclBlastParser ./allprots.blst ./compliantFasta >> ./similarSequences.txt
../bin/orthomclLoadBlast ./orthomcl.config ./similarSequences.txt
../bin/orthomclPairs ./orthomcl.config ./pairs.log cleanup=yes
../bin/orthomclDumpPairsFiles ./orthomcl.config
mcl ./mclInput --abc -I 1.5 -o mclOutput
../bin/orthomclMclToGroups group_ 1 < ./mclOutput > groups.txt

