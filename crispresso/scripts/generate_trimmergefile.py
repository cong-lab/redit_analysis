"""
generate_trimmergefile.py

description:
Part of the Cong lab CRISPResso2 workflow. Script takes as input the Cong lab
CRISPR editing NGS samplesheet containing sample metadata and the path to the
directory containing demultiplexed FASTQ files. The output is a comma-separated
file to be used as input for the read trimming and merging script containing
three columns:
    - the sample's name
    - path to sample read1 file
    - path to sample read2 file

usage:
generate_trimmergefile.py [-h] -s SAMPLESHEET
                          [--fastq_dir FASTQ_DIR]
                          [--fastq_subdir FASTQ_SUBDIR]
                          [--outfile OUTFILE]
"""

import argparse
import os

import pandas as pd


def parse_args():
    parser = argparse.ArgumentParser(
        description="Generate trimmerge input file from samplesheet."
    )
    parser.add_argument(
        "-s",
        "--samplesheet",
        type=str,
        required=True,
        help="Cong lab CRISPR editing NGS sheet.",
    )
    parser.add_argument(
        "--fastq_dir",
        type=str,
        default="fastq",
        required=False,
        help="Directory containing demultiplexed sample FASTQs.",
    )
    parser.add_argument(
        "--fastq_subdir",
        type=str,
        required=False,
        help="Subdirectory containing project-specific files.",
    )
    parser.add_argument(
        "--outfile",
        type=str,
        default="samples_trimmerge.csv",
        required=False,
        help="Output comma-separated file.",
    )

    args = parser.parse_args()
    samplesheet = args.samplesheet
    fastq_dir = args.fastq_dir
    fastq_subdir = args.fastq_subdir
    outfile = args.outfile

    return (samplesheet, fastq_dir, fastq_subdir, outfile)


def generate(samplesheet, fastq_dir, fastq_subdir, outfile):
    workdir = os.getcwd()
    outlines = list()
    sampledf = pd.read_csv(samplesheet)
    for index, row in sampledf.iterrows():
        sample_id = row["Sample_ID"]
        if not fastq_subdir:
            fastq_subdir = row["Experiment"]
        read1 = f"{workdir}/{fastq_dir}/{fastq_subdir}/{sample_id}_S{index+1}_R1_001.fastq.gz"
        read2 = f"{workdir}/{fastq_dir}/{fastq_subdir}/{sample_id}_S{index+1}_R2_001.fastq.gz"
        outlines.append([sample_id, read1, read2])

    with open(outfile, "w+") as outhandle:
        for line in outlines:
            outhandle.write(",".join(line) + "\n")

    return


if __name__ == "__main__":
    samplesheet, fastq_dir, fastq_subdir, outfile = parse_args()
    generate(samplesheet, fastq_dir, fastq_subdir, outfile)
    print(f"Output file: {outfile}")
