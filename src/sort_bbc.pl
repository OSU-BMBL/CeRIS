use strict;
use Bio::Index::Fasta;

# file names
#
my $In_Fasta_File_Name = "test.fa";
my $List_File_Name     = "list.txt";

#
# make index
#
my $Index_File_Name = "tmp.idx";
my $idx             = Bio::Index::Fasta->new(
 '-filename'   => $Index_File_Name,
 '-write_flag' => 1
);
$idx->make_index($In_Fasta_File_Name);

#
# open the list
#
open( my $list, $List_File_Name ) or die "Could not open $List_File_Name !";

#
# write to stdout using list and index
#
my $out = Bio::SeqIO->new( '-format' => 'Fasta', '-fh' => \*STDOUT );
while ( my $id = <$list> ) {
 chomp $id;
 my $seq = $idx->fetch($id); 
 $out->write_seq($seq);
}