contigs_v=$1
output_path=$2
t=$3
genomad_db=$4


DIR="${BASH_SOURCE[0]}"
DIR="$(dirname "$DIR")"
qual_summ_file=$output_path/quality_summary.tsv


echo "This is Purfiy Virus Contigs Script. I will perform checkV on the virus contigs.fasta provided by user"


if [ -f "$qual_summ_file" ]; then
                echo "$qual_summ_file exists. Skip checkv..."
        else
                echo "$qual_summ_file  does not exist"
                echo "starting checkv $(date)..."
	       	checkv end_to_end $contigs_v $output_path -t $t
	fi




#this is foe genomred
#add file parameter to upstream
#this genomad result needs to be pased to python code (purify contigs, it has 4 parameters)
#this file is the begginning, it has both metagenome and virus.
#genomad_on_contig_file=
genomad_output=$output_path/genomad_on_contigs_v


#if [ ! -d "$genomad_output" ] ; then
#
#        mkdir $genomad_output
#
#fi

#genomad_env=genomad
#source activate $genomad_env
if [ -d "$genomad_output" ]; then
                echo "$genomad_output exists. Skip checkv..."
        else
                echo "$genomad_output  does not exist"
		#genomad end-to-end $t $contigs_v $genomad_output $genomad_db
		genomad end-to-end --cleanup --splits $t $contigs_v $genomad_output $genomad_db
		echo "genomad end-to-end --cleanup --splits $t $contigs_v $genomad_output $genomad_db"
                echo "starting checkv $(date)..."	
	fi

#source deactivate

#genomad_file=/work/yaolab/shared/2023_06_metaIVP/scripts/bin_contig_level_genomad/contigs_summary/contigs_virus_summary.tsv
genomad_file=$genomad_output/contigs_summary/contigs_virus_summary.tsv
python $DIR/python_scripts/purify_contig_bins.py contigs_determine -i $contigs_v  -q $output_path/quality_summary.tsv -g $genomad_file -o $output_path
