bins_folder=$1
output_path=$2
t=$3
contig_fasta_summary_file_determined=$4
contig_fasta=$5
DIR="${BASH_SOURCE[0]}"
DIR="$(dirname "$DIR")"
bin_fasta_file=$output_path/bin.fa

echo "This is Purfiy Virus Bins Script. I will create a new combined fasta file from bins provided by user and perform CheckV on it"

echo "python $DIR/python_scripts/combine_bins_2.py combine_bins -i $bins_folder -o $output_path"
python $DIR/python_scripts/combine_bin_to_fasta.py combine_bins -i $bins_folder -o $output_path

#perform checkv on combined bins

if [ ! -f "$output_path/quality_summary.tsv" ]; then
                echo "$output_path/quality_summary.tsv exists. Skip purify bins..."
		echo "checkv end_to_end $output_path/bin.fa $output_path -t $t"
		checkv end_to_end $output_path/bin.fa $output_path -t $t
fi


#perform purify bins

echo "python $DIR/python_scripts/purify_contigs_bins.py bin_determine -i $bin_fasta_file -b $bins_folder/my_scaffolds2bin.tsv -q output_path/quality_summary.tsv -d $contig_fasta_summary_file_determined -o $output_path"
python $DIR/python_scripts/purify_contig_bins.py bin_determine -i $bin_fasta_file -b $bins_folder/my_scaffolds2bin.tsv -q $output_path/quality_summary.tsv -d $contig_fasta_summary_file_determined -o $output_path


virus_file=$output_path/bins_virus.fasta
final_checkv_for_virus=$output_path/virus_checkv

if [ ! -f "$final_checkv_for_virus" ]; then
	mkdir $final_checkv_for_virus
fi

checkv end_to_end $virus_file $final_checkv_for_virus -t $t
