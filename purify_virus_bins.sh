bins_folder=$1
output_path=$2
t=$3
contig_fasta_summary_file_determined=$4
contig_fasta_summary_file_not_determined=$5
contig_fasta=$6
log_folder=$7
DIR="${BASH_SOURCE[0]}"
DIR="$(dirname "$DIR")"
bin_fasta_file=$output_path/bin.fa


if [ ! -z $USER_ENV ]; then

        echo "------activating $USER_ENV--------"

        #source activate genomad_env

        echo "now trying $USER_ENV"

        source activate $USER_ENV

        fi

echo "This is Purfiy Virus Bins Script. I will create a new combined fasta file from bins provided by user and perform CheckV on it"
echo "python $DIR/python_scripts/combine_bins_2.py combine_bins -i $bins_folder -o $output_path"
python $DIR/python_scripts/combine_bin_to_fasta.py combine_bins -i $bins_folder -o $output_path

before_purify=$output_path/before_purify
if [ ! -d "$before_purify" ] ; then
        mkdir $before_purify
fi

#perform checkv on combined bins
log_purify_bins_checkv=$log_folder/purify_bins_checkv.log

#echo "checkv end_to_end $output_path/bin.fa $before_purify -t $t"
echo "starting checkv $(date)..."
		
if [ -f "$log_purify_bins_checkv" ] ; then
	echo "$log_purify_contigs_checkv exists. Skip preprocessing..."
	else 
		echo "checkv end_to_end $output_path/bin.fa $before_purify -t $t"
		echo "########THIS IS PURIFY BINS CONDUCTING A CHECKV"
		checkv end_to_end $output_path/bin.fa $before_purify -t $t
		echo "ending checkv $(date)..."
		touch $log_purify_bins_checkv
	fi

#perform purify bins

echo "python $DIR/python_scripts/purify_contigs_bins.py bin_determine -i $bin_fasta_file -b $bins_folder/my_scaffolds2bin.tsv -q $before_purify/quality_summary.tsv -d $contig_fasta_summary_file_determined -o $output_path"
python $DIR/python_scripts/purify_contig_bins.py bin_determine -i $bin_fasta_file -b $bins_folder/my_scaffolds2bin.tsv -q $before_purify/quality_summary.tsv -d $contig_fasta_summary_file_determined -nd $contig_fasta_summary_file_not_determined -o $output_path

if [ ! -z USER_ENV ]; then

                source deactivate 

                #conda deactivate

        fi

