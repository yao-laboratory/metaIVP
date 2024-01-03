import os
import argparse
import pandas as pd
import Bio
from Bio import SeqIO
from Bio.SeqIO import parse

def determine_contigs(contigs_fasta_file,quality_summary,output_directory):
    
    
    #read input files
    summary_file=pd.read_csv(quality_summary,sep="\t")
    
    #filter quality_summary file into two pieces: Not determined IDs, Determined IDs
    low_medium_high_df = summary_file[(summary_file['checkv_quality'] != 'Not-determined')]
    not_determined_df = summary_file[(summary_file['checkv_quality'] == 'Not-determined')]

    contig_ids = []
    contig_lengths = []
    sequences = []
    
    for record in SeqIO.parse(contigs_fasta_file, "fasta"):
        contig_ids.append(record.id)
        contig_lengths.append(len(record.seq))
        sequences.append(str(record.seq))

    contig_fasta_df = pd.DataFrame({'contig_id': contig_ids, 'len': contig_lengths, 'seq': sequences})
    #add checkv_quality column to contig_fasta_df                            
    contig_fasta_df = pd.merge(contig_fasta_df, summary_file[['contig_id', 'checkv_quality']], on='contig_id', how='left')
    
    #contig_fasta_df.head(5)
    #contig_fasta_df = pd.DataFrame({'contig_id': contig_ids, 'len': contig_lengths, 'seq': sequences})
    #add checkv_quality column to contig_fasta_df                            
    contig_fasta_summary_file_determined = pd.merge(contig_fasta_df, low_medium_high_df[['contig_id', 'checkv_quality']], on='contig_id', how='inner')
    contig_fasta_summary_file_not_determined = pd.merge(contig_fasta_df, not_determined_df[['contig_id', 'checkv_quality']], on='contig_id', how='inner')
    
    print("not determined file head is")
    print(contig_fasta_summary_file_not_determined.head(5))

    print("determined file head is")
    print(contig_fasta_summary_file_determined.head(5))

    not_determined_csv_file=os.path.join(output_directory,"contigs_not_determined.csv")
    determined_csv_file=os.path.join(output_directory,"contigs_determined.csv")

    contig_fasta_summary_file_not_determined.to_csv(not_determined_csv_file,index=None,header=True,sep=",")
    contig_fasta_summary_file_determined.to_csv(determined_csv_file,index=None,header=True,sep=",")
    

        
def determine_bins(bins_scaffold_file,bin_fasta,bin_quality_checkv_summary,contig_fasta_summary_file_determined,output_directory):

    print(bins_scaffold_file,bin_fasta,bin_quality_checkv_summary,contig_fasta_summary_file_determined,output_directory)
    #read inputs
    bins_scaffold=pd.read_csv(bins_scaffold_file,sep='\t',header=None)
    bin_summary_file=pd.read_csv(bin_quality_checkv_summary,sep="\t")
    bin_summary_file=bin_summary_file.rename(columns={0:"bin_id"})
    #bin_summary_file=bin_summary_file.rename(columns={0:"contig_id"})
    
    bin_low_medium_high_df = bin_summary_file[(bin_summary_file['checkv_quality'] != 'Not-determined')]
    bin_not_determined_df = bin_summary_file[(bin_summary_file['checkv_quality'] == 'Not-determined')]
    bin_low_medium_high_df=bin_low_medium_high_df.rename(columns={"contig_id":"bin_id"})
    bin_not_determined_df=bin_not_determined_df.rename(columns={"contig_id":"bin_id"})
   
    #rename bins_scaffold_file
    bins_scaffold=bins_scaffold.rename(columns={0:"contig_id",1:"bin_id"})
    print("bins_scaffold is")
    print(bins_scaffold.head(5))
    contig_fasta_summary_file_determined = pd.read_csv(contig_fasta_summary_file_determined,sep=',',header=0)
    
    contig_ids = []
    contig_lengths = []
    sequences = []
    
    for record in SeqIO.parse(bin_fasta, "fasta"):
        contig_ids.append(record.id)
        contig_lengths.append(len(record.seq))
        sequences.append(str(record.seq))
        
        
    bin_fasta_df = pd.DataFrame({'bin_id': contig_ids, 'len': contig_lengths, 'seq': sequences})
    
    print("bin_fasta_df is")
    print(bin_fasta_df.head(5))
    print("bin_low_medium_high_df is",bin_low_medium_high_df.head(5))
    print("bin_not_determined_df",bin_not_determined_df.head(5))
    bin_fasta_summary_file_determined = pd.merge(bin_fasta_df, bin_low_medium_high_df[['bin_id', 'checkv_quality']], on='bin_id', how='inner')
    bin_fasta_summary_file_not_determined = pd.merge(bin_fasta_df, bin_not_determined_df[['bin_id', 'checkv_quality']], on='bin_id', how='inner')
    


    print("bin_fasta_summary_file_determined is")
    print(bin_fasta_summary_file_determined.head(5))

    print("bin_fasta_summary_file_not_determineds is")
    print(bin_fasta_summary_file_not_determined.head(5))
 
    not_determined_bin_fasta_file=os.path.join(output_directory,"bins_not_virus.fasta")
    with open(not_determined_bin_fasta_file, 'w') as fasta_out:
        for index, row in bin_fasta_summary_file_not_determined.iterrows():
            fasta_out.write(f">{row['bin_id']}\n{row['seq']}\n")

    bin_fasta_summary_file_determined=bin_fasta_summary_file_determined['bin_id']
    bins_scaffold=pd.merge(bins_scaffold,bin_fasta_summary_file_determined, on='bin_id', how='inner')
    
    bins_scaffold=pd.merge(bins_scaffold,contig_fasta_summary_file_determined, on='contig_id', how='inner')
    
    bins_scaffold[['contig_id','bin_id']].to_csv(os.path.join(output_directory,"viral_bin_scaffold.csv"),sep=',',header=True, index=None)
    
    unique_bin_id=bins_scaffold['bin_id'].unique()
    
    cleaned_bin_fasta_filename=os.path.join(output_directory,"bins_virus.fasta")
    cleaned_bin_fasta_file = open(cleaned_bin_fasta_filename, 'w')
    for bin_id in unique_bin_id:
        current_bins_scaffold=bins_scaffold[bins_scaffold['bin_id']==bin_id]
        cleaned_bin_fasta_file.write(">"+bin_id+"\n")
        for seq in current_bins_scaffold['seq'].tolist():
            cleaned_bin_fasta_file.write(str(seq))
        cleaned_bin_fasta_file.write("\n")
    cleaned_bin_fasta_file.close()
            
def main():
    
    parser = argparse.ArgumentParser(prog='Virus_Bin_Contig_Purification',description='This method cleans virus bins and contigs fasta file')
    subparser = parser.add_subparsers(dest='subcommand',help ='Following files are the input:1)Input contigs 2) Bin Scaffold file 3) Quality Summary 4) Output path')

    
        #Add determin_contigs parser and subparser    
    determine_contig_parser=subparser.add_parser("contigs_determine",help="This function determines confident contigs ")
    determine_contig_parser.add_argument("-i", dest="Input_contigs", type=str, help="Contig file eg./path/to/contig.fasta as input")
    determine_contig_parser.add_argument("-q", dest="Quality_summary_file", type=str, help="vcf file eg. /path/to/quality_summary.csv as input")
    determine_contig_parser.add_argument("-o", dest="Output_file_path", type=str, help="output file path")

    
        #Add determin_bins parser and subparser
    determine_bin_parser=subparser.add_parser("bin_determine",help="This function determines confident bins")
    determine_bin_parser.add_argument("-i", dest="Input_bins", type=str, help="Dataframe file eg./path/to/input_bins.fasta as input")
    determine_bin_parser.add_argument("-b", dest="Bin_scaffold_file", type=str, help="vcf file eg. /path/to/bin_scaffold_file.tsv as input")
    determine_bin_parser.add_argument("-q", dest="Bin_quality_summary_file", type=str, help="path/to/bin_quality_summary_file.tsv")
    determine_bin_parser.add_argument("-d", dest="Contig_fasta_summary_file_determined", type=str, help="/path/to/contig_fasta_summary_file_determined.csv")
    determine_bin_parser.add_argument("-o", dest="Output_file_path", type=str, help="/path/to/output file path")
    args = parser.parse_args()
    
        #Two subparsers: 1) Determine Contigs 2) Determine Bins
        
    if args.subcommand=='contigs_determine':
        input_contig_fasta = args.Input_contigs
        quality_summary = args.Quality_summary_file
        output_directory = args.Output_file_path
        print(input_contig_fasta,quality_summary,output_directory)
        determine_contigs(input_contig_fasta,quality_summary,output_directory)
    
    else:
        if args.subcommand=='bin_determine':
            input_bin_fasta = args.Input_bins
            bins_scaffold_file = args.Bin_scaffold_file
            bin_quality_checkv_summary=args.Bin_quality_summary_file
            contig_fasta_summary_file_determined=args.Contig_fasta_summary_file_determined
            output_directory = args.Output_file_path
            print(input_bin_fasta,bins_scaffold_file,bin_quality_checkv_summary,contig_fasta_summary_file_determined,output_directory)
            determine_bins(bins_scaffold_file,input_bin_fasta,bin_quality_checkv_summary,contig_fasta_summary_file_determined,output_directory)
        else:
            print("Wrong input. Check parameters")                        

if __name__ == "__main__":
    main() 
    
