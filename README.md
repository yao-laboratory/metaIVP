# metaIVP
# MetaIMP
------------


## 1. INTRODUCTION
metaIVP is an integrated metagenomic pipeline which allows users to identify ...
#mutations and their respective protein annotations using a pipeline model. In this document, we list out the steps to be followed by a user to successfully complete assembly and reference based methods of metagenomic analysis. Users can choose either the assembly or reference method to begin processing of two paired-end files provided as input in FASTA format.

<img src="./Figure1.svg" width="500" height="600"/>

-------------
## 2. INSTALLATION
metaIMP requires a cocktail of Java, Python and Linux scripts in order to provide the most accurate analysis of user's metagenome data. Backend is based on Linux, which can be accessedusing any unix terminal.

To download metaIMP from Github, use :

```
git clone https://github.com/yao-laboratory/metaIVP
```

After the repo is cloned, user can run the following shell script to install their custom python environment.
Note: Users must have 'conda' and 'mamba' installed in their systems before proceeding with installation. This is a prerequisite.
```
export $USER_ENVIRONMENT

1) ./install.sh
2) ./install_test.sh
```
User can either run install.sh or refer to example_hcc_install.sh for creating a job.


These are the required constants which the user needs to provide when submitting a job. Example job submission script for assembly and reference can be found
in the "Example" folder. Users can provide path to databases in order to use their own dbs.


