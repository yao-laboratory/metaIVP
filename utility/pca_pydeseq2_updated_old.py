import pandas as pd
import pickle as pkl
import pandas as pd

from pydeseq2.dds import DeseqDataSet
from pydeseq2.ds import DeseqStats
from pydeseq2.utils import load_example_data
import os
import argparse

import functools
from functools import reduce
import sklearn
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
import matplotlib as mpl
mpl.rcParams['pdf.fonttype'] = 42
mpl.rcParams['ps.fonttype'] = 42
mpl.rcParams['font.family'] = 'Arial'

def pca_analysis(input_df, metadata,output_directory):
    
    #Read input dataframe and MetaData
    data=pd.read_csv(input_df,index_col=0)
    metadata=pd.read_csv(metadata)
    
    #Set Markers and colors
    colors=metadata['Color']
    markers=metadata['Marker']
   
    #Plot PCA
    data = data.T
    pca = PCA(n_components=2)
    principalComponents = pca.fit_transform(data)
    principalDf = pd.DataFrame(data = principalComponents, columns = ['principal component 1', 'principal component 2'])
    principalDf.index=data.index
    finalDf=principalDf
    fig = plt.figure(figsize = (10,10))
    ax = fig.add_subplot(1,1,1) 
    ax.set_xlabel('Principal Component 1', fontsize = 15)
    ax.set_ylabel('Principal Component 2', fontsize = 15)
    ax.set_title('2 component PCA', fontsize = 20)
    sample_name = data.index
    
    count=0
    for i in finalDf.index:
        color = colors[count]
        marker = markers[count]
        ax.scatter(finalDf.loc[i, 'principal component 1']
                   , finalDf.loc[i, 'principal component 2']
                   , c = color, marker = marker
                   , s = 50)
        ax.text(finalDf.loc[i, 'principal component 1']
                , finalDf.loc[i, 'principal component 2'], i)
        count=count+1

    ax.grid()

    ax.tick_params(axis="both",labelsize=8)
    ax.set(xlabel=None,ylabel=None)
    final_pca_output=os.path.join(output_directory,"PCA_PLOT.pdf")
    plt.savefig(final_pca_output, bbox_inches='tight')
    
def pydeseq2(input_df,metadata,output_directory,threads):
    #Read input dataframe and MetaData
    print("Threads is",threads)
    data=pd.read_csv(input_df,index_col=0)
    print("data is")
    print(data.head(5))
    metadata=pd.read_csv(metadata)

#   #Create list to get metadata_column name and normalizer value for that column

 #   metadata_column=list()

 #   normalizer=list()

    #Append the list

  #  for i in metadata.index:

   #     metadata_column.append(metadata['Sample'][i])

    #    normalizer.append(metadata['normalizer'][i])

    #Multiply the list with normalized value

    #for i in metadata_column:

     #   for j in normalizer:

      #      data[i] = data[i].multiply(j)
    #convert all values to int, since dds wont accept float values.
    counts=data.astype(int)
    counts = counts[counts.sum(axis = 1) > 0]
    counts = counts.T
    print("counts is")
    print(counts.head(5))
    #convert index to list
    counts_index_list=counts.index.tolist()
     # Multiply normalized values by corresponding input values
#    samples = metadata['Sample']
#    for sample in samples:
#        normalized_value = metadata.loc[metadata['Sample'] == sample, 'normalizer'].values[0]
#        input_df[sample] = input_df[sample].astype(int) * normalized_value.astype(int)
    #Set 'Sample' as metadata index 
#    metadata = metadata.set_index('Sample')
#    print(metadata.head(5)) 
    #DDS
#    unique_conditions = metadata['Condition'].unique()
      #Create list to get metadata_column name and normalizer value for that column



    metadata_column=list()

  

    normalizer=list()



    #Append the list



    for i in metadata.index:



        metadata_column.append(metadata['Sample'][i])



        normalizer.append(metadata['normalizer'][i])



    #Multiply the list with normalized value



    for i in metadata_column:



        for j in normalizer:



            data[i] = data[i].multiply(j)
    unique_conditions = metadata['Condition'].unique()
   
    print("conditions are: "+",".join(unique_conditions))
    samples = metadata['Sample']
    metadata = metadata.set_index('Sample')

    print(metadata.head(5))

    #DDS
#    unique_conditions = metadata['Condition'].unique()

    dds = DeseqDataSet(counts=counts,
                       metadata=metadata,
                       design_factors="Condition")
    print("data prepared")
    #print("counts is")
    #counts.head(5)
    print("metadata is")
    metadata.head(5)
    dds.deseq2()
    print("deseq is running...")
    final_output_path=output_directory
    for i in unique_conditions:
        for j in unique_conditions:
            if i!=j:
                print("Start contrasting :"+ str(i)+"  "+str(j))
                stat_res = DeseqStats(dds, n_cpus=int(threads), contrast = ('Condition',i,j))

                summary=stat_res.summary()
                final_result_df=stat_res.results_df
                final_result_df=final_result_df.sort_values(by=['padj'])
                final_result=output_directory+"/file_condition"+i+"_"+j
                final_result_df.to_csv(final_result)
                print("Finish contrasting :"+ str(i)+"  "+str(j))
    print("deseq is done....")
    
    
def main():
    
    parser = argparse.ArgumentParser(prog='Pydeseq2_PCA_Plot',description='This method does Pydeseq2 and PCA plot for input dataframe')
    subparser = parser.add_subparsers(dest='subcommand',help ='Following files are the input:1)Input dataframe 2) Metadata 3) Output path')

	#Add PCA parser and subparser    
    pca_parser=subparser.add_parser("PCA",help="This function plots PCA ")
    pca_parser.add_argument("-i", dest="Input_dataframe", type=str, help="Dataframe file eg./path/to/input_dataframe.csv as input")
    pca_parser.add_argument("-m", dest="Metadata_file", type=str, help="vcf file eg. /path/to/metadata.csv as input")
    pca_parser.add_argument("-o", dest="Output_file_path", type=str, help="output file path")

    
	#Add Pydeseq2 parser and subparser
    pydeseq_parser=subparser.add_parser("pydeseq2",help="This function executes pydeseq2")
    pydeseq_parser.add_argument("-i", dest="Input_dataframe", type=str, help="Dataframe file eg./path/to/input_dataframe.csv as input")
    pydeseq_parser.add_argument("-m", dest="Metadata_file", type=str, help="vcf file eg. /path/to/metadata.csv as input")
    pydeseq_parser.add_argument("-o", dest="Output_file_path", type=str, help="output file path")
    pydeseq_parser.add_argument("-t", dest="Threads", type=str, help="Threads eg. N_CPUs for Pydeseq2 as input")
    args = parser.parse_args()
    
	#Two subparsers: 1) PCA 2) Pydeseq2    
    if args.subcommand=='PCA':
        input_df = args.Input_dataframe
        metadata = args.Metadata_file
        output_directory = args.Output_file_path
        print(input_df,metadata,output_directory)
        pca_analysis(input_df,metadata,output_directory)
    
    else:
        if args.subcommand=='pydeseq2':
            input_df = args.Input_dataframe
            metadata = args.Metadata_file
            output_directory = args.Output_file_path
            threads = args.Threads
     #       threads=arg.Threads
            print(input_df,metadata,output_directory,threads)
            pydeseq2(input_df,metadata,output_directory,threads)
        else:
            print("Wrong input. Check parameters")                        

if __name__ == "__main__":
    main()    
