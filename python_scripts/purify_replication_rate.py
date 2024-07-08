import os

from os import listdir

from os.path import isfile, join

import argparse

import pandas as pd



def irep_purification(irep_path):

    os.chdir(irep_path)
    onlyfiles = [f for f in listdir(irep_path) if isfile(join(irep_path, f)) and f.split(".")[-1]=='tsv']
    print(onlyfiles)
    big_combined_new_dataframe = pd.DataFrame([])
    
    #single_hash_lines = []
    #double_hash_lines = []
    #values_after_paths = []
    for i in range(0, len(onlyfiles)):
        single_hash_lines = []
        double_hash_lines = []
        values_after_paths = []
        with open(onlyfiles[i], 'r') as file:
            single_hash_lines.append('binID')
            double_hash_lines.append('binID')
            values_after_paths.append(('path',onlyfiles[i]))
            current_header = None
            current_value = None
            for line in file:
                line = line.strip()
                if line.startswith("##"):
                    double_hash_lines.append(line)
                    current_header = line
                elif line.startswith("#"):
                    single_hash_lines.append(line)
                    current_header = line
                elif current_header is not None:
                    parts = line.split('\t')
                    if len(parts) > 1:
                        path = parts[0].strip()
                        value = parts[1].strip()
                        values_after_paths.append((path, value))
                        current_value = value

        value_list=[]
        for path, value in values_after_paths:
            print(f" Value: {value}")
            value_list.append(value)
        column_name = []
        for line in double_hash_lines:
            column_name.append(line)
        combined_new_dataframe = pd.DataFrame(list(zip(column_name, value_list)), columns=['Column_Name', 'Value'])
        combined_new_dataframe['Column_Name'] = combined_new_dataframe['Column_Name'].str.replace('## ', '')
        combined_new_dataframe = combined_new_dataframe.set_index('Column_Name')
        print(combined_new_dataframe)
        combined_new_dataframe = combined_new_dataframe.T


        big_combined_new_dataframe=pd.concat([big_combined_new_dataframe,combined_new_dataframe])

    big_combined_new_dataframe.to_csv(join(irep_path,'replication_irep.csv'),index = None, sep = ',')

    '''
#    print(single_hash_lines)
#    print(double_hash_lines)
#    print(values_after_paths)
    value_list = []
    #print("\nValues after paths:")
    for path, value in values_after_paths:
        print(f" Value: {value}")
        value_list.append(value)
  #  print(value_list)
    column_name = []
    for line in double_hash_lines:
        column_name.append(line)
 #       print("\nColumn_name:")
 #       print(column_name)

    combined_new_dataframe = pd.DataFrame(list(zip(column_name, value_list)), columns=['Column_Name', 'Value'])
    combined_new_dataframe['Column_Name'] = combined_new_dataframe['Column_Name'].str.replace('## ', '')
    combined_new_dataframe = combined_new_dataframe.set_index('Column_Name')
    print(combined_new_dataframe)
    combined_new_dataframe = combined_new_dataframe.T
#            df_peg_id.to_csv(join(patric_path, realfilename + '.patric.csv'), index = None, sep = '\t'
 
    combined_new_dataframe.to_csv(join(irep_path,'replication_irep.csv'),index = None, sep = '\t')  # Add the path to the final result file
    '''


def main():

    parser = argparse.ArgumentParser(prog='META_IVP_replication', description='this method executes irep concat method for bacteria bins irep')

    subparser = parser.add_subparsers(dest='subcommand', help='enter the irep output file path names')



    assembly_mapping_parser = subparser.add_parser("irep", help="This function is to map snps with annotations")

    assembly_mapping_parser.add_argument("-i", dest="irep_output_folder_path", type=str, help="irep files e.g., /path/to/irep_output.tsv as input")



    args = parser.parse_args()



    if args.subcommand == 'irep':

        irep_output_path = args.irep_output_folder_path

        print(irep_output_path)

        irep_purification(irep_output_path)

    else:

        print("Wrong input. Check parameters")



if __name__ == "__main__":

    main()


