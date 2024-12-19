#!/bin/bash
#SBATCH --job-name=Riverton_V_install
#SBATCH --nodes=1
#SBATCH --time=12:00:00
#SBATCH --mem=20gb
#SBATCH --ntasks-per-node=8
#SBATCH --output=Riverton_V_install.%J.out
#SBATCH --error=Riverton_V_install.%J.err
#SBATCH --partition=yaolab,batch,guest

#conda create -c conda-forge -n ivp_env python=3.8 mamba
conda create -n ivp_ev python=3.8
source activate ivp_env
#amba install -y -c bioconda metabat2
#mamba install -y -c conda-forge -c bioconda iphop
#mamba install -y -c bioconda -c conda-forge checkm2
mamba install -y -c bioconda metabat2
#mamba install -y -c conda-forge -c bioconda iphop
mamba install -y -c conda-forge -c bioconda checkv
#mamba install -y-c conda-forge -c bioconda genomad
mamba install -y irep
mamba install -y -c bioconda bowtie2
#mamba install -y -c bioconda metabat2
mamba install -y -c bioconda samtools=1.14
mamba install -y -c anaconda scikit-bio
mamba install -y -c conda-forge biopython=1.76
mamba install -y -c bioconda kraken2


echo "all install complete"
echo "here is a sample test help command"

#iphop -h
source deactivate

#additional envs

#iphop
mamba create -c conda-forge -n iphop_env python=3.8 mamba
mamba activate iphop_env
mamba install -c conda-forge -c bioconda iphop


#test iphop

#genomad
# Create an environment for geNomad
mamba create -n genomad -c conda-forge -c bioconda genomad


#checkm2
#mamba create -n checkm2 -c bioconda -c conda-forge checkm2
#this is the best one
mamba install -y bioconda::checkm2=1.0.1

source activate iphop_env
iphop -h
source deactivate 


source activate checkm2
checkm2 -h
source deactivate


source activate genomad
genomad -h
source deactivate


