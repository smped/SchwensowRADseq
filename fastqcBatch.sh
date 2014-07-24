#!/bin/sh

WD=~/Documents/SchwensowBGI 
cd ${WD}
echo Working directory is ${WD}
echo QC process begun `date`
# Note, there are 14 files, so 14 threads were requested...(-t 14)
# Otherwise this would run them all in series
find -name '*fq.gz' | xargs fastqc -o ${WD}/QC -t 14
echo QC process reports completed `date`

