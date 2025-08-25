#!/bin/bash

cd $WORK
conda create --prefix ./my_mvp
source activate /lustre/work/yaolab/ksahu2/my_mvp
CONDA_NO_PLUGINS=true mamba install --override-channels -c bioconda -c conda-forge mvip

#Then you can do:
mvip -h
#help command


