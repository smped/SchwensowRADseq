#!/bin/sh

# Set the working directory
WD=~/Documents/SchwensowBGI/QC
cd ${WD}
echo Current working directory is ${WD}

# Create the directory if it's not already there
OUTDIR=${WD}/PBQ_Images
if [ -d ${OUTDIR} ];
  then
    echo Directory ${OUTDIR} already exists
  else
    echo Creating directory ${OUTDIR}
    mkdir ${OUTDIR}    
fi

# Form a file with the names of the zipfiles
echo Writing zipfiles.txt
find *.zip > zipfiles.txt

# The image we want will match the string
IM=*/per_base_qual*

# Read in each zipfile & extract the PBQ image
while read NAME
do 
  SHORTNAME=$(basename ${NAME} .zip)
  echo Extracting image from ${NAME}...
  unzip -o ${NAME} ${IM}
  mv ${WD}/${SHORTNAME}/Images/per_base_quality.png ${OUTDIR}/${SHORTNAME}.PBQ.png
  echo Removing directory ${WD}/${SHORTNAME}/Images...
  rmdir ${WD}/${SHORTNAME}/Images
  echo Removing directory ${WD}/${SHORTNAME}...
  rmdir ${WD}/${SHORTNAME}
  echo Done
done < zipfiles.txt

