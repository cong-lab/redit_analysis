#!/bin/bash
#SBATCH --account=default
#SBATCH --partition=batch
#SBATCH --time=01:00:00
#SBATCH --job-name='blast2fa'
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH -o /labs/congle/redit/mining/logs/blast2fa-%A.out
#SBATCH -e /labs/congle/redit/mining/logs/blast2fa-%A.err

module load ncbi-blast

QUERY="expanded_Gp25"
DIR="/labs/congle/jkcheng/hr/mining"
INFILE="${DIR}/${QUERY}_psiblast_hits_dedup.tsv"
TMPIDS="${DIR}/${QUERY}_ids.tmp"
OUTFASTA="${DIR}/${QUERY}_psiblast_seqs.fa"

# change to dir containing blastdb
cd db/nr

# extract subject sequence ids
cut -f2 $INFILE > $TMPIDS
# generate fasta from blast hits
blastdbcmd -db nr -dbtype prot -entry_batch $TMPIDS -outfmt "%f" -out $OUTFASTA
rm $TMPIDS
