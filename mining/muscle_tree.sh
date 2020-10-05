#!/bin/bash
#SBATCH --account=default
#SBATCH --partition=batch
#SBATCH --time=01:00:00
#SBATCH --job-name='msa-tree'
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH -o /labs/congle/redit/mining/logs/muscle-tree-%A.out
#SBATCH -e /labs/congle/redit/mining/logs/muscle-tree-%A.err

module load muscle
module load fasttree

QUERY="RecE587"
INFA="${QUERY}_clusters.fa"
OUTFA="${QUERY}_msa.fa"
OUTTREE="${QUERY}_tree.nwe"

muscle -in $INFA -out $OUTFA
fasttree $OUTFA > $OUTTREE