contigs_v=$1
output_path=$2
t=$3

DIR="${BASH_SOURCE[0]}"
DIR="$(dirname "$DIR")"

echo "This is Purfiy Virus Contigs Script. I will perform checkV on the virus contigs.fasta provided by user"
checkv end_to_end $contigs_v $output_path -t $t

python $DIR/python_scripts/purify_contig_bins.py contigs_determine -i $contigs_v  -q $output_path/quality_summary.tsv -o $output_path
