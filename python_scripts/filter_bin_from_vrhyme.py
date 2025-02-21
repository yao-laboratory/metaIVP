import pandas as pd
import os
import argparse


def create_vrhyme_bin(contigs,membership_file,output_directory):

    contigs_determined_from_IVP=pd.read_csv(contigs)
    membership_file_by_vrhyme=pd.read_csv(membership_file,sep="\t",index_col=None)
    print('contigs file is',contigs_determined_from_IVP.head(5))
    print('memebership file is',membership_file_by_vrhyme.head(5))
    columns_to_keep=["contig_id","seq"]
    contigs_determined_from_IVP=contigs_determined_from_IVP[columns_to_keep]
    print('contigs determined from IVP are',contigs_determined_from_IVP.head(5))
    membership_file_by_vrhyme=membership_file_by_vrhyme.rename(columns={"scaffold": "contig_id",})
    determined_merged_contigs_vrhyme=pd.merge(contigs_determined_from_IVP,membership_file_by_vrhyme,on='contig_id',how='inner')
    determined_merged_contigs_vrhyme=determined_merged_contigs_vrhyme.drop_duplicates()
    columns_to_keep=["seq","bin"]
    determined_merged_bins_vrhyme=determined_merged_contigs_vrhyme[columns_to_keep]
    concatenated_df = determined_merged_bins_vrhyme.groupby('bin', as_index=False).agg({'seq': ''.join})
    output_bin_fasta=os.path.join(output_directory,"bin_determined.fasta")

    # Write the DataFrame to a FASTA file

    with open(output_bin_fasta, 'w') as fasta_file:

        for _, row in concatenated_df.iterrows():
            fasta_file.write(f">{row['bin']}\n{row['seq']}\n")
    print(f"FASTA file saved to {output_bin_fasta}")


def reformat_coverage(coverage_file,output_directory):
    original_coverage_file=pd.read_csv(coverage_file,sep='\t',header=0)
    modified_coverage_file = original_coverage_file[['#ID', 'Avg_fold','Std_Dev']].rename(columns={'#ID': 'scaffold','Avg_fold':'avg_SRR1001_trim','Std_Dev':'stdev_SRR1001_trim'})
    output_file=os.path.join(output_directory,'Modified_Coverage.tsv')
    modified_coverage_file.to_csv(output_file,sep='\t',index=None)



def main():

#define parser and arguments
#IVP VRHYME BINNING 
    parser = argparse.ArgumentParser(prog='META_IVP_vRhyme_binning',description='this method executes script is executed post-vrhyme protocol to generate fasta with new bins')
    subparser = parser.add_subparsers(dest='subcommand',help ='enter the vrhyme membership file names with path and contig file names')
    ivp_vrhyme_binning_parser = subparser.add_parser("v_bin",help="This function creates new fasta with good bins")
    ivp_vrhyme_binning_parser.add_argument("-c", dest="contigs", type=str, help="contig file from metaIVP eg./path/to/determined_contigs.fasta as input")
    ivp_vrhyme_binning_parser.add_argument("-m", dest="membership_file", type=str, help="eggnog file eg. /path/to/vrhyme/best/bins/membership_file.tsv as input")
    ivp_vrhyme_binning_parser.add_argument("-o", dest="output_file_path", type=str, help="output file path")


#IMP REFORMAT COVERAGE
    ivp_reformat_coverage_parser=subparser.add_parser("reformat_bin",help="This function reformats coverage file")
    ivp_reformat_coverage_parser.add_argument("-i", dest="coverage_file", type=str, help="coverage file from metaIVP eg./path/to/coverage.tsv as input")
    ivp_reformat_coverage_parser.add_argument("-o", dest="output_reformat_file_path", type=str, help="output file path")


#assign values to parser
    args = parser.parse_args()

    if args.subcommand=='v_bin':
        contigs = args.contigs
        membership_file = args.membership_file
        final_contig_file = args.output_file_path
        print(contigs,membership_file,final_contig_file)
        create_vrhyme_bin(contigs,membership_file,final_contig_file)
    elif args.subcommand=='reformat_bin':
        coverage_file = args.coverage_file
        final_cov_reformated_file = args.output_reformat_file_path
        print(coverage_file,final_cov_reformated_file)
        reformat_coverage(coverage_file,final_cov_reformated_file)
    

    else:
        print("Wrong input. Check parameters")




if __name__ == "__main__":

    main()
