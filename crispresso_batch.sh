#!/bin/bash
#SBATCH --account=congle
#SBATCH --partition=batch
#SBATCH --time=01:00:00
#SBATCH --job-name="csp_batch"
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH -o /labs/congle/training/crispresso/logs/csp-batch-%A.out
#SBATCH -e /labs/congle/training/crispresso/logs/csp-batch-%A.err

module purge
module load miniconda
source activate csp

BATCHFILE=samples_batch.tsv

CRISPRessoBatch \
    --n_processes 16 \
    --batch_settings $BATCHFILE \
    --batch_output_folder . \
    --amplicon_min_alignment_score 60 \
    --quantification_window_size 1 \
    --plot_window_size 20 \
    --skip_failed

