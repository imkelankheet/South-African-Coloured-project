#!/bin/bash -l


#SBATCH -J MOSAIC_from_haps
#SBATCH -t 3-00:00:00
#SBATCH -A <snic_project_number>
#SBATCH -n 1
#SBATCH -p node

# Load required modules
module load bioinfo-tools
module load R/4.0.0
module load R_packages/4.0.0


# Convert files so that MOSAIC recognizes them using the script convert_from_haps.R
for i in {1..22}
do
Rscript --vanilla convert_from_haps.R /mosaic_directory/2.phased $i bed_file_coloured_chr .haps Populations.txt /mosaic_directory/3.mosaic_input
done
