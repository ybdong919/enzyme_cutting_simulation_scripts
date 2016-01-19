
#!/usr/bin/perl -w

use strict;


open (DDLIST,'<',"dd_list.txt") or die;
my @ddlist=<DDLIST>;
foreach my $dd_line (@ddlist){
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
	
	#print "input the number of chromsomes\n";
	my $x_files =5;
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
	    
	    
	    my $input = "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$chr.".fa";
	    my $output= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$ha1_key.$hash_1{$ha1_key}.$chr.".txt";
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
	
	######################################################################
	###################  STEP-2  ########################################################################################
	
	for (my $y_files =1; $y_files< ($x_files +1); $y_files++){
	   my $chr = "chr".$y_files;
	   my $input_string = "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$chr.".fa";
	   my $output_total= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$chr."total_length.txt";
	   open(INPUT_ST,'<', $input_string) or die "snowing again!";
	   open(OUTPUT_TO,'>', $output_total) or die;
	   
	   my @input_string =<INPUT_ST>;
	   my $strings;
	   foreach (@input_string){
	         chomp $_;
	         unless($_ =~ /^>/){
	             $strings .= $_;
	         }
	    }
	   my $num = length($strings);
	   
	   
	   
	   my $input1= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$key_1[0].$hash_1{$key_1[0]}.$chr.".txt";
	   my $input2= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$key_1[1].$hash_1{$key_1[1]}.$chr.".txt";
	   my $output_dd= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$chr."dd_length.txt";
	   open(INPUT1,'<', $input1) or die ;
	   open(INPUT2,'<', $input2) or die ;
	   open(OUTPUT_DD, '>', $output_dd) or die;
	
	
	
	
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
	   #print @comb;
	   my $num_comb = @comb;
	
	   my @dd_length;
	   my @total_length;
	   my $n =0;
	
	   $total_length[0]= $comb[0];
	   for(my $i=1; $i< $num_comb; $i++ ){
	       $total_length[$i]= $comb[$i]- $comb[$i-1];
	       if ($hash_2{$comb[$i]} ne $hash_2{$comb[$i-1]}) {       
	           $dd_length[$n]= $comb[$i]- $comb[$i-1];
	           $n += 1;
	       }    
	    }
	    $total_length[$num_comb]= $num -$comb[$num_comb-1];
	    
	    foreach (@dd_length){
	        print OUTPUT_DD $_."\n";
	    }
	    foreach (@total_length){
	        print OUTPUT_TO $_."\n";
	    }
	}
	
	close INPUT_ST;
	close INPUT1;
	close INPUT2;
	close OUTPUT_TO;
	close OUTPUT_DD;
	
	#######################################################################################################
	############################ STEP -3 ###################################################################################
	
	
	for (my $y_files =1; $y_files< ($x_files +1); $y_files++){
	   my $chr = "chr".$y_files;
	   my $input_dd= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$chr."dd_length.txt";
	   my $input_total= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$chr."total_length.txt";
	   my $output_dd2= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$chr."dd_length_num.txt"; 
	   my $output_total2= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$chr."total_length_num.txt";
	   
	   open(INPUT_DD,'<', $input_dd) or die "stepII!";
	   open(INPUT_TO,'<', $input_total) or die "stepII!";
	   open(OUTPUT_DD2, '>', $output_dd2) or die;
	   open(OUTPUT_TO2, '>', $output_total2) or die;
	
	    ###################### caculate the number of chrx dd_length.txt 
	    my @input_dd =<INPUT_DD>;
	    my @lengths_by_sort;
	    my $item =0;
	    my @input_dd_sorted = sort {$a <=> $b} @input_dd;
	    
	    foreach (@input_dd_sorted){
	        chomp $_;
	        $lengths_by_sort[$item] = $_;
	        $item += 1;
	    }
	
	    @lengths_by_sort = (@lengths_by_sort,"E");
	
	
	    chomp @lengths_by_sort;
	    
	    my %hash_3;
	    my $add;
	    my $num = @lengths_by_sort;
	
	
	   LINE:for ( my $i = 0; $i< $num; $i += $add){
	    
	    
	       $hash_3{$lengths_by_sort[$i]} =1;
	       for (my $j= $i+1; $j <$num ;$j++){
	          if ($lengths_by_sort[$j] eq "E") {
	            last LINE;
	          }
	        
	          elsif ($lengths_by_sort[$j]== $lengths_by_sort[$i]) {
	            $hash_3{$lengths_by_sort[$i]} += 1;
	            
	          }else{
	             $add = $j-$i;
	            
	            last;
	          }
	        
	        }
	   
	    }
	
	
	    my $k;
	    my $v;
	    while (($k,$v)= each %hash_3) {
	        print OUTPUT_DD2 "$k\t$v\n";     # The output result: $k(the first column) is the length of a fragment; $v (the second column)is the number of the $k fragment.
	    }
	    
	    
	   ###################### caculate the number of chrx total_length.txt 
	    my @input_to =<INPUT_TO>;
	    my @lengths_by_sort_T;
	    my $item_T =0;
	    my @input_to_sorted = sort {$a <=> $b} @input_to;
	    
	    foreach (@input_to_sorted){
	        chomp $_;
	        $lengths_by_sort_T[$item_T] = $_;
	        $item_T += 1;
	    }
	
	    @lengths_by_sort_T = (@lengths_by_sort_T,"E");
	
	
	    chomp @lengths_by_sort_T;
	    
	    my %hash_T;
	    my $add_T;
	    my $num_T = @lengths_by_sort_T;
	
	
	   LINE:for ( my $i = 0; $i< $num_T; $i += $add_T){
	    
	    
	       $hash_T{$lengths_by_sort_T[$i]} =1;
	       for (my $j= $i+1; $j <$num_T ;$j++){
	          if ($lengths_by_sort_T[$j] eq "E") {
	            last LINE;
	          }
	        
	          elsif ($lengths_by_sort_T[$j]== $lengths_by_sort_T[$i]) {
	            $hash_T{$lengths_by_sort_T[$i]} += 1;
	            
	          }else{
	             $add_T = $j-$i;
	            
	            last;
	          }
	        
	        }
	   
	    }
	
	
	    my $k_T;
	    my $v_T;
	    while (($k_T,$v_T)= each %hash_T) {
	        print OUTPUT_TO2 "$k_T\t$v_T\n";    
	    }
	  
	}
	
	
	close INPUT_DD;
	close INPUT_TO;
	close OUTPUT_DD2;
	close OUTPUT_TO2;
	
	
	##########################################################################################################################
	############################# STEP -4 #######################################################################################
	
	
	    ################ caculate the result of double-digested fragments with different sticky ends,
	    ####################### namely one end is from cutting of enzyme I, the other end is from cutting of enzyme II.
	    
	my $input_dd3_1= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/chr1dd_length_num.txt";
	my $output_dd3= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$dd_name."_RESULT_dd.txt";
	open(INPUT_DD3_1,'<', $input_dd3_1) or die "stepIII 3-1!";
	open(OUTPUT_DD3, '>', $output_dd3) or die;
	    
	    my @input1 =<INPUT_DD3_1>;
	    my %data1;
	    foreach (@input1){
	        if (/^(\d+)\t(\d+)/) {
	                  $data1{$1}=$2;
	        }  
	    }
	         
	
	for (my $y_files =2; $y_files< ($x_files +1); $y_files++){
	         
	         my $chr = "chr".$y_files;
	         my $input_dd3_2= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$chr."dd_length_num.txt"; 
	         #my $input_total3= "/home/AAFC-AAC/dongy/paper4_data_for_runing/test/".$chr."total_length_num.txt";
	         
	         open(INPUT_DD3_2,'<', $input_dd3_2) or die "stepIII 3-2!";
	  
	         my @input2 =<INPUT_DD3_2>;
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
	    print OUTPUT_DD3 "$k\t$v\n";
	}
	    
	    ################ caculate the result of all double-digested fragments.##################################### 
	    
	my $input_to3_1= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/chr1total_length_num.txt";
	my $output_to3= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$dd_name."_RESULT_total.txt";
	open(INPUT_TO3_1,'<', $input_to3_1) or die "stepIII 3-1!";
	open(OUTPUT_TO3, '>', $output_to3) or die;
	    
	    my @input1_T =<INPUT_TO3_1>;
	    my %data1_T;
	    foreach (@input1_T){
	        if (/^(\d+)\t(\d+)/) {
	                  $data1_T{$1}=$2;
	        }  
	    }
	         
	
	for (my $y_files =2; $y_files< ($x_files +1); $y_files++){
	         
	         my $chr = "chr".$y_files;
	         my $input_to3_2= "/aafc-aac/home/users-data/dongy/paper4_data_for_runing/test/".$chr."total_length_num.txt";
	         
	         open(INPUT_TO3_2,'<', $input_to3_2) or die "stepIII 3-2!";
	  
	         my @input2_T =<INPUT_TO3_2>;
	         my %data2_T;
	         foreach (@input2_T){
	             if (/^(\d+)\t(\d+)/) {
	                 $data2_T{$1}=$2;
	             }  
	         }
	
	        
	        my @keys_1;
	        my @keys_2;
	
	        @keys_2 = keys %data2_T;
	        @keys_1 = keys %data1_T;
	
	
	
	        my $item;
	        foreach $item (@keys_2){
	            foreach(@keys_1){
	               if ($_ == $item) {
	                   $data1_T{$_} += $data2_T{$item};
	                   delete $data2_T{$item};
	                }    
	            }
	        }
	
	        my @keys_3 = keys %data2_T;
	        for (@keys_3){    
	           $data1_T{$_} = $data2_T{$_};  
	        }
	       
	        
	}
	my $k_T;
	my $v_T;
	while (($k_T,$v_T)= each %data1_T) {
	    print OUTPUT_TO3 "$k_T\t$v_T\n";
	}
	
	
	close INPUT_DD3_1;
	close INPUT_DD3_2;
	close INPUT_TO3_1;
	close INPUT_TO3_2;
	close OUTPUT_TO3;
	close OUTPUT_DD3;
	
unlink glob '*chr*.txt';	
	
}


close DDLIST;
