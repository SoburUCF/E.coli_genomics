#! /bin/bash
#SBATCH -N 1
#SBATCH -n 18
#SBATCH -t 6-00
#SBATCH --mem=10000
#SBATCH -o roary.%N.%j.out
#SBATCH -e roary.%N.%j.err

#Run roary for pangenome analysis using .gff files as input
roary -p $SLURM_NTASKS -o {1} -i 90 -e --mafft --dont_delete_files -v *.gff

#Using SNP-sites to extract only polymorphic sites from a Roary output file
snp-sites -o SNPs.fasta -c core_gene_alignment.aln

#Run IQ tree to create phylogeny form the output of previous command 
#SNP/Ascertainment bias correction with IQ-TREE and automatic model selection (this method is almost as accurate as RAxML as less computationally taxing) - bootstrapping can be added as well
iqtree -s SNPs.fasta -m MFP+ASC -nt AUTO
