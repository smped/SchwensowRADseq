#!/bin/sh

# This job's working directory
WORKDIR=~/Documents/SchwensowBGI
echo Working directory is $WORKDIR
cd $WORKDIR
echo Start time is `date`

CURLIB=Lib1

####################
# Splitting and QC #
####################

# -r: recover barcodes and restriction sites (with single errors)
# -q: discard reads with low quality
# -s: quality score threshold to discard reads
# -t: truncate reads to specified length\
# -i: file type of input data ("gzfastq" means gzip'ed FASTQ)
# -c: remove all reads with uncalled bases

for b in 4 5 6 7 8 9
do
  process_radtags \
    -1 BGI/Orcu-1/FCC229TACXX-CHKPEI13070001_L3_1.fq.gz \
    -2 BGI/Orcu-1/FCC229TACXX-CHKPEI13070001_L3_2.fq.gz \
    -o stacks/samples/${CURLIB} \
    -b barcodes/barcodes.$b.txt \
    -e pstI -E phred64 -r -q -s 20 -t 91 -c -i gzfastq 
  mv stacks/samples/${CURLIB}/process_radtags.log stacks/processLogs/${CURLIB}.process_radtags.$b.log
done

###############################
# Renaming sample FASTQ files #
###############################

# Rename the samples from each library from the barcodes to the sample name
while read NAME BARCODE
do
  mv stacks/samples/${CURLIB}/sample_${BARCODE}.1.fq stacks/samples/${NAME}.${CURLIB}.1.fq
  mv stacks/samples/${CURLIB}/sample_${BARCODE}.2.fq stacks/samples/${NAME}.${CURLIB}.2.fq
done < barcodes/rename.${CURLIB}.txt

echo `date`

# all done :)
echo End time is `date`
