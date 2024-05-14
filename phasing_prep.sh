#!/bin/bash -l


#SBATCH -J PhaseIT
#SBATCH -A <snic_project_number>
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 15:00:00

chr=$1
KGP_Phase3=/directory_with_KGP_reference_haplotypes

# Load required modules
module load bioinfo-tools
module load SHAPEIT/v2.r837

cd /mosaic_directory/1.unphased
echo "Working on prep 1 for chromosome $chr"

shapeit -check --thread 8 \
    -R ${KGP_Phase3}/1000GP_Phase3_chr${chr}.hap.gz ${KGP_Phase3}/1000GP_Phase3_chr${chr}.legend.gz ${KGP_Phase3}/1000GP_Phase3.sample \
    -B bed_file_coloured_chr${chr} \
    -M ${KGP_Phase3}/genetic_map_GRCh37_chr${chr}.txt \
    -L to_remove_chr${chr}
