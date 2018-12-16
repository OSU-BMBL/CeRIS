#!/usr/bin/perl
#use warnings;
use DBI;

#my $workdir = "/home/www/html/iris3/program/step3/2018110573518_CT_5_bic";
my $path = $ARGV[0];
die "Please specify which directory to search" 
    unless -d $path;
	

    open(my $fh, '<', $path."/species.txt") or die "cannot open file $filename";
    {
        local $/;
        $id = <$fh>;
    }
    close($fh);
	
opendir( my $DIR, $path );
while ( my $entry = readdir $DIR ) {
    next unless -d $path . '/' . $entry;
    next if $entry eq '.' or $entry eq '..';
    print "Found directory $entry\n";
	my $workdir = $path.'/'.$entry;
	opendir my $dir, $workdir or die "Cannot open directory: $!";
	my @files = readdir $dir;
	closedir $dir;
	
	
	foreach my $filename (@files){
	my $filename_regex = qr/bic[0-9]*\.txt/mp;
	if ( $filename =~ /$filename_regex/g ) {
		my $matrix;	
		my $fullname =  $workdir.'/'.$filename;
		my $file_location = $fullname."\.fa";
		#my $file_location = "/home/www/html/iris3/program/step3/test.fa"; 
		
	open(my $fh, '<:encoding(UTF-8)', $fullname) or die "Could not open file '$fullname' $!";

	my $dsn = "DBI:mysql:eukaryotic";
	my %attr = ( PrintError=>0, RaiseError=>1);    
	my $username = "root";       
	my $pw = "Bm\$\$1100Mq";   
	$myConnection = DBI->connect($dsn, $username, $pw, \%attr);
	while (my $row = <$fh>) {
	#chomp $row;
	#$row = "ENSG00000211459";
	$row =~ s/\R//g;
	$str = "SELECT sequence FROM gene WHERE gene_id = '".$row."' AND species_id = '".$id."'\n";

	$query = $myConnection->prepare($str);
	$result = $query->execute();
		while (my $line = $query->fetchrow()) {
			  #print "$line\n";
			  $line = substr($line, -1000);
			  $matrix .= ">".$row."\n".$line."\n";
			  
		}
	}
	close $fh;
	print $fullname."\n";
	open(my $fh, '>', $file_location) or die "Could not open file '$filename' $!";
	print $fh $matrix;
	close $fh;
	}
  	}

	


}
closedir $DIR;





