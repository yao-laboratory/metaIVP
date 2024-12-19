import sys
import csv
from Bio import SeqIO

def read_seq_ids(csv_file):
    """Read sequence IDs from a CSV file and return as a set."""
    seq_ids = set()
    with open(csv_file, mode='r') as file:
        reader = csv.reader(file)
        for row in reader:
            if row:  # Ensure the row is not empty
                seq_ids.add(row[0])
    return seq_ids

def filter_fasta(input_fasta, seq_ids, output_fasta):
    """Filter sequences from input_fasta and write to output_fasta, excluding seq_ids."""
    with open(input_fasta, "r") as infile, open(output_fasta, "w") as outfile:
        seqiter = SeqIO.parse(infile, "fasta")
        filtered = (seq for seq in seqiter if seq.id not in seq_ids)
        SeqIO.write(filtered, outfile, "fasta")

def main(input_fasta, csv_file, output_fasta):
    """Main function to filter FASTA file based on sequence IDs in a CSV file."""
    seq_ids = read_seq_ids(csv_file)
    filter_fasta(input_fasta, seq_ids, output_fasta)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python filter_fasta.py <input_fasta> <csv_file> <output_fasta>")
        sys.exit(1)
    
    input_fasta = sys.argv[1]
    csv_file = sys.argv[2]
    output_fasta = sys.argv[3]
    
    main(input_fasta, csv_file, output_fasta)

