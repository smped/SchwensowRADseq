#!/bin/sh

WD=~/Documents/SchwensowBGI
cd ${WD}
echo Working directory is ${WD}
echo QC process begun `date`

find -name '*Lib*.fq' | xargs fastqc -o ${WD}/QC -t 20

echo QC process reports completed `date`

