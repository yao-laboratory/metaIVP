#!/bin/bash
#SBATCH --job-name=ivp_new_env
#SBATCH --nodes=1
#SBATCH --time=72:00:00
#SBATCH --mem=500gb
#SBATCH --ntasks-per-node=8
#SBATCH --output=ivp_with_new_env.%J.out
#SBATCH --error=ivp_with_new_env.%J.err
#SBATCH --partition=yaolab,batch


#Example HCC METAIVP script

#metaIVP path: Repository downloaded by user from Github

metaIVP_path=/work/yaolab/shared/2023_06_metaIVP/scripts
USER_ENV=metaivp_checkv
export CHECKVDB=/work/yaolab/shared/2023_06_metaIVP/checkv-db-v0.6


echo "source activate $USER_ENV"
echo "this python is \n" 

##USER INPUTS###
contigs_m=/work/yaolab/shared/2023_Nebraska_Lake/NSL_Bean_2018/MG/sample_52634/assembly_output/METASPADES/contigs.fasta
contigs_v=/work/yaolab/shared/2023_Nebraska_Lake/NSL_Bean_2018/V/sample_52632/assembly_output/METASPADES/contigs.fasta
table3_m=/work/yaolab/shared/2023_Nebraska_Lake/NSL_Bean_2018/MG/sample_52634/assembly_output/ASSEMBLY_SNP_ANNOTATION/Table_3_assembly_complete_protein_modified.csv
table3_v=/work/yaolab/shared/2023_Nebraska_Lake/NSL_Bean_2018/V/sample_52632/assembly_output/ASSEMBLY_SNP_ANNOTATION/Table_3_assembly_complete_protein.csv
output_path=$PWD/christmas_night_testing_with_env_checkv
bins_folder=/work/yaolab/shared/2023_Nebraska_Lake/NSL_Bean_2018/V/sample_52632/assembly_output/BINS/
t=8
quality_summary=/work/yaolab/shared/2023_Nebraska_Lake/NSL_Bean_2018/V/output_directory/quality_summary.tsv

#ml checkv

source activate $USER_ENV
export USER_ENV
echo "$metaIVP_path/main.sh $contigs_m $contigs_v $table3_m $table3_v $output_path $bins_folder $t $quality_summary"
$metaIVP_path/main.sh $contigs_m $contigs_v $table3_m $table3_v $output_path $bins_folder $t $quality_summary

source deactivate
