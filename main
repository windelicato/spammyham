#!/usr/bin/perl
# Bayesian library used under GNU General Public License
# Library written by Gea-Suan Lin, <gslin at gslin.org>

@email = readtxt($ARGV[0]);
print bayesian(@email);

sub bayesian($){
	use Algorithm::Bayesian;
	my %spam_hash;
	my $b = Algorithm::Bayesian->new(\%spam_hash);
	@spam=readtxt( "spam.txt"); 
	@ham=readtxt( "ham.txt"); 
	 
	$b->spam(@spam);
	$b->ham(@ham);
	return $b->test(@email);
}

sub readtxt($){
	undef($/); 
	open(EMAIL, $filename)
		or die "Invalid file $filename\n";

	while(<EMAIL>){
		(@words)=split(/\s+/);
	}
	close EMAIL;

	for (@words){
		s/[^a-zA-Z\d]//g;
		$words{$_}++;
	}

	return "@words";
}
