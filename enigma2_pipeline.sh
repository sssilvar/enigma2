#!/bin/bash

# Set up parameters
WORKDIR=/data/epione/user/ssilvari/enigma/enigma2_test
RAW_FILE=HM3

# Other params
RAW_FILE=${WORKDIR}/${RAW_FILE}
PLINK=/home/ssilvari/plink/plink
FILTERED_FILE=${RAW_FILE}_filtered
LOCAL_FILE=${WORKDIR}/local
EXTERNAL_FILE=${WORKDIR}/external
MERGED_FILE=${RAW_FILE}"merge"
MDS_FILE=${RAW_FILE}"mds"

# Filter data that do not pass the Quality Control criteria
CMD=${PLINK}" --bfile "${RAW_FILE}" --hwe 1e-6 --geno 0.05 --maf 0.01 --noweb --make-bed --out "${FILTERED_FILE}
echo -e "\n\n[  OK  ] Filter data by QC criteria"
eval $CMD

# Get the labels (names located in column 2) of the SNPs
CMD="awk '{print \$2}' "${RAW_FILE}".bim > "${RAW_FILE}".snplist.txt"
eval $CMD

CMD=${PLINK}" --bfile "${FILTERED_FILE}" --extract "${RAW_FILE}".snplist.txt --make-bed --noweb --out "${LOCAL_FILE}
eval $CMD

CMD="awk '{if((\$5=="T" && \$6=="A")||(\$5=="A" && \$6=="T")||(\$5=="C" && \$6=="G")||(\$5=="G" && \$6=="C")) print \$2, "ambig" ; else print \$2 ;}' "$FILTERED_FILE".bim | grep -v ambig > "${LOCAL_FILE}".snplist.txt"
eval $CMD

CMD=${PLINK}" --bfile "$RAW_FILE" --extract "${LOCAL_FILE}".snplist.txt --make-bed --noweb --out "${EXTERNAL_FILE}
eval $CMD

# Merge the two sets of plink files – In merging the two files plink will check for strand differences.
# If any strand differences are found plink will crash with the following error (ERROR: Stopping due to
# mismatching SNPs ?? check +/? strand?) Ignore warnings regarding different physical positions
CMD=${PLINK}" --bfile "${LOCAL_FILE}" --bmerge "${EXTERNAL_FILE}".bed "${EXTERNAL_FILE}".bim "${EXTERNAL_FILE}".fam --make-bed --noweb --out "${MERGED_FILE}
eval $CMD

# Run the MDS analysis --- this step will take a while (approx. 1 day)
CMD=${PLINK}" --bfile "$MERGED_FILE" --cluster --mind 0.5 --mds-plot 4 --extract "${LOCAL_FILE}".snplist.txt --noweb --out "${MDS_FILE}
eval $CMD

# Plot the MDS results using R into a file called mdsplot.eps and mdsplot.pdf (Note: type R to start R
# in unix and q() followed by n to close the R session after the plot has been made)
CMD="awk 'BEGIN{OFS=\",\"};{print \$1, \$2, \$3, \$4, \$5, \$6, \$7}' >> "${MDS_FILE}"2R.mds.csv "${MDS_FILE}".mds"
eval $CMD

