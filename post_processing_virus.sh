checkm_bins_folder=$1
t=$2 
output_folder=$3
virus_output=$output_folder/virus
log_folder=$4
echo "#################"
echo "#################"
echo "#################"
echo "#################"
echo "#################"
echo "START VIRUS POST PROCESSING"


if [ ! -d "$virus_output" ] ; then

        mkdir $virus_output

fi


##@@@@ THIS PART NEEDS TO BE UPDATED WITH THE RIGHT PATH####

virus_file=$output_folder/bins_virus.fasta

final_checkv_for_virus=$virus_output/checkv/

if [ ! -f "$final_checkv_for_virus" ]; then
        mkdir $final_checkv_for_virus
fi




log_post_processing_virus_checkv=$log_folder/post_processing_virus_checkv.log
if [ -f "$log_purify_contigs_checkv" ] ; then
	echo "$log_purify_contigs_checkv exists. Skip preprocessing..."
else
	echo "Starting post processing virus CHECKV $(date)"
	echo "checkv end_to_end $virus_file $final_checkv_for_virus -t $t"
	checkv end_to_end $virus_file $final_checkv_for_virus -t $t
	touch $log_post_processing_virus_checkv
	#July changes to paths + commands added 7/9

fi


echo "$checkm_bins_folder"
echo "$output_folder"

#Constants

#for Genomad and IPHOP : Viruses
checkv_bin_virus_fasta=$output_folder/bins_virus.fasta

#for iREP and CheckM : Bacteria

bins_not_virus_part1=$output_folder/bins_not_virus_part1.fasta
bins_not_virus_part2=$output_folder/bins_not_virus_part2.fasta
bins_not_virus=$output_folder/bins_not_virus.fasta

#combine part 1 and part 2 for final all not viral file
cat $bins_not_virus_part1 $bins_not_virus_part2 > $bins_not_virus
#move combine part to purify_bins.sh

#constant defination ends

#Viral analysis:
#databases
#this is hardcoded
#subject to change


genomad_db=/work/yaolab/shared/2023_Riverton/genomad_testing/genomad/genomad_db/
#db_path=/work/yaolab/ksahu2/iphop_db/Sept_2021_pub_rw/
#db_path=/work/yaolab/shared/2023_Riverton/iphop_testing/iphop/Aug_2023_pub_rw/
db_path=/work/yaolab/shared/2023_Riverton/iphop_testing/iphop/another_download/Aug_2023_pub_rw/


#iphop
#source activate /work/yaolab/shared/2023_06_metaIVP
source activate $IPHOP_ENV

iphop_output=$virus_output/iphop
if [ ! -d "$iphop_output" ] ; then
        mkdir $iphop_output

fi


#start iphop
#echo "iphop predict --fa_file $checkv_bin_virus_fasta  -t $t --db_dir $db_path --out_dir $iphop_output"
#echo "starting iphop $(date)..."
#iphop predict --fa_file $checkv_bin_virus_fasta  -t $t --db_dir $db_path --out_dir $iphop_output
#echo "ending iphop $(date)..."


log_post_processing_virus_iphop=$log_folder/post_processing_virus_iphop.log

if [ -f "$log_post_processing_virus_iphop" ] ; then

        echo "$log_post_processing_virus_iphop exists. Skip preprocessing..."

else
	
        echo "Starting post processing virus IPHOP $(date)"
        echo "iphop predict --fa_file $checkv_bin_virus_fasta  -t $t --db_dir $db_path --out_dir $iphop_output"
	iphop predict --fa_file $checkv_bin_virus_fasta  -t $t --db_dir $db_path --out_dir $iphop_output
	echo "ending iphop $(date)..."
	touch $log_post_processing_virus_iphop

        #July changes to paths + commands added 7/9



fi
source deactivate 

#genomad
source activate $GENOMAD_ENV
#genomad_output=$output_f1older/checkv_bin_virus_genomad/
genomad_output=$virus_output/genomad/
#echo "starting genomad $(date)..."
#genomad end-to-end --cleanup --splits $t $checkv_bin_virus_fasta $genomad_output $genomad_db
#echo "starting genomad @ $(date)..."

log_post_processing_virus_genomad=$log_folder/post_processing_virus_genomad.log
if [ -f "$log_post_processing_virus_genomad" ] ; then
        echo "$log_post_processing_virus_genomad exists. Skip preprocessing..."

else
	echo "starting post processing virus genomad $(date)..."
	echo "genomad end-to-end --cleanup --splits $t $checkv_bin_virus_fasta $genomad_output $genomad_db"
	genomad end-to-end --cleanup --splits $t $checkv_bin_virus_fasta $genomad_output $genomad_db
	echo "ending genomad @ $(date)..."
	touch $log_post_processing_virus_genomad
fi

source deactivate

echo "#################"
echo "#################"
echo "#################"
echo "#################"
echo "#################"
echo "END VIRUS POST PROCESSING"
