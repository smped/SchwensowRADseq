#!/bin/sh

## This will: 
## 1 - Download the genome from the NCBI website
## 2 - Extract & build a single genome file
## 3 - Build an index for BWA

## Dependencies are 'bwa' & 'wget'. (The latter should be installed on most machines.)

## Set the key variables
ROOTDIR=~/
NCBI=ftp.ncbi.nlm.nih.gov
echo Start time is `date`
echo Current directory is ${ROOTDIR}

## Make the directory if required
if [ -d ${ROOTDIR}/genomes ];
  then
    echo Directory ${ROOTDIR}/genomes already exists
  else
    echo Creating directory ${ROOTDIR}/genomes
    mkdir ${ROOTDIR}/genomes
fi
cd ${ROOTDIR}/genomes

## Download using wget. This will mirror the ftp structure. NB this was done externally to this script
## This section wold be a method for automating it within this script.
## wget -m 'ftp://${NCBI}/genomes/Oryctolagus_cuniculus/Assembled_chromosomes/seq/ocu_ref_OryCun2.0_*.mfa.gz'
## FULLPATH=${ROOTDIR}/genomes/${NCBI}/genomes/Oryctolagus_cuniculus/Assembled_chromosomes/seq
## echo All files downloaded to ${FULLPATH}

## Gunzip & concatenate into a single genome in the main genomes folder.
##echo Unzipping files...
##gunzip ${FULLPATH}/ocu_ref_OryCun2.0*.mfa.gz
## (Also done externally)
FULLPATH=${ROOTDIR}/genomes/Oryctolagus_cuniculus/Assembled_chromosomes/seq
echo Concatenating files into ${ROOTDIR}/genomes/wgOryCun2.0.mfa...
cat ${FULLPATH}/*.mfa > ${ROOTDIR}/genomes/wgOryCun2.0.mfa
echo Done

## Build the index
echo Changing directory to ${ROOTDIR}/genomes
cd ${ROOTDIR}/genomes
echo Building index with prefix oc2_bwa_idx...
bwa index -p oc2_bwa_idx -a bwtsw wgOryCun2.0.mfa
echo Done
echo Completion time was `date`

