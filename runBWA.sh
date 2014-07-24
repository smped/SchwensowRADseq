#!/bin/sh

## This script will:
## 1 - Find the samples & export the list to a text file
## 2 - Run bwa mem on each sample

## Where the samples are
SAMPDIR=~/Documents/SchwensowBGI/rename
STARTPROC=`date`
echo "Process started at ${STARTPROC}"
echo "Samples are located in ${SAMPDIR}"

## Set & make the output directory if required
OUTDIR=~/Documents/SchwensowBGI/bwa/mem
if [ -d ${OUTDIR} ];
  then
    echo "Directory ${OUTDIR} already exists"
  else
    echo "Creating directory ${OUTDIR}"
    mkdir ${OUTDIR}
fi

## Where the index files are
PREFIX=~/genomes/oc2_bwa_idx
echo "Index files will be of the form ${PREFIX}.suffix"

cd ${SAMPDIR}
## Capture the first 4-6 characters, the dot, then Lib & a digit
echo "Writing to ${SAMPDIR}/sampleReNames.txt"
ls *.1.fq | grep -oP "^\w{4,6}\.Lib\d.rename" > ${SAMPDIR}/sampleReNames.txt

## Now run bwa mem on that set of files.
cd ${OUTDIR}
echo Running process using 20 threads
while read name
do
  ## 20 threads (-t 20) using PREFIX & then "reads.fq" & "mates.fq"
  ## Currently set for the second run using the M & H options
  echo "Aligning ${name}"
  bwa mem -M -t 20 ${PREFIX} ${SAMPDIR}/${name}.1.fq ${SAMPDIR}/${name}.2.fq > ${OUTDIR}/sam_M/${name}.mem.sam
  ## Also convert to bam files straight away.
  echo "Converting ${OUTDIR}/sam_M/${name}.mem.sam to a .bam file"
  samtools view -bSo ${OUTDIR}/bam_M/${name}.mem.bam ${OUTDIR}/sam_M/${name}.mem.sam
done < ${SAMPDIR}/sampleReNames.txt

echo "Process was commenced at ${STARTPROC}"
echo "Process was completed at `date`"

## That took about 8hrs

