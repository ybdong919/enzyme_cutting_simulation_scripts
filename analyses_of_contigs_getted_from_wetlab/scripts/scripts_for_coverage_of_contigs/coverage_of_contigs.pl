#!/usr/bin/perl


#####################################################    Preparation before running the script ################################################################
####                                                                                                                                                       ####
####      step1: Copy the columns of "qseqid", "sseqid","sstart" and "send" into a new file, and then change the order of these columns.                   ####
####             The new order should be "sseqid","sstart", "send" and "qseqid".                                                                           ####
####      step2: Make sure the value of "sstart" is less than the value of "send" in each row. Note: "IF" condition function in Excel can be used here.    ####
####      step3: Sort the whole table by column1 ("sseqid"), then by column2 ("sstart"), then by column3 ("send") in the order of smallest to largest.     ####
####      step4: Save the file into the same directory with the perl script. And name the file as  "sorted_alignment_position_of_contigs.csv".             ####
####                                                                                                                                                       ####
###############################################################################################################################################################

####################################################  Usage of the script ###########################################
####      Type "perl coverage_of_contigs.pl" in command line for running the script.                             ####
####      The result file can be found in the same directory and named as "coverage_of_contigs.txt"              ####
####                                                                                                             ####
#####################################################################################################################




########### caculate unoverlap- and overlap- coverages of contigs in every chromosomes

my $file="sorted_alignment_position_of_contigs.csv";
open (LINE,'<',$file)or die;
my @line=<LINE>;

my @first_line=split /,/, $line[0];
chomp $first_line[1];
chomp $first_line[2];
my $max_right_value=$first_line[2];

my $chr=$first_line[0];
chomp $chr;
my @unoverlap;
my $i=0;
$unoverlap[$i]=$first_line[2]-$first_line[1]+1;

my %hash;
my @chromosomes;
my $j=0;
$chromosomes[$j]=$chr;

my @overlap;
my $x=0;
my %hashover;

foreach (@line){
    my @cells=split /,/,$_;
    chomp $cells[0];
    chomp $cells[1];
    chomp $cells[2];
    chomp $cells[3];
    
    if ($cells[0] ne $chr){
          my $unoverlap_length=0;                                 # for unoverlap coverage of contigs
	  foreach (@unoverlap){
	        $unoverlap_length= $unoverlap_length+$_;
          }
          $hash{$chr}=$unoverlap_length;
              
          @unoverlap=();
          $i=0;
          $unoverlap[$i]=$cells[2]-$cells[1]+1;
          $max_right_value=$cells[2];
          
          
          my $overlap_length=0;                             # for overlap coverage of contigs
	  foreach (@overlap){
	         $overlap_length= $overlap_length+$_;
          }
          $hashover{$chr}=$overlap_length;
          @overlap=();
          $x=0;
          
          $chr = $cells[0];
          $j +=1;
          $chromosomes[$j]=$chr;
          redo;
     }
     
     my @subcells=split /__/, $cells[3];                 # for overlap coverage of contigs
     chomp $subcells[2];
     $overlap[$x]=$subcells[2];
     $x +=1;
     
     if ($cells[1]>$max_right_value){                     # for unoverlap coverage of contigs
          $i +=1;
          $unoverlap[$i]= $cells[2]-$cells[1]+1;        
          $max_right_value= $cells[2];
     }
     if ($cells[1]<=$max_right_value && $cells[2]>$max_right_value){
          $i +=1;
          $unoverlap[$i]= $cells[2]-$max_right_value;      
          $max_right_value=$cells[2];
     }
     if ($cells[1]<$max_right_value && $cells[2]<=$max_right_value){
         next;
     }
}

my $unoverlap_length=0;                                    # for unoverlap coverage of contigs in last chromosome
foreach (@unoverlap){
     $unoverlap_length= $unoverlap_length+$_;
}
$hash{$chr}=$unoverlap_length;

my $overlap_length=0;                                    # for overlap coverage of contigs in last chromosome
foreach (@overlap){
      $overlap_length= $overlap_length+$_;
 }
 $hashover{$chr}=$overlap_length;

######### output results

my $outunlap="coverage_of_contigs.txt";
open (OUTUNLAP,'>',$outunlap)or die;

print OUTUNLAP "Chr\t";
foreach (@chromosomes){
    print OUTUNLAP "$_\t";
}

print OUTUNLAP "\nContig length\t";
foreach (@chromosomes){
    print OUTUNLAP "$hashover{$_}\t";
}

print OUTUNLAP "\nUnbiased length\t";
foreach (@chromosomes){
    print OUTUNLAP "$hash{$_}\t";
}

close OUTUNLAP;
close LINE;




