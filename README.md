# metaIVP

LOG file summary (this is initial documentation) 10152025

#post_processing_non_virus_binning.log: Logs the binning process for non-viral genomic data.
#post_processing_non_virus_checkm2.log: Records quality assessment of non-viral bins using CheckM2.
#post_processing_non_virus_irep.log: Tracks replication rate analysis on non-viral genomes with iRep.
#post_processing_non_virus.log: General log for non-viral post-processing steps.
#post_processing_non_virus_samtools.log: Logs alignment and mapping stats for non-viral data using samtools.
#post_processing_viral_binning.log: Documents viral genome binning operations.
#post_processing_virus_binning_vrhyme.log: Tracks viral binning using VRhyme tool.
#post_processing_virus_checkv.log: Logs viral genome quality checks using CheckV.
#post_processing_virus_checkv_with_vrhyme.log: Combined viral QC and binning log using CheckV and VRhyme.
#post_processing_virus_genomad.log: Records contamination detection on viral genomes with Genomad.
#post_processing_virus_iphop.log: Logs phage-host interaction predictions with iPHoP.
#post_processing_virus.log: General log of viral genome post-processing steps.
#purify_bins_checkv.log: Logs quality control of bins during purification using CheckV.
#purify_bins.log: Records bin purification processes.
#purify_contigs_checkv.log: Tracks quality checks on contigs during purification with CheckV.
#purify_contigs_genomad.log: Logs contamination detection on contigs during purification using Genomad.
#purify_contigs.log: General log for contig purification steps.

Module_1:
#purify_contigs.log: General log for contig purification steps. #module log
	#purify_contigs_checkv.log: Tracks quality checks on contigs during purification with CheckV. #submodule process
	#purify_contigs_genomad.log: Logs contamination detection on contigs during purification using Genomad. #submodule process
Module_2:
#purify_bins.log: Records bin purification processes. #module log
	#purify_bins_checkv.log: Logs quality control of bins during purification using CheckV.
    
#(Module_2.1, 2.2, and 2.3 are sub-module logs)
#It is important to delete both module log, and sub-module log along with sub-module process log to run a specific process. 
#For example: If user wants to run VRhyme again, they need to delete the following logs: 1) purify_bins.log 2) pos_porcessing_viral_binning.log 3) post_processing_viral_binnning.log



	Module_2.1:
    #post_processing_non_virus.log: General log for non-viral post-processing steps. (this log controls the entire module)
	#post_processing_non_virus_binning.log: Logs the binning process for non-viral genomic data. #submodule process
	#post_processing_non_virus_samtools.log: Logs alignment and mapping stats for non-viral data using samtools. #submodule process
	#post_processing_non_virus_checkm2.log: Records quality assessment of non-viral bins using CheckM2. #submodule process
	#post_processing_non_virus_irep.log: Tracks replication rate analysis on non-viral genomes with iRep. #submodule process


	Module_2.2:
    #post_processing_virus.log: General log of viral genome post-processing steps.
	#post_processing_virus_iphop.log: Logs phage-host interaction predictions with iPHoP. #submodule process
	#post_processing_virus_genomad.log: Records contamination detection on viral genomes with Genomad. #submodule process
	#post_processing_virus_checkv.log: Logs viral genome quality checks using CheckV. #submodule process
	
	Module_2.3:
    #post_processing_viral_binning.log: Documents viral genome binning operations. 

	#post_processing_virus_binning_vrhyme.log: Logs vrhyme binning process using new bin_virus.fasta #submodule process

