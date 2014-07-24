#!/bin/sh

## This script will:
## Rename paired sequences so that bwa mem will handle the paired names

## Where the samples are
FILEDIR=~/Documents/SchwensowBGI/stacks/samples
OUTDIR=~/Documents/SchwensowBGI/rename
STARTPROC=`date`
echo Process started at ${STARTPROC}
echo Files are located in ${FILEDIR}
echo Renamed files will be written to ${OUTDIR}

cd ${FILEDIR}
while read NAME
do
  echo Renaming sequences from ${NAME}
  /etc/bbmap/bbrename.sh \
  in=${NAME}.1.fq in2=${NAME}.2.fq \
  out=${OUTDIR}/${NAME}.rename.1.fq out2=${OUTDIR}/${NAME}.rename.2.fq \
  prefix=${NAME}
done < sampleNames.txt

echo Process begun at ${STARTPROC}
echo Process completed at `date`



