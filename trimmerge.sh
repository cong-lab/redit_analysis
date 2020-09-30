#!/bin/bash
#SBATCH --account=congle
#SBATCH --partition=batch
#SBATCH --time=01:00:00
#SBATCH --job-name="trimmerge"
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --array=1-2
#SBATCH -o /labs/congle/training/crispresso/logs/trimmerge-%A-%a.out
#SBATCH -e /labs/congle/training/crispresso/logs/trimmerge-%A-%a.err

module purge
module load cutadapt/2.3

# specify and setup directories
WORKDIR="/labs/congle/training/crispresso"
OUTDIR="${WORKDIR}/trimmerge"

if [ ! -d $OUTDIR ]
then
    mkdir $OUTDIR
fi

cd $OUTDIR

# read-in sample information
SAMPLEFILE="${WORKDIR}/samples_trimmerge.csv"
SEED=`awk "NR==$SLURM_ARRAY_TASK_ID" $SAMPLEFILE`

SAMPLE=`echo "$SEED" | cut -d$',' -f1`
READ1=`echo "$SEED" | cut -d$',' -f2`
READ2=`echo "$SEED" | cut -d$',' -f3`

# trim reads
cutadapt \
    -g CCATCTCATCCCTGCGTGTCTCC \
    -a CATCACCGACTGCCCATAGAGAGG \
    -G CCTCTCTATGGGCAGTCGGTGATG \
    -A GGAGACACGCAGGGATGAGATGG \
    -o "${SAMPLE}.R1.trimmed.fastq.gz" \
    -p "${SAMPLE}.R2.trimmed.fastq.gz" \
    --discard-untrimmed \
    --pair-filter=both \
    -j 0 \
        ${READ1} \
        ${READ2}

# merge paired-end reads
/labs/congle/Software/FLASH2/flash2 \
    -M 300 \
    --allow-outies \
    --compress \
    -o ${SAMPLE} \
        ${SAMPLE}.R1.trimmed.fastq.gz \
	${SAMPLE}.R2.trimmed.fastq.gz

