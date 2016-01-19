#!/usr/bin/perl

my $binded_file="binded_chr.txt";
open (FILE,'<',$binded_file) or die;
my @bindedfile=<FILE>;

my %chr_name;
my @chrname;
my $u=0;
my $chr_leng=0;

my $w=0;
my @chrleng;

foreach (@bindedfile) {
   chomp $_;
   if (/^>/){
      $chrname[$u]=substr($_,1);
      $u +=1;
      if ($chr_leng != 0){
         $chrleng[$w]=$chr_leng;
         $w +=1;
         $chr_leng=0;
      
      }
      
      next;   
   }
    
   my $line_leng=length $_;
   $chr_leng +=$line_leng;  
}

$chrleng[$w]=$chr_leng;

my $out= "chr_length.txt";
open (OUT,'>',$out) or die;

print OUT "Chr\t";
foreach (@chrname){
   print OUT "$_\t";
}

print OUT "\nLength\t";
foreach (@chrleng){
    print OUT "$_\t";
}

close OUT;
close FILE;
