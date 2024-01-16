#!/bin/bash
#SBATCH --job-name=pca_pydeseq2
#SBATCH --nodes=1
#SBATCH --time=6:00:00
#SBATCH --mem=50gb
#SBATCH --ntasks-per-node=8
#SBATCH --output=pca_pydeseq2.%J.out
#SBATCH --error=pca_pydeseq2.%J.err
#PCA_PYDeseq2

source activate pydeseq2
path=/work/yaolab/shared/2023_Riverton/pca_pydeseq2/

metadata=/work/yaolab/shared/2023_Riverton/pca_pydeseq2/metadata_copanhagen.csv
final_ec_table_testing=/work/yaolab/shared/2023_Riverton/pca_pydeseq2/final_ec_coverage_copanhagen.csv
t=2

echo "python $path/pca_pydeseq2.py PCA -i $final_ec_table_testing -m $metadata -o $path"
python $path/pca_pydeseq2.py PCA -i $final_ec_table_testing -m $metadata -o $path

echo "python $path/pca_pydeseq2_updated.py pydeseq2 -i $final_ec_table_testing -m $metadata -o $path -t $t"
python $path/pca_pydeseq2_updated.py pydeseq2 -i $final_ec_table_testing -m $metadata -o $path -t $t

#csv=$path/MG-Tx_table_Abs.csv
#metadata=$path/MG-Tx_metadata_Abs.csv
#python $path/pca_pydeseq2_updated.py pydeseq2 -i $csv -m $metadata -o $path -t 2


source deactivate
