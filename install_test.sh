#This script will test the install.sh script for metaIVP
#We test all the help commands for the dependencies 
#We output the command result into a text file



1) Main environment (ivp_env)

conda activate ivp_env

```
metabat2 -h
checkv -h
irep -h
bowtie2 --help
samtools --help
python -c "import skbio; print('scikit-bio OK')"
python -c "import Bio; print('biopython OK')"
kraken2 --help
```

conda deactivate



2) iPHoP environment (iphop_env)

```
conda activate iphop_env

iphop -h

conda deactivate

```

3) geNomad environment (genomad)

```
conda activate genomad

genomad -h

conda deactivate
```

4) CheckM2 environment (checkm2)

```
conda activate checkm2

checkm2 -h

conda deactivate

```

One line santiy check:
```
conda activate ivp_env && metabat2 -h && checkv -h && irep -h && bowtie2 --help && samtools --help && kraken2 --help && conda deactivate
```

