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

metaIVP_path=$PWD
export metaIVP_path
#USER_ENV=/lustre/work/yaolab/shared/2023_06_metaIVP/IVP_ENV
#export USER_ENV=/lustre/work/yaolab/shared/2023_06_metaIVP/IVP_ENV
export USER_ENV=ivp_env_1
#metaivp_checkv
export CHECKVDB=/work/yaolab/shared/2023_06_metaIVP/checkv-db-v0.6
export genomad_env=genomad
#we should do genomad db export as well, as we export checkv db.

echo "source activate $USER_ENV"
echo "this python is \n"
which python

##USER INPUTS#
contigs_m=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/METASPADES/contigs.fasta
contigs_v=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_V/assembly_output/METASPADES/contigs.fasta
#contigs_v=/work/yaolab/shared/2023_Riverton/Riverton_virome/virus_3A/assembly_output/METASPADES/contigs.fasta
#table3_m=/work/yaolab/shared/2023_Riverton/Riverton_virome/virus_3A/assembly_output/ASSEMBLY_SNP_ANNOTATION/Table_3_assembly_complete_protein_modified.csv
table3_m=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/ASSEMBLY_SNP_ANNOTATION/Table_3_assembly_complete_protein.csv
table3_v=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_V/assembly_output/ASSEMBLY_SNP_ANNOTATION/Table_3_assembly_complete_protein.csv
output_path=$PWD/July_INTERACTIVE_NODE
#riverton_virus_3At0_new_virus_post_processing_latest_custom_env_interactive_node_May
#bins_folder=/work/yaolab/shared/2023_Riverton/Riverton_virome/virus_3A/assembly_output/BINS/
bins_folder=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_V/assembly_output/BINS
bins_folder_m=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/BINS/
t=8
quality_summary=/work/yaolab/shared/2023_06_metaIVP/scripts/ivp/output_directory/quality_summary.tsv #this checkv is run on Riverton 3A contigs data, output was generated in the Bean Lake folder
genomad_db=/work/yaolab/shared/2023_Riverton/genomad_testing/genomad/genomad_db/
#ml checkv


fastq1_m=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/R-t0-3A_S0_L001_R1_001.fastq.gz.filtered_1.fastq
fastq2_m=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/R-t0-3A_S0_L001_R2_001.fastq.gz.filtered_2.fastq

fastq1_v=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_V/assembly_output/RV-t0-3A_S0_L001_R1_001.fastq.gz.filtered_1.fastq
fastq2_v=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_V/assembly_output/RV-t0-3A_S0_L001_R2_001.fastq.gz.filtered_2.fastq
#fastq1_v=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/R-t0-3A_S0_L001_R1_001.fastq.gz.filtered_1.fastq
#fastq2_v=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/R-t0-3A_S0_L001_R2_001.fastq.gz.filtered_2.fastq

#add V fastq as well for input and pass to main.
#remove quality summary table
#genomad specify database


source activate $USER_ENV
#export USER_ENV
#export genomad_env
echo "$metaIVP_path/main.sh $contigs_m $contigs_v $table3_m $table3_v $output_path $bins_folder $t $quality_summary $genomad_db $fastq1_m $fastq2_m $fastq1_v $fastq2_v"
$metaIVP_path/main.sh $contigs_m $contigs_v $table3_m $table3_v $output_path $bins_folder $t $quality_summary $genomad_db $fastq1_m $fastq2_m $fastq1_v $fastq2_v

source deactivate
