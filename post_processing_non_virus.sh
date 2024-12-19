checkm_bins_folder=$1
t=$2 
output_path=$3
fastq1=$4
fastq2=$5
contigs_v=$6
log_folder=$7
#pass fastq from virome data, not bacteria
#Constants

viral_bin_scaffold_file=$output_path/viral_bin_scaffold.csv
viral_bin_scaffold_file_clean=$output_path/viral_bin_scaffold_clean.csv
clean_contig_v=$output_path/contig_rebinning.fasta



#remove bin id, only keep contig id for filter_contig.py
cut -d',' -f1 $viral_bin_scaffold_file > $viral_bin_scaffold_file_clean 
#run filter bin py to clean unwanted contigs


echo "python $metaIVP_path/python_scripts/utility/filter_seq_from_fasta.py $contigs_v $viral_bin_scaffold_file_clean $clean_contig_v"
python $metaIVP_path/python_scripts/utility/filter_seq_from_fasta.py $contigs_v $viral_bin_scaffold_file_clean $clean_contig_v
echo "$contigs_v $viral_bin_scaffold_file_clean $clean_contig_v"


non_virus_output=$output_path/non_virus

if [ ! -d "$non_virus_output" ] ; then
        mkdir $non_virus_output
fi

echo "SAMTOOLS METHOD STARTED"
log_post_processing_non_virus_samtools=$log_folder/post_processing_non_virus_samtools.log
if [ -f "$log_post_processing_non_virus_samtools" ] ; then
                        echo "$log_post_processing_non_virus_samtools exists. Skip preprocessing..."
else
	#Baterial analysis:
	#generate indices
	idc=$non_virus_output/indexed_contigs/
	mkdir $idc
	bin_not_virus=$output_path/contig_rebinning.fasta
	#build index on clean contigs
	echo "starting index contigs $(date)..."
	bowtie2-build $clean_contig_v $idc/indexed_contigs
	echo "indexed contigs done at $(date)"
	#SAM FILE CREATION
	echo "starting SAM file creation"
	#generate SAM file
	sam_file=$non_virus_output/contig_mapping.sam
	if [ ! -f "$sam_file" ] ; then
		echo "starting bowtie alingment into sam file $(date)..."
		bowtie2 --threads $t -x $idc/indexed_contigs -1 $fastq1 -2 $fastq2 --no-unal -S $sam_file
		echo "ending sam file done at $(date)..."
	else
		echo "sam file exists"
	
	fi
	#bowtie2 --threads $t -x $idc/indexed_contigs -1 $fastq1 -2 $fastq2 --no-unal -S $sam_file
	#SAMTOBAM conversion

	echo "starting SAM to BAM conversion"
	bam_file=$non_virus_output/contig_mapping.bam


	if [ ! -f "$bam_file" ] ; then
		echo "starting bam file at $(date)..."
		samtools view -F 4 -bS $sam_file > $bam_file
	else
		echo "bam file exists"
		echo "ending bam file ends at $(date)..."
	fi


	#BAM FILE SORTING
	echo "bam sorting"
	bam_sorted_file=$non_virus_output/contig_mapping_sort.bam
	echo "starting sort bam file $(date)..."
	samtools sort $bam_file -o $bam_sorted_file
	echo "ending bam file sorting at  $(date)..."

	#816-add_path-K.Sahu
	#create bam.bai file
	#explicit creation (remove samtools overwrite inconsistency) 
	bam_bai_file=$non_virus_output/contig_mapping_sort.bam.bai

	if [ ! -f "$bam_file" ] ; then
		samtools index $bam_sorted_file $bam_bai_file

	else
		echo "bam_bai file exists"

	fi
#samtools index $bam_sorted_file $bam_bai_file
	touch $log_post_processing_non_virus_samtools
fi
echo "SAMTOOLS METHOD COMPLETED BY IVP"




echo "BINNING METHOD STARTED"
binfolder=$non_virus_output/BINS
log_post_processing_non_virus_binning=$log_folder/post_processing_non_virus_binning.log
if [ -f "$log_post_processing_non_virus_binning" ] ; then
                        echo "$log_post_processing_non_virus_binning exists. Skip preprocessing..."
else
	#BINNING
	echo "starting BINNING modules $(date)"
	echo "starting depth file creation $(date)"
	depth_file=$non_virus_output/depth.txt
	jgi_summarize_bam_contig_depths --outputDepth $depth_file $bam_sorted_file
	echo "finished depth file creation $(date)"
	echo "starting binning $(date)"
	#binfolder=$non_virus_output/BINS
	if [ ! -d "$binfolder" ] ; then
        	mkdir $binfolder
	fi

	bins=$binfolder/bins

#checking for mininmum_contig_length. If user provides value, use that. Else set minimum_contig_length as 1000bp.
#to get binned and unbinned contigs
	minimum_contig_len=1000
	if [[ $((minimum_contig_len+0)) -gt 1500 ]] ; then
		echo "metabat2 -i $bin_not_virus -a $depth_file -o $bins -m $minimum_contig_len --seed 1 --unbinned"
		echo "starting binning $(date)..."
		metabat2 -i $bin_not_virus -a $depth_file -o $bins -m $minimum_contig_len --seed 1 --unbinned
		echo "ending binning $(date)..."
		echo "Metabat for greater than 1500 KBP"
	
	else
		echo "metabat2 -i $bin_not_virus -a $depth_file -o $bins -m 1500 --seed 1 --unbinned"
		metabat2 -i $bin_not_virus -a $depth_file -o $bins -m 1500 --seed 1 --unbinned
		echo "Metabat equal to 1500 KBP"
	fi
	touch $log_post_processing_non_virus_binning
fi
echo "BINNING METHOD ENDED"


checkm=$non_virus_output/CHECKM_2
if [ ! -d "$checkm" ] ; then
        mkdir $checkm
fi

echo "ending binning $(date)"
#CHECKM

echo "starting checkm"
c_bins=$binfolder
source activate checkm2

log_post_processing_non_virus_checkm2=$log_folder/post_processing_non_virus_checkm2.log
if [ -f "$log_post_processing_non_virus_checkm2" ] ; then
        echo "$log_post_processing_non_virus_checkm2 exists. Skip preprocessing..."

else
	echo "Starting post processing non virus CHECKM2 $(date)"
	echo "checkm2 predict --threads $t --input $binfolder -x fa --output-directory $checkm --force"
	echo "starting checkm $(date)..."
	checkm2 predict --threads $t --input $binfolder -x fa --output-directory $checkm --force --database_path $CHECKM2DB
	echo "ending checkm $(date)..."
	touch $log_post_processing_non_virus_checkm2
fi

##echo "checkm2 predict --threads $t --input $bins --output-directory $checkm"
##checkm2 predict --threads $t --input $bins --output-directory $checkm

mergedfile=$checkm/bins
find $mergedfile  -type f -name '*.faa' -exec cat {} + >$mergedfile/mergedfile.fna

#source deactivate kalzone
#iRep
#source activate irep

irep_output=$non_virus_output/irep
if [ ! -d "$irep_output" ] ; then
        mkdir $irep_output
fi

bins_count=$(ls -la $binfolder/bins.*.fa | wc -l)
new_bins_count=$(($bins_count-1))

log_post_processing_non_virus_irep=$log_folder/post_processing_non_virus_irep.log
if [ -f "$log_post_processing_non_virus_irep" ] ; then
        echo "$log_post_processing_non_virus_irep exists. Skip preprocessing..."
else
	for i in $(seq $new_bins_count); do
		outputfile_irep=$irep_output/irep_output_bins.$i
		inputfile_irep=$binfolder/bins.$i.fa
		echo $outputfile
        	echo "starting irep $(date)..."
		iRep -f $inputfile_irep -s $sam_file -o $outputfile_irep
		echo "ending irep $(date)..."
	done
	touch $log_post_processing_non_virus_irep
fi


#end irep

#ADD KRAKEN LATER
#start kraken
#kraken_output=non_virus_output/kraken
#if [ ! -d "$kraken_output" ] ; then
#        mkdir $kraken_output
#
#fi
#echo "starting krkane2 $(date)..."
#for i in $(seq $bins_count); do
#	outputfile=$kraken_output/bins.$i.kraken
#	reportfile=$kraken_output/bins.$i.report
#	inputfile=$bins/bins.$i.fa

	#echo $outputfile
	#echo $reportfile
	#echo $inputfile
#	kraken2 --db $KRAKEN_DATABASE --use-names --threads $thread --output $outputfile --report $reportfile $inputfile
#done
#echo "starting kraken2 $(date)..."
#iRep -f $bin_not_virus -s $sam_file -o $irep_output
#add irep here with loop of bins folder, and add kraken2 from IMP.
#then we need py for final csv table.

#replication rate purification

python $metaIVP_path/python_scripts/purify_replication_rate.py irep -i $irep_output

source deactivate
