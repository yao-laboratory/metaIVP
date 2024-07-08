checkm_bins_folder=$1
t=$2 
output_folder=$3


##@@@@ THIS PART NEEDS TO BE UPDATED WITH THE RIGHT PATH####
#virus_file=$output_path/bins_virus.fasta
#final_checkv_for_virus=$output_path/virus_checkv
#if [ ! -f "$final_checkv_for_virus" ]; then
#
#        mkdir $final_checkv_for_virus
#
#fi
#checkv end_to_end $virus_file $final_checkv_for_virus -t $t
####REMEMBER TO FIX THIS####



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
source activate iphop_env
echo "iphop predict --fa_file $checkv_bin_virus_fasta  -t $t --db_dir $db_path --out_dir $output_folder"

iphop predict --fa_file $checkv_bin_virus_fasta  -t $t --db_dir $db_path --out_dir $output_folder

#echo "iphop predict --fa_file $checkv_bin_virus_fasta  -t $t --db_dir $db_path --out_dir $output_folder"
source deactivate 
#/work/yaolab/shared/2023_06_metaIVP
#iphop_env


#genomad
#source activate genomad
genomad_output=$output_folder/checkv_bin_virus_genomad/
genomad end-to-end --cleanup --splits $t $checkv_bin_virus_fasta $genomad_output $genomad_db
source deactivate
