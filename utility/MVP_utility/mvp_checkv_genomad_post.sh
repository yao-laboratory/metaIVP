#!/bin/bash
#SBATCH --job-name=SRR12953260
#SBATCH --nodes=1
#SBATCH --time=48:00:00
#SBATCH --mem=100gb
#SBATCH --ntasks-per-node=4
#SBATCH --output=SRR12953260.%J.out
#SBATCH --error=SRR129533260.%J.err
#SBATCH --partition=yaolab


contigs=/work/yaolab/shared/2023_Riverton/mvp/SRR12953260/07_BINNING/07B_vBINS_CHECKV/All_Genome_Fasta_vBins_CheckV_Input.fasta
checkv_on_contigs=/work/yaolab/shared/2023_Riverton/mvp/SRR12953260/checkv_results
t=8


source activate ivp_env
CHECKVDB=/work/yaolab/shared/2023_06_metaIVP/checkv-db-v0.6
echo "starting checkv $(date)..."
checkv end_to_end $contigs -d $CHECKVDB $checkv_on_contigs -t $t 

echo "checkv end_to_end $contigs -d $CHECKVDB $checkv_on_contigs -t $t"
echo "ending checkv $(date)..."

source deactivate



genomad_output=/work/yaolab/shared/2023_Riverton/mvp/SRR12953260/genomad_results

source activate genomad
genomad_db=/work/yaolab/shared/2023_Riverton/genomad_testing/genomad/genomad_db/

echo "genomad end-to-end --cleanup --splits $t $contigs $genomad_output $genomad_db"
genomad end-to-end --cleanup --splits $t $contigs $genomad_output $genomad_db

source deactivate
