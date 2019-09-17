#!/usr/bin/env perl
# Transfer a bobro output file (*.closures) to alignment format, which could be used by bbs
# read stdin, write stdout
use strict;
use warnings;
my $path = $ARGV[0];

#my $motif_now = '';
#while(<>) {
#  chomp;
#  next unless (s/^>//);
#
#  my ($motif, $seq) = (split)[0, 4];
#
#  if($motif eq $motif_now) {
#    print $seq, "\n";
#  } else {
#    $motif_now = $motif;
#    print ">$motif\n";
#    print $seq, "\n";
#  }
#}
#print ">end\n";


#my $path = "/home/www/html/iris3/data/20181222151846"; 
	my $out_name = "";
	my $out_dir = $path."/logo_tmp/";
	mkdir $out_dir;
	my $align = "";
opendir( my $DIR, $path );
while ( my $entry = readdir $DIR ) {
    next unless -d $path . '/' . $entry;
    next if $entry eq '.' or $entry eq '..';
	my $workdir = $path.'/'.$entry;
	opendir my $dir, $workdir or die "Cannot open directory: $!";
	my @files = readdir $dir;
	closedir $dir;
	
	
	foreach my $filename (@files){
    my $filename_regex = qr/bic[0-9]*\.txt.fa.closures$/mp;
	if ( $filename =~ /$filename_regex/g ) {
	
	my $fullname =  $workdir.'/'.$filename;

	if($fullname =~ m/CT/){
	my ($a)= $fullname =~ m/(?<=_CT_)\d+/g;
	}
	if($fullname =~ m/module/){
	my ($a)= $fullname =~ m/(?<=_module_)\d+/g;
	}
	my ($b)= $fullname =~ m/(?<=\/bic)\d+/g;
		open my $fh, $fullname or die "Could not open $fullname: $!";
		{
			my $motif_now = '';
			while(my $row = <$fh>) {
			  next unless ($row =~ s/^>//);
			  my ($motif, $seq) = (split ' ', $row)[0, 4];
			  if($motif eq $motif_now) {
			    $align .= $seq. "\n";
			  } else {
			    $motif_now = $motif;
				my ($c)= $motif =~ m/(?<=Motif-)\d+/g;
				
				if($fullname =~ m/CT/){
				my ($a)= $fullname =~ m/(?<=_CT_)\d+/g;
				$out_name = "ct".$a."bic".$b."m".$c;
				}
				if($fullname =~ m/module/){
				my ($a)= $fullname =~ m/(?<=_module_)\d+/g;
				$out_name = "module".$a."bic".$b."m".$c;
				}
			    $align .= ">".$out_name."\n";
			    $align .= $seq."\n";
			  }
			}	open(my $out, '>', $out_dir.$out_name.".b2a") or die "Could not open file '$filename' $!";
				print $out $align;
				close $out;
				$align = "";
		}
		close($fh);
		#print $fullname."\n";
	}

}

}
closedir $DIR;
