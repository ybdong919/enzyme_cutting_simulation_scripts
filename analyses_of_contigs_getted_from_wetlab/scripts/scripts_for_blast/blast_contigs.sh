#!/bin/bash

# This shell script is used to blast contigs to reference genome

cat ./reference_genomes/*.fa > ./reference_genomes/db
makeblastdb -in ./reference_genomes/db -dbtype nucl

for file in *.fa
do
   blastn -query $file -db ./reference_genomes/db -out ./blast_results/$file"_result.txt" -outfmt 10
   ls ./blast_results/$file"_result.txt" > list.txt
   perl remove_duplicates.pl
done
rm list.txt
rm ./blast_results/*result.txt

echo "It is Completed"



#####################################################    Usage of the script #######################################################################################
####                                                                                                                                                            ####
####      step1: copy the contigs files in FASTA format (such as "**.fa") into the directory that the script is in.                                             ####
####      step2: generate two folders named as "reference_genomes" and "blast_results", respectively.                                                           ####
####      step3: copy the reference genome sequences files in FASTA format (such as "**.fa") into "reference_genomes" folder.                                   ####
####      step4: type "./blast_contig.sh" in command line to run the script. The blast results will be outputted into "blast_results" folder.                   ####
####      step5: Each result file includes 12 columns, namely "qseqid, sseqid, pident, length, mismatch, gapopen, gastart, qend, sstart, send, evalue,bitscore".####
####             Among these terms, "qseqid" means contig-id; "sseqid" means chromosome-id; "sstart" means start of alignment in reference genome.              ####
####             Please check BLASTN USAGE for detials of these terms,                                                                                          ####
####                                                                                                                                                            ####
####################################################################################################################################################################
