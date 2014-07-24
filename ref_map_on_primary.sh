#!/bin/bash

ST=`date`
echo Process commenced at ${ST}

## Set the fs variables									
OUTDIR=~/Documents/SchwensowBGI/stacks/stacks			
BAMDIR=~/Documents/SchwensowBGI/bwa/mem/bam_M  
PRIMDIR=~/Documents/SchwensowBGI/bwa/mem/primaryAlignments
POPMAP=~/Documents/SchwensowBGI/pop_map	

WD=$(pwd)			
cd ${BAMDIR}
echo Getting file list from ${BAMDIR}					
FILES=$(ls)

## Extract only the primary alignments, mapped in proper pairs
## This can be less stringent later if we feel we have
## lost too much information
for f in ${FILES}												
    do														
	echo "Current filename is ${f}"
	## Extract only the alignments which are the primary alignment
	## & send to a .bam file with a simple name	
	## that matches the population map
	SHORTNAME=`echo ${f} | cut -d'.' -f 1`
	echo "Writing primary paired alignments to ${PRIMDIR}/${SHORTNAME}.bam"
	## The flags are "include (f) only those primary reads mapped in proper pairs" 
	## & exclude (F) the unmapped reads & secondary alignments
	samtools view -f2 -F256 -F4 -b ${BAMDIR}/${f} > ${PRIMDIR}/${SHORTNAME}.bam
    done
echo All files have been filtered.

## First collect the array of filenames & prefix every
## one with the "-s " tag.
cd ${PRIMDIR}
ALLFILES=$(for f in $(ls); do echo "-s ${PRIMDIR}/${f}"; done)
echo ${ALLFILES}

## Now run the pipeline on the complete batch
echo "Running ref_map on entire set of primary alignments"
ref_map.pl -T 20 -S -m 10 -b 1 \
 -O ${POPMAP} \
 -o ${OUTDIR} \
 ${ALLFILES}

echo Process commenced at ${ST}
echo Process completed at `date`
