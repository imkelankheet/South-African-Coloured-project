#!/bin/bash -l

# This script gets all the cross-validation values from the different ADMIXTURE runs and outputs it to the file ADMX_COL.CV.txt, which can be plotted later using plotting_cross_validation.R
# Perform these commands in the admixture directory
prefix="ADMX_COL"
echo '# CV results' > ${prefix}.CV.txt 

for K in {2..12};
do
    for iteration in {1..50};
    do
awk -v K=$K '$1=="CV" {print K,$4}' ${prefix}.${K}.${iteration}.output >> ${prefix}.CV.txt;
done
done 

