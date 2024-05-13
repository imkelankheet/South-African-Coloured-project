#!/bin/bash -l


#SBATCH -J Kinship_analysis
#SBATCH -A <snic_project_number>
#SBATCH -n 1
#SBATCH -p core
#SBATCH -t 01:00:00

# Load required modules
module load bioinfo-tools
module load plink/1.90b4.9
module load KING/2.2.9

# Move into directory where the .bed file is you want to know the kinship relations for
cd <directory>

# Run the kinship analysis using king, this creates two files: king.kin (containing information of related individuals within sites) and king.kin0 (containing information of related individuals across sites):
king -b <file.bed> --kinship --degree 2
