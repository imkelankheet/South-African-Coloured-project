# Load required modules
module load bioinfo-tools; module load plink/1.90b4.9

# Unzipping a zipped tped file, and generating a bed, bim and fam file from a tped file
tar -xvzf file.tped.tar.gz
plink --tfile file –recode
plink --file plink --make-bed --out file

# Creating a new dataset with only specific families in dataset
plink --bfile file --keep-fam text_file_with_fams_to_keep.txt --make-bed --out file_with_only_fams_to_keep

# Removing SNPs with missingness >10%
plink --bfile file --geno 0.1 --make-bed --out file_missingness_removed

# Removing individuals with > 15% missing
plink --bfile file --missing
sed  "s/ \+/\t/g" plink.imiss | sed  "s/^\t//g" | sort -r -n -k6,6 > plink.imiss.s1
plink --bfile file --mind 0.15 --make-bed --out file_missingness_0.15_ind_removed

# Removing individuals specified in the file to_be_removed.txt (should have one column with family name, one with sample name)
plink --bfile file --remove to_be_removed.txt --make-bed --out file_without_removed_individual

# Merging two datasets
plink --bfile file1 --bmerge file2.bed file2.bim file2.fam --make-bed --out merged_file
plink --bfile file2  --flip merged_file-merge.missnp --make-bed --out file2_flipped
plink --bfile file1 --bmerge file2_flipped.bed file2_flipped.bim file2_flipped.fam --make-bed --out merged_file
awk '{print $2}' file1.bim | sort > file1_snps.txt
awk '{print $2}' file2.bim | sort > file2_snps.txt
comm -12 file1_snps.txt file2_snps.txt > intersecting_snps_merged_file.txt
plink --bfile merged_file --extract intersecting_snps_merged_file.txt --make-bed --out merged_file_overlap

# Merging two datasets and there are sites with more than 3 alleles, these sites have to be removed
plink --bfile file1 --bmerge file2.bed file2.bim file2.fam --make-bed --out dataset_to_be
plink --bfile file2 --flip dataset_to_be-merge.missnp --make-bed --out file2_flipped
plink --bfile file1 --bmerge file2_flipped.bed file2_flipped.bim file2_flipped.fam --make-bed --out dataset_to_be
plink --bfile file2 --exclude dataset_to_be-merge.missnp --make-bed --out file2_excluded
plink --bfile file1 --bmerge file2_excluded.bed file2_excluded.bim file2_excluded.fam --make-bed --out merged_dataset
plink --bfile file2_excluded --flip merged_dataset-merge.missnp --make-bed --out file2_excluded_flipped
plink --bfile file1 --bmerge file2_excluded_flipped.bed file2_excluded_flipped.bim file2_excluded_flipped.fam --make-bed --out merged_dataset
awk '{print $2}' file1.bim | sort > file1_snps.txt
awk '{print $2}' file2_excluded_flipped.bim| sort >file2_snps.txt
comm -12 file1_snps.txt file2_snps.txt > intersecting_snps_merged_file.txt
plink --bfile merged_dataset --extract intersecting_snps_merged_file.txt --make-bed --out merged_dataset_overlap

# Generate a fake individual for the main dataset
CSV_file="H3Africa_2019_20037295_B1.csv" 
head -n -24 $CSV_file > ${CSV_file}_last_24_removed.csv
cut -d"," -f2,4 ${CSV_file}_last_24_removed.csv | sed "s/\,/\t/g" | sed "s/\[//g"| sed "s/\]//g" | sed -e '1,8d' | sed "s/\//\t/g" | sed "s/^/fakeA\tfakeA\t/g" > fakeA.lgen
cut -d"," -f2 ${CSV_file}_last_24_removed.csv | sed -e '1,8d' | sed "s/\,/\t/g" > snp
cut -d"," -f10 ${CSV_file}_last_24_removed.csv | sed -e '1,8d' | sed "s/\,/\t/g" > chr
cut -d"," -f11 ${CSV_file}_last_24_removed.csv | sed -e '1,8d' | sed "s/\,/\t/g" | sed "s/^/0\t/g" > pos
paste chr snp pos > fakeA.map
touch fakeA.fam
echo "fakeA fakeA 0 0 0 -9" >> fakeA.fam 
plink --lfile fakeA --make-bed --out fakeA

# Exclude SNPs in LD for ADMIXTURE and PCA
plink --bfile file --indep-pairwise 200 25 0.4 --out file_filtered_LD

# Print the families in the .fam file and count how many individuals are in the file for that family
awk '{print $1}' file.fam | sort | uniq -c

# Generate a ind2pop.txt file needed to run PONG after ADMIXTURE
cut -f 1 -d " " file.fam > ind2pop.txt

# Check biological sex of all individuals, output in the 4th column of file.sex_determined.sexcheck: 1= male, 2=female
plink -bfile file --check-sex --make-bed --out file.sex_determined 

# Select only the Y chromosome
plink --bfile file --chr Y --make-bed --out file_chromosomeY_only

# Cutting chromosomes to 180 cm
for chr in {1..6}
do
plink --bfile file --chr $chr --make-bed --out chromosome${chr}_file
plink --bfile chromosome${chr}_file --cm-map new_map_b37_chr@.txt --make-bed --out chromosome${chr}_file_cm
cat chromosome${chr}_file_cm.bim > chromosome${chr}_file_cm_180.txt
done
# remove all lines that are over 180cmn in the file chromosome${chr}_file_cm_180.txt and then run:
for chr in {1..6}
do
plink --bfile chromosome${chr}_dat11_cm --extract chromosome${chr}_dat11_cm_180.txt --make-bed --out chromosome${chr}_dat11_cm_180
done



