#!/bin/bash

cat *.fa > binded_chr.txt
perl chr_length.pl
echo "Running Over"





#####################################################    Usage of the script #######################################################################################
####                                                                                                                                                            ####
####      step1: copy reference genome sequence files (*.fa) into the directory that the script is in.                                                          ####
####      step2: type "./chromosome_length.sh" in command line to run the script. The results will be outputted into "chr_length.txt" file.                     ####
####                                                                                                                                                            ####
####################################################################################################################################################################
