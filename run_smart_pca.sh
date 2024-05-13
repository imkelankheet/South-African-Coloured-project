# This script runs smartpca on a bed file

# Load the required modules
module load bioinfo-tools eigensoft/7.2.1

# Generate a .par file with the settings to run smartpca
PREFIX=dataset_to_perform_smartpca_on
echo genotypename: out/$PREFIX.bed > out/${PREFIX}.par
echo snpname: out/dat16.bim >> out/${PREFIX}.par
echo indivname: out/dat16.PCA.fam >> out/${PREFIX}.par
echo spweightoutname: out/dat16.snpeigs >> out/${PREFIX}.par
echo evecoutname: out/dat16.evec >> out/${PREFIX}.par
echo evaloutname: out/dat16.eval >> out/${PREFIX}.par
echo phylipoutname: out/dat16.fst >> out/${PREFIX}.par
echo numoutevec: 20 >> out/${PREFIX}.par 
echo numoutlieriter: 0 >> out/${PREFIX}.par
echo outlieroutname: out/dat16.out >> out/${PREFIX}.par
echo altnormstyle: NO >> out/${PREFIX}.par
echo missingmode: NO >> out/${PREFIX}.par
echo nsmpidregress: 0 >> out/${PREFIX}.par
echo noxdata: YES >> out/${PREFIX}.par
echo nomalexhet: YES >> out/${PREFIX}.par


# Generate also a PCA.fam file, needed to run smartpca
awk '{print $1, $2, $3, $4, $5, 1}' dat16.fam > ${PREFIX}.PCA.fam

# Run smartpca, this generates an .evec and .eval file that you can use to plot the PCA
smartpca -p out/${PREFIX}.par
