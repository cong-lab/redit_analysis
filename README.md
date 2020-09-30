# redit_analysis
Analysis script used for data analysis of gene-editing experiments used in REDIT manuscript

# Indel and HDR editing analysis pipeline from NGS data

**Platform:** Illumina Sequencing Paired-end

**Input:** Fastq files from the bcl2fastq output

All indel and HDR analysis are based on CRISPREsso2 pipeline:
https://github.com/pinellolab/CRISPResso2

Please click here [CongLab_Indel-HDR_analysis_pipeline_README](https://github.com/cong-lab/redit_analysis/blob/master/README_crispresso2.md) for the detailed scripts and descriptions that have been used for the REDIT manuscript on running and analyzing data for the indel and HDR editing events.

# GUIDE-seq and off-target editing analysis pipeline from NGS data

**Platform:** Illumina Sequencing Paired-end

**Input:** Fastq files from the bcl2fastq output

All GUIDE-seq and off-target editing analysis are based on the iGUIDE-SEQ pipeline:
https://github.com/cnobles/iGUIDE

Off-target analysis are done as described in iGUIDE with modification of the submission script as linked below:

1. iguide.sh: Script for submitting iGUIDE analysis job based on config files and sample info files providede based on the experiments. Detailed config files and sample information files for the REDIT manuscript are found at the [subfolder containing off-target sample info and config files
](https://github.com/cong-lab/redit_analysis/tree/master/off-target_sample-info-config)

2. iguide_clean.sh: Clean-up of the folder to remove temporary files in case of interruption or need for re-running the analysis with modified parameters.


