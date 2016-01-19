#!/usr/bin/perl

my $fur_resu="dd_further_results.txt";
open (DDOUT,'>',$fur_resu)or die;
print DDOUT "Name\tNum\tCoverage\t100-600Num\t100-600Cover\n";
my $res_files="./dd_results";
opendir DIRE,$res_files or die;
foreach my $name (readdir DIRE){
	next if $name=~/^\./;
	chomp $name;
	print "$name\n";
	my $abs_name=$res_files."/".$name;
	open (REFILE,'<',$abs_name) or die "do not open result files";
	my @lines=<REFILE>;
	my %num_hash;
	my %len_hash;
	foreach (@lines){
		chomp $_;
		my @cells=split /\t/, $_;
		$num_hash{$cells[0]}=$cells[1];
		my $length=$cells[0]*$cells[1];
		$len_hash{$cells[0]}=$length;

	}
	
	my $dd_num;
	my $dd_length;
	my @num_values= values %num_hash;
	foreach (@num_values){
		$dd_num += $_;

	}

	my @len_values= values %len_hash;
	foreach (@len_values){
		$dd_length +=$_;
	}

	my $dd_num_600;
	my $dd_length_600;
	my $frag=100;
	for ($frag=100;$frag<601;$frag++){
		$dd_num_600 += $num_hash{$frag};
		$dd_length_600 += $len_hash{$frag};

	}
	
	print DDOUT "$name\t$dd_num\t$dd_length\t$dd_num_600\t$dd_length_600\n";
	close REFILE;
}
closedir DIRE;
close DDOUT;

