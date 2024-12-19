#!/bin/bash
#SBATCH --job-name=Riverton_V_3A_TF
#SBATCH --nodes=1
#SBATCH --time=48:00:00
#SBATCH --mem=80gb
#SBATCH --ntasks-per-node=8
#SBATCH --output=Riverton_V_final_3A_TF.%J.out
#SBATCH --error=Riverton_V_final_3A_Tf.%J.err
#SBATCH --partition=yaolab,batch

#Example HCC METAIVP script
#metaIVP path: Repository downloaded by user from Github

metaIVP_path=/work/yaolab/shared/2023_Riverton/2024_IVP_FOR_GIT_UPLOAD/
export metaIVP_path
#USER_ENV=/lustre/work/yaolab/shared/2023_06_metaIVP/IVP_ENV
#export USER_ENV=/lustre/work/yaolab/shared/2023_06_metaIVP/IVP_ENV
export USER_ENV=ivp_env
#metaivp_checkv
export CHECKVDB=/work/yaolab/shared/2023_06_metaIVP/checkv-db-v0.6
export GENOMAD_ENV=genomad
export IPHOP_ENV=iphop_env
export NON_VIRUS_ENV=ENV_SAMPLE
export CHECKM2=checkm2
export CHECKM2DB="/work/HCC/BCRF/app_specific/checkm2/1.0.1/CheckM2_database/uniref100.KO.1.dmnd"
#Kraken database path
KRAKEN_DATABASE=/work/HCC/BCRF/app_specific/kraken/2.0
#we should do genomad db export as well, as we export checkv db.

echo "source activate $USER_ENV"
echo "this python is \n"
which python



##USER INPUTS#
contigs_m=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/METASPADES/contigs.fasta
contigs_v=/work/yaolab/shared/2023_Riverton/2024_Riverton/Riverton_Virome/3A_tf/assembly_output_tf_input/METASPADES/contigs.fasta
table3_m=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/ASSEMBLY_SNP_ANNOTATION/Table_3_assembly_complete_protein.csv
table3_v=/work/yaolab/shared/2023_Riverton/2024_Riverton/Riverton_Virome/3A_tf/assembly_output_tf_input/ASSEMBLY_SNP_ANNOTATION/Table_3_assembly_complete_protein.csv
output_path=$PWD/Riverton_Virome_3A_Tf_Github_Test_Year_End_run_Dec18_Night_Run/
bins_folder=/work/yaolab/shared/2023_Riverton/2024_Riverton/Riverton_Virome/3A_tf/assembly_output_tf_input/BINS
bins_folder_m=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/BINS/
t=8
quality_summary=/work/yaolab/shared/2023_06_metaIVP/scripts/ivp/output_directory/quality_summary.tsv #this checkv is run on Riverton 3A contigs data, output was generated in the Bean Lake folder
genomad_db=/work/yaolab/shared/2023_Riverton/genomad_testing/genomad/genomad_db/
fastq1_m=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/R-t0-3A_S0_L001_R1_001.fastq.gz.filtered_1.fastq
fastq2_m=/work/yaolab/shared/2023_06_metaIVP/scripts/Riverton_M/assembly_output/R-t0-3A_S0_L001_R2_001.fastq.gz.filtered_2.fastq
fastq1_v=/work/yaolab/shared/2023_Riverton/2024_Riverton/Riverton_Virome/3A_tf/assembly_output_tf_input/RV-tf-3A_S0_L001_R1_001.fastq.gz.filtered_1.fastq
fastq2_v=/work/yaolab/shared/2023_Riverton/2024_Riverton/Riverton_Virome/3A_tf/assembly_output_tf_input/RV-tf-3A_S0_L001_R2_001.fastq.gz.filtered_2.fastq
#quality summary, fastq1_m and fastq2_m not used.


echo "the envs are" 
echo $USER_ENV
echo $genomad_env
echo $iphop_env
echo $metabat2_env

source activate $USER_ENV
echo "$metaIVP_path/main.sh $contigs_m $contigs_v $table3_m $table3_v $output_path $bins_folder $t $quality_summary $genomad_db $fastq1_m $fastq2_m $fastq1_v $fastq2_v"
$metaIVP_path/main.sh $contigs_m $contigs_v $table3_m $table3_v $output_path $bins_folder $t $quality_summary $genomad_db $fastq1_m $fastq2_m $fastq1_v $fastq2_v
source deactivate
