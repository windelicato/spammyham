#!/usr/bin/perl
use strict;
use warnings;
# Bayesian library used under GNU General Public License

my $weight = 10;	# For small dbs, need to populate both databases
			# Use smaller weight for faster system
my %spam_hash;
my %ham_hash;
my %prob_hash;
my @email;
my $output;

sub bayesian($){
	load_db();

	if((keys %spam_hash) == 0 && (keys %ham_hash) ==0){
		return 0.5;     		# If dbs empty, let user decide
	}

	foreach my $word (@email){		# Check each word in email
		my $s = 0, my $h=0;
		if(exists $spam_hash{$word}){	# How many times is it in spam db?
			$s = $spam_hash{$word};
		}

		if(exists $ham_hash{$word}){	# How many times is it in ham db?
			$h = $ham_hash{$word};
		}

		# Probability of words being spam
		# Probability is 0.5 for rare word
		if(!((exists $ham_hash{$word}) || (exists $spam_hash{$word}))){
			$prob_hash{$word} = 0.5;
		}
		else{
			$prob_hash{$word} = $s/($s+$h);	
		}
	}

	my $num = 1; 				# Total probability = Average of all words 
	my $denom = 1;
	for (keys %prob_hash) {
		$num = $num * $prob_hash{$_};
		$denom = $denom * (1 - $prob_hash{$_});
#		print $_ , "\t" , "=>" , "\t", $prob_hash{$_}, "\n"; 	# Print per-word probabilities
	}


	return $num/($num+$denom);
}

sub load_db($){
	my @spam=readtxt("spam.txt"); 
	my @ham=readtxt("ham.txt"); 

	foreach my $word (@spam){		# Count occurances of each word in db
		$spam_hash{$word}++;		# 	Key = word, Value = count
	}

	foreach my $word (@ham){
		$ham_hash{$word}++;
	}
}

sub update_db{
	my $filename = $_[0];
	my $n = $_[1];
	for (my $i = 0; $i<$n; $i++){
		open(FILE, ">>$filename")
			or die "Invalid file $filename\n";
		print FILE " @email";
	}
}

sub readtxt($){			# Function for reading words of file into array
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

	for (@words){	# Remove all punctuation and convert to lowercase
		s/[^a-zA-Z\d]//g;
		tr/A-Z/a-z/;
		$words{$_}++;
	}

	return @words;
}

#################
# MAIN FUNCTION #
#################

@email = readtxt($ARGV[0]);
$output = bayesian(@email);


print "I've checked the email, and believe it is ";
if   ($output ==0.5) { print "UNDETERMINATE";}
elsif($output > 0.5) { print "SPAM";}
else 		     { print "HAM";}
print " With probability of " . $output . "\n";

print "\n\nSend to spam box? Y(es)/N(o)/Q(uit)\n";
my $choice = <STDIN>;
print $choice;
if($choice =~ /^[Y]$/i) {
	update_db("spam.txt",$weight);	
	update_db("ham.txt",1);	
}
elsif($choice =~ /^[N]$/i) {
	update_db("spam.txt",1);	
	update_db("ham.txt",$weight);	
}
elsif($choice =~ /^[Q]?$/i) {
	print "Goodbye!\n"
}
