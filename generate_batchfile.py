"""
generate_batchfile.py
2020-03-23

description:
Part of the Cong lab CRISPResso2 workflow. Script takes as input the Cong lab
CRISPR editing NGS samplesheet containing sample metadata. The output is a
tab-separated file to be used as input for CRISPRessoBatch containing run
parameters, including:
    - sample name
    - path to trimmed, merged FASTQ file
    - name of the amplicon
    - sequence of the amplicon
    - sequence of the gRNA
    - cleavage offset of the nuclease

usage:
generate_batchfile.py [-h] -s SAMPLESHEET [--outfile OUTFILE]
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
        "--outfile",
        type=str,
        default="samples_batch.tsv",
        required=False,
        help="Output comma-separated file.",
    )

    args = parser.parse_args()
    samplesheet = args.samplesheet
    outfile = args.outfile

    return (samplesheet, outfile)


def generate_r1(samplesheet, outfile):
    workdir = os.getcwd()
    outlines = list()
    sampledf = pd.read_csv(samplesheet)
    for index, row in sampledf.iterrows():
        name = row["Sample_ID"]
        fastq_r1 = f"{workdir}/trimmerge/{name}.extendedFrags.fastq.gz"
        amplicon_name = row["amplicon_name"]
        amplicon_seq = row["amplicon_seq"]
        guide_seq = row["guide_seq"]

        nuclease = row["nuclease"]
        if nuclease in ["SpCas9", "SaCas9"]:
            cleavage_offset = "-3"
        elif nuclease == "Cpf1":
            cleavage_offset = "1"

        outlines.append(
            [
                name,
                fastq_r1,
                amplicon_name,
                amplicon_seq,
                guide_seq,
                cleavage_offset,
            ]
        )

    with open(outfile, "w+") as outhandle:
        headers = [
            "name",
            "fastq_r1",
            "amplicon_name",
            "amplicon_seq",
            "guide_seq",
            "cleavage_offset",
        ]
        outhandle.write("\t".join(headers) + "\n")

        for line in outlines:
            outhandle.write("\t".join(line) + "\n")

    return


if __name__ == "__main__":
    samplesheet, outfile = parse_args()
    generate_r1(samplesheet, outfile)
    print("Success! Output file: samples_batch.tsv")
