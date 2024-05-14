#!/bin/bash -l


#SBATCH -J HaploGrep
#SBATCH -A <snic_project_number>
#SBATCH -n 1
#SBATCH -p core
#SBATCH -t 01:00:00

# Run Haplogrep3
/home/imklan/haplogrep3 classify --in file.fasta --out HaploGrep3_haplogroups_file.txt --tree phylotree-rcrs@17.2
