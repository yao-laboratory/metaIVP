#!/bin/bash
#SBATCH --job-name=pydeseq2_install
#SBATCH --nodes=1
#SBATCH --time=6:00:00
#SBATCH --mem=50gb
#SBATCH --ntasks-per-node=8
#SBATCH --output=install_pydeseq2.%J.out
#SBATCH --error=install_pydeseq2.%J.err
#PCA_PYDeseq2

mamba create --name pydeseq2_env

source activate pydeseq2

mamba install -y -c bioconda pydeseq2

source deactivate

