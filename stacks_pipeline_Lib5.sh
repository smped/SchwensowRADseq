#!/bin/sh

# This job's working directory
MAINDIR=~/Documents/SchwensowBGI
echo Working directory is $MAINDIR
cd $MAINDIR
echo Start time is `date`

# The library number
CURLIB=Lib5
# The directory the samples are in
SUBDIR=BGI/Orcu-5
cd ${MAINDIR}/${SUBDIR}

# The paired files
F1=$(basename $(find -name '*1.fq.gz'))
F2=$(basename $(find -name '*2.fq.gz'))

# Back to the main directory
cd ${MAINDIR}

OUTDIR=stacks/samples/$CURLIB
# Create the output directory if required
if [ ! -d ${OUTDIR} ];
  then mkdir ${OUTDIR}
  echo Created Directory ${OUTDIR}
fi

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
    -1 ${SUBDIR}/${F1} \
    -2 ${SUBDIR}/${F2} \
    -o ${OUTDIR} \
    -b barcodes/barcodes.${b}.txt \
    -e pstI -E phred64 -r -q -s 20 -t 91 -c -i gzfastq 
  mv ${OUTDIR}/process_radtags.log stacks/processLogs/${CURLIB}.process_radtags.${b}.log
done

###############################
# Renaming sample FASTQ files #
###############################

# Rename the samples from each library from the barcodes to the sample name
while read NAME BARCODE
do
  mv ${OUTDIR}/sample_${BARCODE}.1.fq stacks/samples/${NAME}.${CURLIB}.1.fq
  mv ${OUTDIR}/sample_${BARCODE}.2.fq stacks/samples/${NAME}.${CURLIB}.2.fq
done < barcodes/rename.${CURLIB}.txt

# all done :)
echo End time is `date`
