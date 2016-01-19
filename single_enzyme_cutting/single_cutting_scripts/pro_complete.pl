#!/usr/bin/perl -w
use strict;


my %hash_1 =(
   'GTAC'=> 2,

   'GCWGC'=> 1,
   'CTGCAG'=> 5,
   'GGCCGGCC'=> 6,
   'GATC'=>0,
   'CTNAG'=>1,
    'GANTC'=>1,
    'TCNGA'=>3,

);

my @key_1 =keys %hash_1;

print "input the number of chromsomes\n";
my $x_files =<>;
for (my $y_files =1; $y_files< ($x_files +1); $y_files++){
   my $chr = "chr".$y_files;
   
  foreach my $ha1_key(@key_1){
   
    my $X;
    my $ha1_key_len = length ($ha1_key);
    for (my $nu =0; $nu < $ha1_key_len; $nu++ ){
        my $nu_2 = $nu;
        if ($nu > 9) {
            $nu_2 = $nu-10;
        }
        
        $X .=$nu_2;
    }
    
    
    my $input = "./INPUT_CHR/".$chr.".fa";
    my $output= "./OUTPUT_STEP1/STEP1".$ha1_key.$hash_1{$ha1_key}.$chr.".txt";
    open(INPUT,'<', $input) or die "snowing again!";
    open(OUTPUT, '>', $output) or die;

     my @input =<INPUT>;
     my $strings;
    foreach (@input){
         chomp $_;
         unless($_ =~ /^>/){
             $strings .= $_;
         }
    }
    
    my $subs = $ha1_key;
    $subs =~ s/R/[AG]/g;
    $subs =~ s/Y/[CT]/g;
    $subs =~ s/W/[AT]/g;
    $subs =~ s/N/[ATGC]/g;
            
    $strings =~ s/$subs/$X/g;
    my @where;
    my $index;
    my $i=0;
    my $j=0;
    my $num = length($strings);
    for ($i=0; $i< $num; $i++){
         $index = index($strings, $X, $j);
         $where[$i] = $index+ $hash_1{$ha1_key};
         $j = $where[$i]+1;
         if ($index == -1) {
                last;
          }
  
    }

    my @read_length;
    my $num2 = @where;

    $read_length[0]= $where[0];
    for (my $x=1; $x <($num2-1); $x++){
       $read_length[$x]= $where[$x]-$where[$x-1];    
    }
    $read_length[$num2-1]= $num - $where[$num2-2];


     my $num3 = @read_length;
    for (my $y =0; $y< ($num3); $y++){
        print OUTPUT $read_length[$y]."\n";
    }
  }
}

close INPUT;
close OUTPUT;
################################################
############## Step II ########################


for (my $y_files =1; $y_files< ($x_files +1); $y_files++){
   my $chr = "chr".$y_files;
   
  foreach my $ha1_key(@key_1){
    
    my $input_2 = "./OUTPUT_STEP1/STEP1".$ha1_key.$hash_1{$ha1_key}.$chr.".txt";
    my $output_2= "./OUTPUT_STEP1/STEP2".$ha1_key.$hash_1{$ha1_key}.$chr.".txt";
    open(INPUT,'<', $input_2) or die "stepII!";
    open(OUTPUT, '>', $output_2) or die;

    my @input_2 =<INPUT>;
    my @lengths_by_sort;
    my $item =0;
    
    my @input_2_sorted = sort {$a <=> $b} @input_2;
    
    foreach (@input_2_sorted){
        chomp $_;
        $lengths_by_sort[$item] = $_;
        $item += 1;
    }

    @lengths_by_sort = (@lengths_by_sort,"E");


    chomp @lengths_by_sort;
    
    my %hash;
    my $add;
    my $num = @lengths_by_sort;


   LINE:for ( my $i = 0; $i< $num; $i += $add){
    
    
       $hash{$lengths_by_sort[$i]} =1;
       for (my $j= $i+1; $j <$num ;$j++){
          if ($lengths_by_sort[$j] eq "E") {
            last LINE;
          }
        
          elsif ($lengths_by_sort[$j]== $lengths_by_sort[$i]) {
            $hash{$lengths_by_sort[$i]} += 1;
            
          }else{
             $add = $j-$i;
            
            last;
          }
        
        }
   
    }


    my $k;
    my $v;
    while (($k,$v)= each %hash) {
        print OUTPUT "$k\t$v\n";     # The output result: $k(the first column) is the length of a fragment; $v (the second column)is the number of the $k fragment.
    }
   

  }
}

close OUTPUT;
close INPUT;

##################################################
########## STEP III ######################

foreach my $ha1_key(@key_1){
    my $input3_1 = "./OUTPUT_STEP1/STEP2".$ha1_key.$hash_1{$ha1_key}."chr1.txt";
    open(INPUT3_1,'<', $input3_1) or die "stepIII 3-1!";
    
    my $output3= "./OUTPUT_STEP1/STEP3".$ha1_key.$hash_1{$ha1_key}.".txt";
    open(OUTPUT3, '>', $output3) or die;
    
    my @input1 =<INPUT3_1>;
    my %data1;
    foreach (@input1){
        if (/^(\d+)\t(\d+)/) {
                  $data1{$1}=$2;
        }  
    }
         

    for (my $y_files =2; $y_files< ($x_files +1); $y_files++){
         
         my $chr = "chr".$y_files;
         #print "$chr\n" ;
         my $input3_2 = "./OUTPUT_STEP1/STEP2".$ha1_key.$hash_1{$ha1_key}.$chr.".txt";
         open(INPUT3_2,'<', $input3_2) or die "stepIII 3-2!";
  
         my @input2 =<INPUT3_2>;
         my %data2;
         foreach (@input2){
             if (/^(\d+)\t(\d+)/) {
                 $data2{$1}=$2;
             }  
         }

        
        my @keys_1;
        my @keys_2;

        @keys_2 = keys %data2;
        @keys_1 = keys %data1;



        my $item;
        foreach $item (@keys_2){
            foreach(@keys_1){
               if ($_ == $item) {
                   $data1{$_} += $data2{$item};
                   delete $data2{$item};
                }    
            }
        }

        my @keys_3 = keys %data2;
        for (@keys_3){    
           $data1{$_} = $data2{$_};  
        }
       
        
    }
    my $k;
    my $v;
    while (($k,$v)= each %data1) {
          print OUTPUT3 "$k\t$v\n";
    }
    
}


close INPUT3_1;
close INPUT3_2;
close OUTPUT3;




