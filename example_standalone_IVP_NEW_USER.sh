#!/bin/bash
#SBATCH --job-name=Riverton_V
#SBATCH --nodes=1
#SBATCH --time=72:00:00
#SBATCH --mem=500gb
#SBATCH --ntasks-per-node=8
#SBATCH --output=Riverton_V_m.%J.out
#SBATCH --error=Riverton_V_m.%J.err
#SBATCH --partition=yaolab


#Example HCC METAIVP script

#metaIVP path: Repository downloaded by user from Github

#PATHS and ENVS
metaIVP_path=$metaIVP_path
export metaIVP_path
#USER_ENV=/lustre/work/yaolab/shared/2023_06_metaIVP/IVP_ENV
#export USER_ENV=/lustre/work/yaolab/shared/2023_06_metaIVP/IVP_ENV
export USER_ENV=$IVP_ENV
#metaivp_checkv
export CHECKVDB=/work/yaolab/shared/2023_06_metaIVP/checkv-db-v0.6
export genomad_env=$Genomad_env
#we should do genomad db export as well, as we export checkv db.


#USER INPUT

#viral paired-end forward read
fastq1_v=$path/to/SRR23196529_1.fastq
#viral paired-end reverse read
fastq2_v=$path/to/SRR23196529_2.fastq
#viral contigs
contigs_v=$path/to/contigs.fasta
#contig_bin_relation=
table3_v=$path/to/Table_3_assembly_complete_protein.csv


##############################################################
#USER DOES NOT NEED TO CHANGE ANYTHING FROM HERE
##############################################################


#FIXED INPUT

contigs_m=$contigs_v
fastq1_m=$fastq1_v
fastq2_m=$fastq2_v
quality_summary=path/to/any/csv/file
bins_folder=path/to/any/bins/folder
bins_folder_m=bins_folder

##############################################################
##############################################################


source activate $USER_ENV
echo "$metaIVP_path/main.sh $contigs_m $contigs_v $table3_m $table3_v $output_path $bins_folder $t $quality_summary $genomad_db $fastq1_m $fastq2_m $fastq1_v $fastq2_v"
$metaIVP_path/main.sh $contigs_m $contigs_v $table3_m $table3_v $output_path $bins_folder $t $quality_summary $genomad_db $fastq1_m $fastq2_m $fastq1_v $fastq2_v

source deactivate

