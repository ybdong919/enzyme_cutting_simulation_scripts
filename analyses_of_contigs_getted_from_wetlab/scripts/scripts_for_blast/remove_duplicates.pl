#!/user/bin/perl -w

open (LIST,'<','list.txt') or die;
my @filename=<LIST>;
close LIST;
chomp $filename[0];
my $filename = $filename[0];
#print $filename;

open (FILE,'<',$filename)or die;
my @lines=<FILE>;
my @clean_lines;
#print $lines[0];

foreach (@lines){
    chomp $_;
    my @cells = split /,/, $_;
    if (not @clean_lines){
        push @clean_lines, $_; 
    }
    
    my @controlcells =split /,/, $clean_lines[-1];
    my $control=$controlcells[0];
    if ($control ne $cells[0]){
       push @clean_lines, $_;
    }
}

my $out=$filename."_clean.txt";
open (OUT,'>',$out) or die;
foreach (@clean_lines){
   print OUT "$_\n";
}
close OUT;
close FILE;



