#!/bin/bash
#SBATCH --job-name=mvp_SRR12952107
#SBATCH --nodes=1
#SBATCH --time=100:00:00
#SBATCH --mem=164gb
#SBATCH --ntasks-per-node=8
#SBATCH --output=mvp_SRR12952107.%J.out
#SBATCH --error=mvp_SRR12952107.%J.err
#SBATCH --partition=yaolab,batch,guest
#SAJ:stand_alone_job_assembly



#declare variables
metadata=/work/yaolab/shared/2023_Riverton/IMG_samples_JULY_2025/MVP_jobs/metadata_sample_SRR12952107_IMG.txt
WORKING_DIRECTORY=/work/yaolab/shared/2023_Riverton/IMG_samples_JULY_2025/sample_SRR12952107/MVP_output

MVP_ENV=/lustre/work/yaolab/ksahu2/my_mvp

#source activate mvip
source activate $MVP_ENV

#echo all help commands into a txt file

#mvip -h  >> help.txt
#mvip MVP_00_set_up_MVP -h  >> help.txt
#mvip MVP_01_run_genomad_checkv -h  >> help.txt
#mvip MVP_02_filter_genomad_checkv -h >> help.txt
#mvip MVP_03_do_clustering -h >> help.txt
#mvip MVP_04_do_read_mapping -h >> help.txt
#mvip MVP_05_create_vOTU_table -h >> help.txt
#mvip MVP_06_do_functional_annotation -h >> help.txt
#mvip MVP_07_do_binning -h >> help.txt
#mvip MVP_100_summarize_outputs -h >> help.txt



#Executing Module 00 (MVP Setup)

echo "mvip MVP_00_set_up_MVP -i $WORKING_DIRECTORY -m $metadata"
mvip MVP_00_set_up_MVP -i $WORKING_DIRECTORY -m $metadata


#Executing Module 01 (Running geNomad and CheckV)

echo "mvip MVP_01_run_genomad_checkv -i $WORKING_DIRECTORY -m $metadata"
mvip MVP_01_run_genomad_checkv -i $WORKING_DIRECTORY -m $metadata


#Executing Module 02 (Filtering viral prediction)

echo "mvip MVP_02_filter_genomad_checkv -i $WORKING_DIRECTORY -m $metadata"
mvip MVP_02_filter_genomad_checkv -i $WORKING_DIRECTORY -m $metadata

#Executing Module 03 (Clustering)

echo "mvip MVP_03_do_clustering -i $WORKING_DIRECTORY -m $metadata"
mvip MVP_03_do_clustering -i $WORKING_DIRECTORY -m $metadata

#Executing Module 04 (Read mapping)

echo "mvip MVP_04_do_read_mapping -i $WORKING_DIRECTORY -m $metadata"
mvip MVP_04_do_read_mapping -i $WORKING_DIRECTORY -m $metadata

#Executing Module 05 (Creating vOTU tables)

echo "mvip MVP_05_create_vOTU_table -i $WORKING_DIRECTORY -m $metadata"
mvip MVP_05_create_vOTU_table -i $WORKING_DIRECTORY -m $metadata

#Executing Module 06 (Functional prediction)

echo "mvip MVP_06_do_functional_annotation -i $WORKING_DIRECTORY -m $metadata"
mvip MVP_06_do_functional_annotation -i $WORKING_DIRECTORY -m $metadata

#Executing Module 07 (Binning viral genomes)

echo "mvip MVP_07_do_binning -i $WORKING_DIRECTORY -m $metadata"
mvip MVP_07_do_binning -i $WORKING_DIRECTORY -m $metadata



#extra


#Executing Module 99 (Prepare NCBI MIUViG submission)

echo "mvip MVP_99_prep_MIUViG_submission -i $WORKING_DIRECTORY -m $metadata"
mvip MVP_99_prep_MIUViG_submission -i $WORKING_DIRECTORY -m $metadata

#Executing Module 100 (Summarize outputs)

echo "mvip MVP_100_summarize_outputs -i $WORKING_DIRECTORY -m $metadata"
mvip MVP_100_summarize_outputs -i $WORKING_DIRECTORY -m $metadata




source deactivate
#mvp is complete
echo "MVP IS NOW COMPLETE"
