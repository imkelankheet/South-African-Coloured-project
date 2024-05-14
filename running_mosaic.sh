#!/bin/bash -l


#SBATCH -J MOSAIC
#SBATCH -t 3-00:00:00
#SBATCH -A <snic_project_number>
#SBATCH -n 1
#SBATCH -p node

module load bioinfo-tools
module load R/4.0.0
module load R_packages/4.0.0

# Run MOSAIC, $1 is the population and $2 is the number of individuals in that population
Rscript --vanilla mosaic.R $1 mosaic_directory/3.mosaic_input -a 5 -n $2 -c 1:22 -m 16 -p "Afrikaner Amhara Baniamer Banyarwanda Bitonga CEU_EUR CHB_EAS GBR_EUR GIH_SAS GuiGhanaKgal Hadandawa Hadza Hamer Juhoansi Karretjie Khomani KHV_EAS Khwe Kikuyu LWK_AFR Mandinka Mikea Nama NAMA Oromo Pedi Sabue Sandawe Sotho STU_SAS Temoro Vezo Wolof Xade Xhosa Xun YRI_AFR Zulu"
