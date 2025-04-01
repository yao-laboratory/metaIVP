def contigs_m_v_add(contigs_m,contigs_v,table_3_m,table_3_v,output_table_path):

    

    #table merge

    table3_m=pd.read_csv(table_3_m)

    table3_v=pd.read_csv(table_3_v)

    table3_m['protein_id'] = 'm_' + table3_m['protein_id'].astype(str)

    table3_v['protein_id'] = 'v_' + table3_v['protein_id'].astype(str)

    table3_m['scaffold'] = 'm_' + table3_m['scaffold'].astype(str)

    table3_v['scaffold'] = 'v_' + table3_v['scaffold'].astype(str)

    merged_t3=pd.concat([table3_m,table3_v], axis=0)

    merged_t3.to_csv(output_table_path/combined_t3_edited.csv,index=None)  

    

    

    

    #contigs

    contigs_m=contigs_m

    contigs_v=contigs_v

    modified_contigs_m=output_table_path/modified_contigs.fasta

    modified_contigs_v=output_table_path/modified_contigs.fasta

    #add m_ to contigs

    input_file = contigs_m

    output_file = modified_contigs_m

    with open(input_file, "r") as infile, open(output_file, "w") as outfile:

        for line in infile:

            if line.startswith(">"):

                # Replace '>' with '>m_'

                modified_line = line.replace(">", ">m_", 1)

                outfile.write(modified_line)

            else:

                outfile.write(line)





    #add v_ to contigs

    input_file = contigs_v

    output_file = modified_contigs_v

    with open(input_file, "r") as infile, open(output_file, "w") as outfile:

        for line in infile:

            if line.startswith(">"):

                modified_line = line.replace(">", ">v_", 1)

                outfile.write(modified_line)

            else:

                outfile.write(line)

                



def main():

    parser = argparse.ArgumentParser(prog='contig_table_merge',descrption='this method merges metagenome and virus fasta tables from metaIMP and adds suffic to modify contigs')

    subparser = parser.add_subparsers(dest='subcommand',help ='enter the output folder, samplename')

    

    assembly_bin_aa_parser=subparser.add_parser("merge_contig_append_table", help = " This function merges contigs and appends csv tables")

    assembly_bin_aa_parser.add_argument("-contigpath_m", dest="contig_m", type=str, help="output folder eg./path/to/metaIMP_output_folder as input")

    assembly_bin_aa_parser.add_argument("-contigpath_v", dest="contig_v",  type=str, help="this will be the sample ID")

    assembly_bin_aa_parser.add_argument("-tablepath_m", dest="table_m",  type=str, help="this will be the sample ID")

    assembly_bin_aa_parser.add_argument("-tablepath_v", dest="table_v",  type=str, help="this will be the sample ID")

    assembly_bin_aa_parser.add_argument("-output", dest="output_table_path",  type=str, help="this will be the sample ID")

    

    args = parser.parse_args()

    

    if args.subcommand=='merge_contig_append_table':

        contigs_m=args.contig_m

        contigs_v=args.contig_v

        table_3_m=args.table_m

        table_3_v=args.table_v

        output_table_path=args.output_table_path

        print("---------------Start metaIVP")

        contigs_m_v_add(contigs_m,contigs_v,table_3_m,table_3_v,output_table_path)

        print("---------------End metaIVP")

    else:

        print("Wrong input. Check parameters")



if __name__ == "__main__": 

    main()    

    

    
