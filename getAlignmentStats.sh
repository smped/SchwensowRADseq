#!/bin/bash

## In this script we will search through every aligned file
## in the bam_M folder & count:
## 1 - the total number of reads (nr)
## 2 - the primary reads for pairs which have mapped correctly (npm)
## 3 - the number of "not primary" alignments (npa) &
## 4 - the number of unmapped reads (nu)

BAMDIR=~/Documents/SchwensowBGI/bwa/mem/bam_M
cd ${BAMDIR}
FILES=$(ls)

echo "sample total_reads primary_mapped_in_proper_pair reads_unmapped not_primary_alignment"
for f in ${FILES}
do 
    SAMPLE=`echo ${f} | cut -d'.' -f 1`
    nr=$(samtools view -c ${f})
    npm=$(samtools view -f2 -F256 -c ${f})
    nu=$(samtools view -f4 -c ${f})
    npa=$(samtools view -f256 -c ${f})
    echo ${SAMPLE} ${nr} ${npm} ${nu} ${npa}
done

## This script should be output to a file