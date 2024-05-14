#!/bin/bash -l


#SBATCH -J muscle_mtDNA_alignment
#SBATCH -A <snic_project_number>
#SBATCH -n 1
#SBATCH -p node
#SBATCH -t 10-00:00:00

# Load required modules
module load bioinfo-tools
module load muscle/5.1

# Run the alignment using muscle
muscle -super5 -threads 20 file.fasta -output file_aligned.fasta
