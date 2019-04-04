#!/usr/bin/perl
#use warnings;
use DBI;

#my $workdir = "/home/www/html/iris3/program/step3/2018110573518_CT_5_bic";
my $path = $ARGV[0];
my $length = $ARGV[1];
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
	my $matrix_bed;
	my $file_location_bed = "gene_region.bed";
	foreach my $filename (@files){
	my $filename_regex = qr/bic[0-9]*\.txt$/mp;
	if ( $filename =~ /$filename_regex/g ) {
		my $matrix;	
	
		my $fullname =  $workdir.'/'.$filename;
		my $file_location_fa = $fullname."\.fa";
	
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
	$str = "SELECT sequence,chro_id,start,end,strand FROM gene WHERE gene_id = '".$row."' AND species_id = '".$id."'\n";
	#$chro_id_str = "SELECT chro_id FROM gene WHERE gene_id = '".$row."' AND species_id = '".$id."'\n";
	#$start_str = "SELECT start FROM gene WHERE gene_id = '".$row."' AND species_id = '".$id."'\n";
	#$end_str = "SELECT end FROM gene WHERE gene_id = '".$row."' AND species_id = '".$id."'\n";
	#$strand_str = "SELECT strand FROM gene WHERE gene_id = '".$row."' AND species_id = '".$id."'\n";
	$query = $myConnection->prepare($str);
	#$query_chro_id = $myConnection->prepare($chro_id_str);
	#$query_start = $myConnection->prepare($start_str);
	#$query_end = $myConnection->prepare($end_str);
	#$query_strand =  $myConnection->prepare($strand_str);
	$query->execute();
	#my @test_result = $query->fetchrow_array();
	#print($test_result[2]);
	#$query_chro_id->execute();
	#$query_start->execute();
	#$query_end->execute();
	#$query_strand->execute();
	#my $start = $query_start->fetchrow();
	#my $end = $query_end->fetchrow();
	#my $strand = $query_strand->fetchrow();
		while (my @line = $query->fetchrow_array()) {
			  $line[0] = substr($line[0], -$length);
			  if($line[0] ne ''){
			  $matrix .= ">".$row."\n".$line[0]."\n";
					if($line[4] eq '+'){
					$matrix_bed .= "chr".$line[1]."\t".($line[2]-$length-1)."\t".$line[2]."\n";
					} else{
					$matrix_bed .= "chr".$line[1]."\t".$line[3]."\t".($line[3]+$length+1)."\n";
					}
					
			  }
		}
		
	}
	close $fh;
	print $fullname."\n";
	open(my $fh, '>', $file_location_fa) or die "Could not open file '$filename' $!";
	print $fh $matrix;
	close $fh;
	}
	open(my $fh, '>', $file_location_bed) or die "Could not open file '$filename' $!";
	print $fh $matrix_bed;
	close $fh;
  	}

	


}
closedir $DIR;





