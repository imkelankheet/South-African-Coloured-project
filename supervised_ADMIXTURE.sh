# Supervised ADMIXTURE for the X-chromsome
#!/bin/bash
for kval in 5; do
   for itir in {1..50}; do
           (echo '#!/bin/bash -l'
           echo "
           mkdir ${kval}.${itir}
           cd ${kval}.${itir}
# Load required modules
module load bioinfo-tools
module load ADMIXTURE/1.3.0
# Run supervised ADMIXTURE
admixture --cv=10 -j4 --supervised -s $RANDOM X_chromosome_bed_file.bed ${kval} 
cd ../
rm -r ${kval}.${int}
# Moves it to a different folder and renames it so you end up with multiple iterations
exit 0") |
               sbatch -p core -n 4 -t 7:00:00 -A <snic_project_number> -J ADMX_COL.${kval}.${itir} -o ADMX_COL.${kval}.${itir}.output -e ADMX_COL.${kval}.${itir}.output
       done
done

# Supervised ADMIXTURe for the autosomes (1-6 + 7,10 and 12 cut to the length of the X-chromosome)
#!/bin/bash
for chr in 1 2 3 4 5 6 7 10 12
do
cd /<admixture_directory>
mkdir chr${chr}
cd chr${chr}
for kval in 5; do
   for itir in {1..50}; do
           (echo '#!/bin/bash -l'
           echo "
           mkdir ${kval}.${itir}
           cd ${kval}.${itir}
# Load required modules
module load bioinfo-tools
module load ADMIXTURE/1.3.0
# Run supervised ADMIXTURE, chromosome${chr}.bed is cut to the length of the X-chromosome in the case of chr 1-6 and all chromosomes are downsampled to the same number of SNPs as on the X-chromosome.
admixture --cv=10 -j4 --supervised -s $RANDOM chromosome${chr}.bed ${kval}  
cd ../
rm -r ${kval}.${int}
# Moves it to a different folder and renames it so you end up with multiple iterations
exit 0") |
               sbatch -p core -n 4 -t 7:00:00 -A <snic_project_number> -J ${chr}_ADMX_COL.${kval}.${itir} -o ${chr}_ADMX_COL.${kval}.${itir}.output -e ${chr}_ADMX_COL.${kval}.${itir}.output
       done
done
