import os

import argparse

import pandas as pd





def purify_and_split_viral_bins(table_3_metaIMP: str, table_7_metaIMP: str, table_8_metaIMP: str,

                                viral_bin_scaffold_clean: str, output_dir: str):

    # Read input files

    table_3_metaIMP = pd.read_csv(table_3_metaIMP)

    table_7_metaIMP = pd.read_csv(table_7_metaIMP)

    table_8_metaIMP = pd.read_csv(table_8_metaIMP)

    viral_contigs = pd.read_csv(viral_bin_scaffold_clean)



    # Rename columns to match merge key

    table_3_metaIMP = table_3_metaIMP.rename(columns={'scaffold': 'contig_id'})

    table_7_metaIMP = table_7_metaIMP.rename(columns={'contig': 'contig_id'})

    table_8_metaIMP = table_8_metaIMP.rename(columns={'contig': 'contig_id'})



    # Merge with viral contigs

    merge_table_3_virus_contigs = pd.merge(viral_contigs, table_3_metaIMP, on='contig_id', how='inner')

    merge_table_7_virus_contigs = pd.merge(viral_contigs, table_7_metaIMP, on='contig_id', how='inner')

    merge_table_8_virus_contigs = pd.merge(viral_contigs, table_8_metaIMP, on='contig_id', how='inner')



    # Ensure output directory exists

    os.makedirs(output_dir, exist_ok=True)



    # Save outputs

    merge_table_3_virus_contigs.to_csv(os.path.join(output_dir, "viral_table_3_clean.csv"), index=False)

    merge_table_7_virus_contigs.to_csv(os.path.join(output_dir, "viral_table_7_clean.csv"), index=False)

    merge_table_8_virus_contigs.to_csv(os.path.join(output_dir, "viral_table_8_clean.csv"), index=False)





def main():

    parser = argparse.ArgumentParser(

        prog='viral_metagenome_bin_purification',

        description='This method purifies and splits metagenome and viral bins'

    )



    subparser = parser.add_subparsers(dest='subcommand', help='Choose a subcommand')



    split_file_parser = subparser.add_parser(

        "purifiy_split_bins", help="Purify and split viral bins from metaIMP tables"

    )



    split_file_parser.add_argument("-table_3", required=True, type=str, help="Path to Table 3 metaIMP CSV")

    split_file_parser.add_argument("-table_7", required=True, type=str, help="Path to Table 7 metaIMP CSV")

    split_file_parser.add_argument("-table_8", required=True, type=str, help="Path to Table 8 metaIMP CSV")

    split_file_parser.add_argument("-viral_bins", required=True, type=str, help="Path to viral_bin_scaffold_clean.csv")

    split_file_parser.add_argument("-o", "--output_dir", required=True, type=str, help="Output directory")



    args = parser.parse_args()



    if args.subcommand == 'purifiy_split_bins':

        purify_and_split_viral_bins(

            args.table_3,

            args.table_7,

            args.table_8,

            args.viral_bins,

            args.output_dir

        )

    else:

        parser.print_help()





if __name__ == "__main__":

    main()


