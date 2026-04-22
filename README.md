# metaIVP
# MetaIMP
------------


## 1. INTRODUCTION
🧬 metaIVP
Integrated Viral Purification and Analysis Pipeline for Metagenomes

📖 Overview

metaIVP is a modular and reproducible pipeline for viral genome identification, purification, and ecological interpretation from metagenomic assemblies.

Unlike conventional workflows that operate at a single resolution, metaIVP performs iterative refinement at both contig and bin levels, enabling:
Improved separation of viral and cellular signals
Recovery of high-quality viral genomes
Robust downstream analysis (annotation, host prediction, replication dynamics)

🔬 Workflow

<img src="./Figure1.svg" width="500" height="600"/>

Key Design Principles
🔁 Cross-scale purification (contig ↔ bin)
🧠 Consensus classification across multiple tools
🧩 Modular architecture
📊 Biologically interpretable outputs


-------------
## 2. INSTALLATION

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


2.1. Input

Required inputs:
| File        | Description                            |
| ----------- | -------------------------------------- |
| `--reads`   | Raw sequencing reads (`.fq`, optional) |
| `--contigs` | Assembled contigs (`.fa`)              |
| `--bins`    | Binned genomes (`.fa`)                 |



2.2. Output

This section describes the output folder structure and provides description for important files

metaIVP/
├── run_metaIVP.sh              # main entry point
├── scripts/
│   ├── contig_purification.sh
│   ├── bin_purification.sh
│   ├── viral_refinement.sh
│   ├── viral_analysis.sh
│   └── nonviral_analysis.sh
├── configs/
│   └── config.yaml
├── docs/
│   └── pipeline.png
├── examples/
│   └── test_dataset/
└── results/


| Category        | Description                   |
| --------------- | ----------------------------- |
| Viral bins      | High-confidence viral genomes |
| Non-viral bins  | Refined microbial MAGs        |
| QC metrics      | Completeness, contamination   |
| Annotation      | Functional & taxonomic        |
| Host prediction | Virus-host interactions       |
| Replication     | Growth rates (iRep)           |



2.3 Example commands

The following commands can be used as an example to run metaIVP pipeline:


A) Python:


B) Slurm job:





3. Related Pipelines
metaIMP – integrated metagenomic processing
MVP – metagenomic viral pipeline
metaIVP extends these approaches with:
Iterative purification
Cross-resolution integration
Enhanced viral bin recovery


@article{metaIVP,
  title   = {metaIVP: Integrated viral purification and analysis from metagenomes},
  author  = {Yao Laboratory},
  journal = {TBD},
  year    = {202X}
}

🙏 Acknowledgements
This pipeline integrates methods from:
CheckV
Genomad
iPHoP
vRhyme
CheckM2
iRep

📬 Contact
For questions or issues:
https://github.com/yao-laboratory/metaIVP/issues


🧭 Roadmap
 Snakemake / Nextflow implementation
 Containerized version (Docker/Singularity)
 Benchmark datasets
 Visualization module

