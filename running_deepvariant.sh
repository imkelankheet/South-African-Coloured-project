cd /deepvariant_directory

while read -r samplename fw rv seqsample
do
echo $seqsample

INPUT_DIR="${PWD}"
OUTPUT_DIR="${PWD}/VCF_files"
echo $INPUT_DIR
echo $OUTPUT_DIR

BIN_VERSION="1.5.0"
sudo docker run \
-v "${INPUT_DIR}":"/input" \
-v "${OUTPUT_DIR}":"/output" \
google/deepvariant:"${BIN_VERSION}" \
/opt/deepvariant/bin/run_deepvariant \
--model_type=PACBIO \
--ref=/input/Reference/doubleHumanMito.fasta \
--reads=/input/BAM_files/${seqsample}/${seqsample}.mapped.bam \
--output_vcf=/output/${seqsample}.vcf.gz \
--output_gvcf=/output/${seqsample}.g.vcf.gz
done < samples_barcodes_pt221.txt
