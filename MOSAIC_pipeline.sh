#Overview:
# 1. Split the bed file into separate chromosomes
# 2. Run phasing_prep.sh
# 3. Run phasing_prep2.sh
# 4. Run phasing_shapeIT.sh
# 5. Convert the .haps files to pop.genofile.chr files
# 6. Make correct snpfile
# 7. Run MOSAIC





# 1. Split the bed file into separate chromosomes
module load bioinfo-tools
module load plink/1.90b4.9

cd /MOSAIC_directory/1.unphased

file_to_split="<directory_of_bed_file_to_split>"

for chr in {1..22}
do
plink --bfile $file_to_split --chr $chr --make-bed --out bed_file_coloured_chr$chr
done



# 2. Run phasing_prep.sh
for chr in {1..22}
do
sbatch phasing_prep.sh $chr
done



# 3. Run phasing_prep2.sh
for chr in {1..22}
do
sbatch phasing_prep2.sh $chr
done



# 4. Run phasing_shapeIT.sh
for chr in {1..22}
do
sbatch phasing_shapeIT.sh $chr
done



#5. Convert the .haps files to pop.genofile.chr files
sbatch conversion_from_haps.sh



# 6. Make correct snpfile

# 6.1 Add the following header to all snpfiles "V1"    "V2"    "V3"    "V4"    "V5"    "V6"

# 6.2 Add the line counter “1”, etc. to the file with the following for loop:
for chr in {1..22}; 
do
counter=0
while read line
do
echo "\"${counter}\"" $line >> new_snpfile.${chr}
counter=$((counter+1))
done <snpfile.${chr}
sed -i $'s/"0"/ /g'  new_snpfile.${chr}
done

#6.3 List the the actual variants in the new_snpfile.${chr}
for chr in {1..22}; 
do
python make_correct_snp_file_from_snp.py -s new_snpfile.${chr} -b ../1.unphased/bed_file_coloured_chr${chr}.bim
done

# 6.4	Move the snpfiles to another folder so that you can rename the new ones:
for i in {1..22}; do mv new_snpfile.${i} snpfile.${i}; done

# 6.5 Copy rates files to directory



# 7. Run MOSAIC
while read population number
do
sbatch running_mosaic.sh $population $number
done < coloured_populations.txt





