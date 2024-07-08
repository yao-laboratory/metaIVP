checkm_bins_folder=$1
t=$2 
output_path=$3
fastq1=$4
fastq2=$5
contigs_v=$6
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
source activate kalzone
#Baterial analysis:


DIR="${BASH_SOURCE[0]}"

DIR="$(dirname "$DIR")"



#generate indices
idc=$output_path/indexed_contigs/
mkdir $idc

bin_not_virus=$output_path/contig_rebinning.fasta
#build index on clean contigs
bowtie2-build $clean_contig_v $idc/indexed_contigs
echo "indexed contigs done"
#SAM FILE CREATION

echo "starting SAM file creation"

#generate SAM file

sam_file=$output_path/contig_mapping.sam


if [ ! -f "$sam_file" ] ; then
	bowtie2 --threads $t -x $idc/indexed_contigs -1 $fastq1 -2 $fastq2 --no-unal -S $sam_file
else
        echo "sam file exists"

fi
#bowtie2 --threads $t -x $idc/indexed_contigs -1 $fastq1 -2 $fastq2 --no-unal -S $sam_file
#SAMTOBAM conversion

echo "starting SAM to BAM conversion"
bam_file=$output_path/contig_mapping.bam


if [ ! -f "$bam_file" ] ; then
	samtools view -F 4 -bS $sam_file > $bam_file
else
	echo "bam file exists"
fi

#samtools view -F 4 -bS $sam_file > $bam_file

#BAM FILE SORTING
echo "bam sorting"
bam_sorted_file=$output_path/contig_mapping_sort.bam
samtools sort $bam_file -o $bam_sorted_file

#816-add_path-K.Sahu
#create bam.bai file
#explicit creation (remove samtools overwrite inconsistency) 
bam_bai_file=$output_path/contig_mapping_sort.bam.bai

if [ ! -f "$bam_file" ] ; then
	samtools index $bam_sorted_file $bam_bai_file

else
	echo "bam_bai file exists"

fi
#samtools index $bam_sorted_file $bam_bai_file


#BINNING
echo "starting BINNING modules"
echo "starting depth file creation"
depth_file=$output_path/depth.txt
jgi_summarize_bam_contig_depths --outputDepth $depth_file $bam_sorted_file
echo "finished depth file creation"
echo "starting binning"
binfolder=$output_path/BINS
if [ ! -d "$binfolder" ] ; then
        mkdir $binfolder
fi

bins=$binfolder/bins

#checking for mininmum_contig_length. If user provides value, use that. Else set minimum_contig_length as 1000bp.
#to get binned and unbinned contigs
minimum_contig_len=1000
if [[ $((minimum_contig_len+0)) -gt 1500 ]] ; then
	echo "metabat2 -i $bin_not_virus -a $depth_file -o $bins -m $minimum_contig_len --seed 1 --unbinned"
	metabat2 -i $bin_not_virus -a $depth_file -o $bins -m $minimum_contig_len --seed 1 --unbinned
	echo "Metabat for greater than 1500 KBP"
	
else
	echo "metabat2 -i $bin_not_virus -a $depth_file -o $bins -m 1500 --seed 1 --unbinned"
	metabat2 -i $bin_not_virus -a $depth_file -o $bins -m 1500 --seed 1 --unbinned
	echo "Metabat equal to 1500 KBP"
fi

checkm=$output_path/CHECKM
if [ ! -d "$checkm" ] ; then
        mkdir $checkm
fi



checkm lineage_wf -t $t -x fa $bins $checkm
mergedfile=$checkm/bins

#bins_folder_checkm=$binsfolder
#new checkm2 command, pending testing
echo "checkm2 predict --threads $t --input $binfolder -x fa --output-directory $checkm --force"
checkm2 predict --threads $t --input $binfolder -x fa --output-directory $checkm --force

##echo "checkm2 predict --threads $t --input $bins --output-directory $checkm"
##checkm2 predict --threads $t --input $bins --output-directory $checkm

find $mergedfile  -type f -name '*.faa' -exec cat {} + >$mergedfile/mergedfile.fna

#source deactivate kalzone


#iRep
#source activate irep
irep_output=$output_path/irep_output
if [ ! -d "$irep_output" ] ; then
        mkdir $irep_output
fi

bins_count=$(ls -la $binfolder/bins.*.fa | wc -l)

new_bins_count=$(($bins_count-1))



for i in $(seq $new_bins_count); do



        outputfile_irep=$irep_output/irep_output_bins.$i

        inputfile_irep=$binfolder/bins.$i.fa



        echo $outputfile

        iRep -f $inputfile_irep -s $sam_file -o $outputfile_irep

done



for i in $(seq $bins_count); do
	outputfile=$kraken_output/bins.$i.kraken
	reportfile=$kraken_output/bins.$i.report
	inputfile=$bins/bins.$i.fa

	#echo $outputfile
	#echo $reportfile
	#echo $inputfile
	kraken2 --db $KRAKEN_DATABASE --use-names --threads $thread --output $outputfile --report $reportfile $inputfile
done

#iRep -f $bin_not_virus -s $sam_file -o $irep_output
#add irep here with loop of bins folder, and add kraken2 from IMP.
#then we need py for final csv table.

#replication rate purification
 


python $DIR/python_scripts/purify_replication_rate.py irep -i $irep_output

source deactivate
