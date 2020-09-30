#!/bin/bash
#SBATCH --account=congle
#SBATCH --partition=batch
#SBATCH --time=01:00:00
#SBATCH --job-name="bcl2fastq"
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH -o /labs/congle/training/crispresso/logs/bcl2fastq-%A.out
#SBATCH -e /labs/congle/training/crispresso/logs/bcl2fastq-%A.err

module purge
module load bcl2fastq2/2.20.0.422

WORKDIR="/labs/congle/training/crispresso"

bcl2fastq \
    --runfolder-dir "${WORKDIR}/runfolder" \
    --output-dir "${WORKDIR}/fastq" \
    --sample-sheet "${WORKDIR}/samples_ngs.csv" \
    --no-lane-splitting

