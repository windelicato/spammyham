#!/usr/bin/perl
use strict;
use warnings;
# Bayesian library used under GNU General Public License

my %spam_hash;
my %ham_hash;
my %prob_hash;
my @email;
my $output;

sub bayesian($){
	load_db();
	foreach my $word (@email){
		my $s = 0, my $h=0;
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

	return $total / keys(%prob_hash);
}

sub load_db($){
	my @spam=readtxt("spam.txt"); 
	my @ham=readtxt("ham.txt"); 

	foreach my $word (@spam){
		$spam_hash{$word}++;
	}

	foreach my $word (@ham){
		$ham_hash{$word}++;
	}
}

sub update_db($){
	my $filename = shift;
	open(FILE, ">>$filename")
		or die "Invalid file $filename\n";
	print FILE " @email";
	print "Printed to $filename";
}

sub readtxt($){		# Function for reading words of file into array
	my @words;
	my %words;
	my $filename = shift;
	undef($/); 
	open(FILE, $filename)
		or die "Invalid file $filename\n";

	while(<FILE>){	# Split by space
		(@words)=split(/\s+/);
	}
	close FILE;

	for (@words){	# Remove all punctuation 
		s/[^a-zA-Z\d]//g;
		$words{$_}++;
	}

	return @words;
}

#################
# MAIN FUNCTION #
#################

@email = readtxt($ARGV[0]);
$output = bayesian(@email);

print "I've checked the email, and believe it is";
if($output > 0.5) { print " SPAM";}
else 		  { print "HAM";}

print "\n\nSend to spam box? Y(es)/N(o)/Q(uit)\n";
my $choice = <STDIN>;
print $choice;
if($choice =~ /^[Y]$/i) {
	update_db("spam.txt");	
}
elsif($choice =~ /^[N]$/i) {
	update_db("ham.txt");	
}
elsif($choice =~ /^[Q]?$/i) {
}
