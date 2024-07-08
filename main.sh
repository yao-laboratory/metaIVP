contigs_m=$1
contigs_v=$2
table3_m=$3
table3_v=$4
output_path=$5
bins_folder=$6
t=$7
quality_summary=$8
genomad_db=$9
fastq1_m=${10}
fastq2_m=${11}
fastq1_v=${12}
fastq2_v=${13}

#comined_virus_metagenome_contig_with_tags
#first we tag metagenome and virus contigs with '_m' and '_v'
#then we combine those two individual files
#combined_contigs=$output_path/combined_contigs.fasta

#output_directory_for_checkv_round0_on:contigs.fasta created on the virus dataset
checkv_purify_contigs=$output_path/purify_virus_contigs

#output_directory_for_checkv_round1_on_combined_m_and_v_contigs
checkv_purify_bins=$output_path/purify_virus_bins


#combine all sequences from all contigs from all bins in a giant file
#output_directory_checkv_run2=$output_path/checkv_round2

#output directory for checkm, last round (4)
#checkm=$output_path/CHECKM_BINS_CONTIGS/
bin_contigs_fasta=$checkm/contigs_m.fa

#create log folder for tracking
log_folder=$output_path/log_folder

#create directories
if [ ! -d "$output_path" ] ; then

        mkdir $output_path

fi


if [ ! -d "$checkv_purify_contigs" ] ; then

        mkdir $checkv_purify_contigs

fi


if [ ! -d "$checkv_purify_bins" ] ; then

        mkdir $checkv_purify_bins

fi


if [ ! -d "$log_folder" ] ; then
        mkdir $log_folder
fi


DIR="${BASH_SOURCE[0]}"

DIR="$(dirname "$DIR")"


echo "@@@@@@@@@###################@@@@@@@@@@"
echo "@@@@@@@@@###################@@@@@@@@@@"
echo "@@@@@@@@@###################@@@@@@@@@@"
echo "@@@@@@@@@###################@@@@@@@@@@"
echo "@@@@@@@@@###################@@@@@@@@@@"

echo "Starting IVP"

echo "@@@@@@@@@###################@@@@@@@@@@"
echo "@@@@@@@@@###################@@@@@@@@@@"
echo "@@@@@@@@@###################@@@@@@@@@@"
echo "@@@@@@@@@###################@@@@@@@@@@"
echo "@@@@@@@@@###################@@@@@@@@@@"


if [ "$read1" = "-h" ] ; then
	echo 'Usage information: 1) read1 = Forward paired-end file (FASTQ)
	2) read2 = Reverse paired-end file (FASTQ)
	3) sampleID = sample name used in renaming the fastq reads and later processing
	4) output_folder= Output folder path
	5) min_thread= Total number of threads
	6)min_contig_length (OPTIONAL) = filter contigs based on minimum length (ex: 1000)'

else
	# Purify contigs

	log_purify_contigs=$log_folder/purify_contigs.log
	if [ -f "$log_purify_contigs" ] ; then
		echo "$log_purify_contigs exists. Skip preprocessing..."
	else
		 echo "$log_purify_contigs does not exist"
		 echo "Starting Purify Virus Contigs $(date) ..."
		 echo "./purify_contigs.sh $contigs_v $checkv_purify_contigs $t $genomad_db"
	      	 $DIR/purify_virus_contigs.sh $contigs_v $checkv_purify_contigs $t $genomad_db
		 echo "completed pre-processing at $(date)"
		 touch $log_purify_contigs
	fi
	echo ' '
	echo '###########################################################################################################'
	
	echo "Starting Purify virus bins.Collect bins from V dataset,combine into bins.fa,perform checkv"

	log_purify_bins=$log_folder/purify_bins.log

	contig_fasta_summary_file_determined=$checkv_purify_contigs/contigs_determined.csv
	contig_fasta_summary_file_not_determined=$checkv_purify_contigs/contigs_not_determined.csv
	if [ -f "$log_purify_bins" ]; then
                echo "$log_purify_bins exists. Skip assembly and binning..."
        else
                echo "$log_purify_bins does not exist"
                echo "starting Purify Bins $(date)..."
	 	echo "$DIR/purify_virus_bins.sh $bins_folder $checkv_purify_bins $t"
		$DIR/purify_virus_bins.sh $bins_folder $checkv_purify_bins $t $contig_fasta_summary_file_determined $contig_fasta_summary_file_not_determined $contigs_v
		touch $log_purify_bins
	fi
	#conda deactivate
	echo ' '
	echo '###########################################################################################################'


	
#Post processing viral
	log_post_processing_virus=$log_folder/post_processing_virus.log
	checkm_bins_folder=$bins_folder

        if [ -f "$log_post_processing" ]; then
                echo "$log_post_processing exists. Skip assembly and binning..."
        else
                echo "$log_post_processing does not exist"
                echo "Post Processing $(date)..."
                echo "$DIR/post_processing.sh $checkm_bins_folder $t $output_path"
                #$DIR/post_processing.sh $checkm_bins_folder $t $output_folder
		$DIR/post_processing_virus.sh $checkm_bins_folder $t $checkv_purify_bins
		touch $log_post_processing_virus
        fi
#        source deactivate
	echo 'Post processing complete'
        echo ' '
        echo '###########################################################################################################'
#source deactivate

#Post processing metagenome
        log_post_processing_metagenome=$log_folder/post_processing_metagenome.log
        checkm_bins_folder=$bins_folder

        if [ -f "$log_post_processing" ]; then
                echo "$log_post_processing exists. Skip assembly and binning..."
        else
                echo "$log_post_processing does not exist"
                echo "Post Processing $(date)..."
                echo "$DIR/post_processing.sh $checkm_bins_folder $t $output_path $fastq1_v $fastq2_v $contigs_v"
                #$DIR/post_processing.sh $checkm_bins_folder $t $output_folder
		$DIR/post_processing_bacteria.sh $checkm_bins_folder $t $checkv_purify_bins $fastq1_v $fastq2_v $contigs_v
                touch $log_post_processing_metagenome
        fi
#        source deactivate
        echo 'Post processing complete'
        echo ' '
        echo '###########################################################################################################'



source deactivate
#Start Iter 0
#echo "Starting Round0: Cleaning Contig file from V dataset for first time with CheckV"

#echo "$DIR/round_zero.sh $contigs_v"
#$DIR/round_zero.sh $contigs_v $output_directory_checkv_run0



#Start Iter 1

#echo "Starting Round1: Checkv on bin.fasta (combined bins)"
fi
