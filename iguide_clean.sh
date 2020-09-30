#!/bin/bash
#SBATCH --account=default
#SBATCH --partition=interactive
#SBATCH --time=2:00:00
#SBATCH --job-name="igclean"
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G

module load miniconda
source activate iguide

iguide clean configs/qianhe_191219_ds50k.config.yml --remove_proj

