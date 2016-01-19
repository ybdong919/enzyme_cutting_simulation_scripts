#!/usr/bin/perl -w

use strict;

print "How many chromsomes in the tested organism?\n";
my $xx_files =<STDIN>;
chomp $xx_files;

open (DDLIST,'<',"dd_list.txt") or die;
my @ddlist=<DDLIST>;
foreach my $dd_line (@ddlist){

        ######################## STEP-1 #############################
        
	my @dd_cells=split /\t/, $dd_line;
	my $dd_name=$dd_cells[0];
	my %hash_1;
	for (my $i=1;$i<3;$i++){
		chomp $dd_cells[$i];
		my @dd_subcells=split /\//, $dd_cells[$i];
		$hash_1{$dd_subcells[0]}=$dd_subcells[1];

	}
	#my @print=%hash_1;
	#foreach (@print){
	#	print "$_\n";
	#}
        
	my @key_1 =keys %hash_1;
	my $x_files =$xx_files;
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
	    
	    my $input = $chr.".fa";
	    my $output= $ha1_key.$hash_1{$ha1_key}.$chr.".txt";
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
	    
	    my $matchx = $ha1_key;
	    $matchx =~s/R/[AG]/g;
	    $matchx =~s/Y/[CT]/g;
	    $matchx =~s/W/[AT]/g;
	    $matchx =~s/N/[CATG]/g;
	    $strings =~ s/$matchx/$X/g;
	    
	    my @where;
	    my $index;
	    my $i=0;
	    my $j=0;
	    my $num = length($strings);
	    for ($i=0; $i< $num; $i++){
	         $index = index($strings, $X, $j);
	         if ($index == -1) {
	                last;
	          }
	         $where[$i] = $index+ $hash_1{$ha1_key};
	         $j = $where[$i]+1;
	    }
	   
	     my $num3 = @where;
	    for (my $y =0; $y< ($num3); $y++){
	        print OUTPUT $where[$y]."\n";
	    }
	  }
	}
	
	close INPUT;
	close OUTPUT;
	
	###################  STEP-2  #######################################
	
	for (my $y_files =1; $y_files< ($x_files +1); $y_files++){
	   my $chr = "chr".$y_files;
	   my $input_string = $chr.".fa";
	   open(INPUT_ST,'<', $input_string) or die "snowing again!";
	   
	   my @input_string =<INPUT_ST>;
	   my $strings;
	   foreach (@input_string){
	         chomp $_;
	         unless($_ =~ /^>/){
	             $strings .= $_;
	         }
	    }
	   my $num = length($strings);
	   
	   my $input1= $key_1[0].$hash_1{$key_1[0]}.$chr.".txt";
	   my $input2= $key_1[1].$hash_1{$key_1[1]}.$chr.".txt";
	   my $output_ddloc= "./results/".$dd_name."_".$chr."_dd_cuttingsites.txt";
	   open(INPUT1,'<', $input1) or die ;
	   open(INPUT2,'<', $input2) or die ;
	   open(OUTPUT_DDLOC, '>', $output_ddloc) or die;
		
	   my @A =<INPUT1>;
	   my @B =<INPUT2>;
	   #print @B ;
	   my %hash_2;
	   my $num_A= @A;
	   my $num_B= @B;
	   for (my $i=0; $i< $num_A; $i++){
	       chomp $A[$i];
	       $hash_2{$A[$i]}= "A"; 
	   }
	   for (my $j=0; $j< $num_B; $j++){
	       chomp $B[$j];
	       $hash_2{$B[$j]}= "B"; 
	   }
	
	   my @comb = (@A,@B);
	   @comb = sort{$a <=> $b}@comb;
	   my $num_comb = @comb;
	   my @dd_length;
	   my $n =0;
	   my @dd_location;
	   
	   for(my $i=1; $i< $num_comb; $i++ ){
	       if ($hash_2{$comb[$i]} ne $hash_2{$comb[$i-1]}) {       
	           $dd_length[$n]= $comb[$i]- $comb[$i-1];
	           $dd_location[$n]=$comb[$i-1];
	           $n += 1;
	       }    
	    }
	   
	    print OUTPUT_DDLOC "Sites\tLength\n";
	    for (my $i=0;$i<$n;$i++){
	    	if(($dd_length[$i]>= 300) && ($dd_length[$i]<= 600)){
	    	     print OUTPUT_DDLOC $dd_location[$i]."\t".$dd_length[$i]."\n";
	    	}	    	     
	    }
	}
	close INPUT_ST;
	close INPUT1;
	close INPUT2;
	close OUTPUT_DDLOC;
	
unlink glob '*chr*.txt';

}

close DDLIST;
