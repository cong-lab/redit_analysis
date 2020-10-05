#!/bin/bash
#SBATCH --account=default
#SBATCH --partition=interactive
#SBATCH --time=24:00:00
#SBATCH --job-name="iguide"
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH -o /labs/congle/HR/iGUIDE/logs/iguide-%A.out
#SBATCH -e /labs/congle/HR/iGUIDE/logs/iguide-%A.err

module load seqtk
module load anaconda
source activate iguide

iguide run configs/qianhe_191219_ds50k.config.yml -- \
    -j 24 \
    --resources mem_mb=120000 \
    --latency-wait 600 \
    --rerun-incomplete \
    --cluster-config configs/scg.cluster.json \
    --cluster "sbatch \
        --account {cluster.account} \
        --partition {cluster.partition} \
        -t {cluster.time} \
        --nodes {cluster.nodes} \
        --ntasks {cluster.ntasks} \
        --cpus-per-task {cluster.cpus-per-task} \
        --mem {cluster.mem} \
        --job-name {cluster.job-name} \
        -o {cluster.output} \
        -e {cluster.error}"

