#!/bin/bash
#SBATCH --account=default
#SBATCH --partition=batch
#SBATCH --time=00:30:00
#SBATCH --job-name='cdhit'
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH -o /labs/congle/redit/mining/logs/cdhit-%A.out
#SBATCH -e /labs/congle/redit/mining/logs/cdhit-%A.err

module load ncbi-blast

QUERY="RecE"

# hierachical clustering
# initial 90% identity threshold clustering
./cdhit/cd-hit \
    -i "${QUERY}_psiblast_seqs.fa" \
    -o "${QUERY}_clusters_90" \
    -c 0.90 \
    -n 5 \
    -d 999 \
    -g 1 \
    -M 0 \
    -T 0

# intermediate 60% identity threshold clustering
./cdhit/cd-hit \
    -i "${QUERY}_clusters_90" \
    -o "${QUERY}_clusters_60" \
    -c 0.6 \
    -n 4 \
    -d 999 \
    -g 1 \
    -M 0 \
    -T 0

# final lower identity threshold clustering with psi-cd-hit
./cdhit/psi-cd-hit/psi-cd-hit.pl \
    -i "${QUERY}_clusters_60" \
    -o "${QUERY}_clusters.fa" \
    -c 0.25 \
    # -ce 1e-6 \
    -exec local \
    -para 4 \
    -blp 1 \

# tidy up dir
rm "${QUERY}_clusters.fa.log"
mv "${QUERY}_clusters.fa.out" "${QUERY}_clusters.out"
mv "${QUERY}_clusters.fa.clstr" "${QUERY}_clusters.clstr"

