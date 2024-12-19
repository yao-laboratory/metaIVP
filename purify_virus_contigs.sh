contigs_v=$1
output_path=$2
t=$3
genomad_db=$4
log_folder=$5

DIR="${BASH_SOURCE[0]}"
DIR="$(dirname "$DIR")"
qual_summ_file=$output_path/checkv_on_contigs/quality_summary.tsv

checkv_on_contigs=$output_path/checkv_on_contigs
echo "This is Purfiy Virus Contigs Script. I will perform checkV on the virus contigs.fasta provided by user"

#$USER_ENV

#if [ ! -z $USER_ENV ]; then
#	conda init $USER_ENV
#	conda activate $USER_ENV
#        fi


log_purify_contigs_checkv=$log_folder/purify_contigs_checkv.log
if [ -f "$log_purify_contigs_checkv" ] ; then
	echo "$log_purify_contigs_checkv exists. Skip preprocessing.."
else
	echo "$qual_summ_file  does not exist"
	echo "starting checkv $(date)..."
	checkv end_to_end $contigs_v $checkv_on_contigs -t $t
	touch $log_purify_contigs_checkv
	echo "ending checkv $(date)..."
fi


#if [ ! -z $USER_ENV ]; then
#	conda deactivate
#        fi

#this is for genomad
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
if [ ! -z $GENOMAD_ENV ]; then
	echo "------activating $GENOMAD_ENV--------"
	#source activate genomad_env
        echo "now trying $GENOMAD_ENV"
	source activate $GENOMAD_ENV
	fi
#source activate $genomad_env
#source activate genomad

log_purify_contigs_genomad=$log_folder/purify_contigs_genomad.log

if [ -f "$log_purify_contigs_genomad" ] ; then
	echo "$log_purify_contigs_genomad exists. Skip preprocessing..."
	else
		echo "starting genomad $(date)..."
		echo "$genomad_output  does not exist"
		#genomad end-to-end $t $contigs_v $genomad_output $genomad_db
		genomad end-to-end --cleanup --splits $t $contigs_v $genomad_output $genomad_db
		echo "genomad end-to-end --cleanup --splits $t $contigs_v $genomad_output $genomad_db"
		echo "starting genomad $(date)..."
		touch $log_purift_contigs_genomad
	fi


if [ ! -z $GENOMAD_ENV ]; then
                source deactivate #GENOMAD_ENV
		#conda deactivate
        fi
#source deactivate

#genomad_file=/work/yaolab/shared/2023_06_metaIVP/scripts/bin_contig_level_genomad/contigs_summary/contigs_virus_summary.tsv
genomad_file=$genomad_output/contigs_summary/contigs_virus_summary.tsv
echo "current env $CONDA_PREFIX"
echo "python $DIR/python_scripts/purify_contig_bins.py contigs_determine -i $contigs_v  -q $checkv_on_contigs/quality_summary.tsv -g $genomad_file -o $output_path"
python $DIR/python_scripts/purify_contig_bins.py contigs_determine -i $contigs_v  -q $checkv_on_contigs/quality_summary.tsv -g $genomad_file -o $output_path

