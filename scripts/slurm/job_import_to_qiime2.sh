#!/bin/bash      

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=01:00:00
#SBATCH --mem=24GB

# Notification configuration
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gina.guzzo@adelaide.edu.au

# Slurm log options
#SBATCH --job-name=import_to_qiime2
#SBATCH --output=/hpcfs/users/a1640999/2026_aom_16s_processing/logs/%x-%j.out
#SBATCH --error=/hpcfs/users/a1640999/2026_aom_16s_processing/logs/%x-%j.err 

# Execute the program
bash /hpcfs/users/a1640999/2026_aom_16s_processing/scripts/import_to_qiime2.sh "$@"
