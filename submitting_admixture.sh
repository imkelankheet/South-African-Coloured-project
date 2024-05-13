#!/bin/bash
# Loop over all the K's you want to perform ADMIXTURE for:
for kval in {2,3,4,5,6,7,8,9,10,11,12}; do
# Loop over the amount of iterations you want for each K:
   for itir in {1..50}; do
   # Submit this script:
           (echo '#!/bin/bash -l'
           echo "
           mkdir ${kval}.${itir}
           cd ${kval}.${itir} # Move into the working folder where admixture results are written
# Load required modules on uppmax
module load bioinfo-tools
module load ADMIXTURE/1.3.0

# Run Admixture:
admixture --cv=10 -j4 -s $RANDOM <file.bed> ${kval}
cd ../
rm -r ${kval}.${int}
exit 0") |
               sbatch -p core -n 4 -t 72:0:0 -A <snic_project_number> -J ADMX_COL.${kval}.${itir} -o ADMX_COL.${kval}.${itir}.output -e ADMX_COL.${kval}.${itir}.output
       done
done
