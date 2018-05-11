# ENIGMA2 GWAS Gentic Pipeline
This is a review of the ENIGMA2 Project in genetics. More information can be found at: [http://enigma.ini.usc.edu/protocols/genetics-protocols/](http://enigma.ini.usc.edu/protocols/genetics-protocols/). This review is base on the Cookbook: [Imputation Protocol](http://enigma.ini.usc.edu/wp-content/uploads/2012/07/ENIGMA2_1KGP_cookbook_v3.pdf)

## Getting the data
This pipeline was tested on the most recent versions of the 1KGP reference set (phase 1 release v3).
The data can be downloaded as follow:

	wget "http://enigma.ini.usc.edu/wp-content/uploads/2012/07/HM3.bed.gz"
	wget "http://enigma.ini.usc.edu/wp-content/uploads/2012/07/HM3.bim.gz"
	wget "http://enigma.ini.usc.edu/wp-content/uploads/2012/07/HM3.fam.gz"

## Converting the data using Plink
Plink is a software for processing genetic data. It can be downloaded at: [http://zzz.bwh.harvard.edu/plink/](http://zzz.bwh.harvard.edu/plink/). Can be locally stored and used.

For processing the data with the criteria mentioned by ENIGMA2, you muct follow (Example):
	
	/home/ssilvari/plink/plink --bfile /data/epione/user/ssilvari/enigma/genetics/HM3 --hwe 1e-6 --geno 0.05 --maf 0.01 --noweb --make-bed --out /data/epione/user/ssilvari/enigma/genetics_filtered/HM3

Unzip the HM3 genotypes. Prepare the HM3 and the raw genotype data by extracting only snps that are in common between the two genotype data sets ? this avoids exhausting the system memory. We are also removing the strand ambiguous snps from the genotyped data set to avoid strand mismatch among these snps. Your genotype files should be filtered to remove markers which do not satisfy the quality control criteria above.

Create an environment variable with the name of the datafile so things get easier
	
	export datafile=HM3

Get the labels (names located in column 2) of the SNPs

	awk '{print $2}' HM3.bim > HM3.snplist.txt

Do something I still do not understand:

	/home/ssilvari/plink/plink --bfile HM3 --extract HM3.snplist.txt --make-bed --noweb --out local

Antother weird step:

	awk '{if(($5=="T" && $6=="A")||($5=="A" && $6=="T")||($5=="C" && $6=="G")||($5=="G" && $6=="C")) print $2, "ambig" ; else print $2 ;}' $datafile.bim | grep -v ambig > local.snplist.txt

