#!/bin/bash
#SBATCH --account=congle
#SBATCH --partition=batch
#SBATCH --time=01:00:00
#SBATCH --job-name='psiblast'
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=80G
#SBATCH -o /labs/congle/redit/mining/logs/psiblast-%A.out
#SBATCH -e /labs/congle/redit/mining/logs/psiblast-%A.err

module load ncbi-blast

QUERY="Gp25"
DIR="/labs/congle/jkcheng/hr/mining"
INFILE="${DIR}/queries/${QUERY}.fa"
OUTHITS="${DIR}/${QUERY}_psiblast_hits.tsv"
OUTCKPT="${DIR}/${QUERY}_psiblast_pssm.ckpt"
TMPIDS="${DIR}/{QUERY}_ids.tmp"
OUTFASTA="${DIR}/${QUERY}_psiblast_seqs.fa"

# change to dir containing blastdb
cd db/nr

# psiblast local
psiblast -query $INFILE -db nr -evalue 1e-6 -threshold 10 -matrix BLOSUM62 -max_target_seqs 10000 -num_threads 32 -num_iterations 5 -save_pssm_after_last_round -out_pssm $OUTCKPT -outfmt "6 qseqid sseqid slen length pident gaps evalue bitscore staxids sscinames scomnames stitle" -out $OUTHITS

# extract subject sequence ids
cut -f2 $OUTHITS > $TMPIDS
# generate fasta from blast hits
blastdbcmd -db nr -dbtype prot -entry_batch $TMPIDS -outfmt "%f" -out $OUTFASTA
rm $TMPIDS
