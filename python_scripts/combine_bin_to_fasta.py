import pandas as pd

from Bio import SeqIO

from Bio.SeqRecord import SeqRecord

from Bio.Seq import Seq

import os

import argparse
def combine_bins(bin_directory,output_directory):

    bin_sequences = {}

    # Iterate over each bins.fa file in the directory
    print("this is a test command")
    for bin_filename in os.listdir(bin_directory):

        if bin_filename.startswith('bins.') and bin_filename.endswith('.fa'):

            bin_path = os.path.join(bin_directory, bin_filename)

            bin_id = f'bins.{bin_filename.split(".")[1]}'



            # Read the sequences from the current bins.fa file

            with open(bin_path, 'r') as bin_file:

                sequences = bin_file.read().split('>')[1:]


                # Remove the contig headers from each sequenc
                cleaned_sequences = [sequence.split('\n', 1)[1] for sequence in sequences]

                combined_sequence = ''.join(cleaned_sequences).replace('\n', '')  # Combine sequences and remove line breaks

            if bin_id not in bin_sequences:

                bin_sequences[bin_id] = []

                bin_sequences[bin_id].append(combined_sequence)

    # Create a giant .fa file with combined sequences for all bins

    output_file_path = os.path.join(output_directory, 'bin.fa')

    with open(output_file_path, 'w') as output_file:

        for bin_id, sequences in bin_sequences.items():

            combined_sequence = ''.join(sequences)

            output_file.write(f'>{bin_id}\n{combined_sequence}\n')

    print(f'Giant .fa file created at {output_file_path}')


    

def main():

    parser = argparse.ArgumentParser(prog='combine_bins',description='This method combines all bins.fa in bins folder and produces a giant.bins.fa file')

    subparser = parser.add_subparsers(dest='subcommand',help ='Following files are the input:1)Input directory 2) Output path')

    

    #Add PCA parser and subparser    
    
    pca_parser=subparser.add_parser("combine_bins",help="This function combines all bins ")

    pca_parser.add_argument("-i", dest="Input_directory", type=str, help="Input directory path eg./path/to/input_dir/bins/ as input")

    pca_parser.add_argument("-o", dest="Output_file_path", type=str, help="output file path")

    

    args = parser.parse_args()

    

    if args.subcommand=='combine_bins':

        input_dir = args.Input_directory

        output_directory = args.Output_file_path

        print(input_dir,output_directory)

        combine_bins(input_dir,output_directory)

        

    else:

        print("Wrong input. Check parameters")  

        

       

if __name__== "__main__":

   main() 

    
