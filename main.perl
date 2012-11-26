#!/usr/bin/perl
# Bayesian library used under GNU General Public License

my %spam_hash;
my %ham_hash;
my %prob_hash;
@email = readtxt($ARGV[0]);
bayesian(@email);

sub bayesian($){
	load_db();
	foreach $word (@email){
		$s = 0, $h=0;
		if(exists $spam_hash{$word}){
			$s = $spam_hash{$word};
		}
		if(exists $ham_hash{$word}){
			$h = $ham_hash{$word};
		}

		$prob_hash{$word} = $s/($s+$h);	
	}

	my $total = 0;
	for (keys %prob_hash) {
		$total = $total + $prob_hash{$_};
		print $_ , "\t" , "=>" , "\t", $prob_hash{$_}, "\n";
	}
	print $total / keys(%prob_hash);
}

sub load_db($){
	@spam=readtxt("spam.txt"); 
	@ham=readtxt("ham.txt"); 

	foreach $word (@spam){
		$spam_hash{$word}++;
	}

	foreach $word (@ham){
		$ham_hash{$word}++;
	}
}

sub readtxt($){
	$filename = shift;
	undef($/); 
	open(FILE, $filename)
		or die "Invalid file $filename\n";

	while(<FILE>){
		(@words)=split(/\s+/);
	}
	close FILE;

	for (@words){
		s/[^a-zA-Z\d]//g;
		$words{$_}++;
	}

	return @words;
}
