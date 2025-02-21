IVP_contigs_fasta=$1

t=$2
output_folder=$3
log_folder=$4
IVP_contigs_csv=$5
IMP_coverage_original=$6
#metaIMP_folder=$6
virus_binning_output=$output_folder/virus_binning
vrhyme_output=$virus_binning_output/vrhyme_output
#modified coverage file, this will be generated in the reformat_bin python code
IMP_coverage=$output_folder/Modified_Coverage.tsv

echo "#################"
echo "#################"
echo "#################"
echo "#################"
echo "#################"

echo "START VIRUS BINNING POST PROCESSING"
if [ ! -d "$virus_binning_output" ] ; then
	mkdir $virus_binning_output
fi


source activate $vrhyme_env
#run vrhyme



echo "python $metaIVP_path/python_scripts/utility/filter_bin_from_vrhyme.py reformat_bin -i $IMP_coverage_original -o $output_folder"
python $metaIVP_path/python_scripts/filter_bin_from_vrhyme.py reformat_bin -i $IMP_coverage_original -o $output_folder



log_post_processing_virus_binning_vrhyme=$log_folder/post_processing_virus_binning_vrhyme.log
if [ -f "$log_post_processing_virus_binning_vrhyme" ] ; then
        echo "$log_post_processing_virus_binning_vrhyme exists. Skip preprocessing..."
else
        echo "Starting post processing virus binning with  VRHYME $(date)"
        echo "vRhyme -i $IVP_contigs_fasta -c $IMP_coverage -o $vrhyme_output --cov 0.01"
#delete vrhyme if exist and no log
	if [ -d  "$vrhyme_output" ] ; then
		rm -R  $vrhyme_output
	fi
	vRhyme -i $IVP_contigs_fasta -c $IMP_coverage -o $vrhyme_output --cov 0.01
        touch $log_post_processing_virus_binning_vrhyme

fi


membership_file=$(find "$vrhyme_output" -type f -name "*.membership.tsv" | head -n 1)

# Check if membership_file was found file was found
if [[ -z "$membership_file" ]]; then
    echo "No .membership.tsv file found in $vrhyme_output"
    exit 1
fi

#create new bin.fa from vrhyme bins

echo "python $metaIVP_path/python_scripts/utility/filter_bin_from_vrhyme.py v_bin -c $IVP_contigs_csv -m $membership_file -o $output_folder"
python $metaIVP_path/python_scripts/filter_bin_from_vrhyme.py v_bin -c $IVP_contigs_csv -m $membership_file -o $output_folder


bins_determined_from_IVP_VRhyme=$output_folder/bin_determined.fasta
final_checkv_for_virus_IVP_VRhyme=$output_folder/checkv_with_VRhyme/

#if [ ! -f "$final_checkv_for_virus_IVP_VRhyme" ]; then
#        mkdir $final_checkv_for_virus_IVP_VRhyme
#fi




log_post_processing_virus_checkv_with_vrhyme=$log_folder/post_processing_virus_checkv_with_vrhyme.log

if [ -f "$log_post_processing_virus_checkv_with_vrhyme" ] ; then
        echo "$log_post_processing_virus_checkv_with_vrhyme exists. Skip preprocessing..."

else
        source activate $USER_ENV
	echo "Starting post processing virus CHECKV $(date)"
 #       echo "checkv end_to_end $virus_file $final_checkv_for_virus -t $t"
  	echo "checkv end_to_end $bins_determined_from_IVP_VRhyme $final_checkv_for_virus_IVP_VRhyme --restart -t $t"
	checkv end_to_end $bins_determined_from_IVP_VRhyme $final_checkv_for_virus_IVP_VRhyme --restart -t $t
        touch $log_post_processing_virus_checkv_with_vrhyme

fi

source deactivate
