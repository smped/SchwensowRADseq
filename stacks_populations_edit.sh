#!/bin/sh

# This job's working directory
WORKDIR=~/Documents/SchwensowBGI
echo Working directory is ${WORKDIR}
cd ${WORKDIR}
echo Start time is `date`

#Load module(s) if required
#module load application_module

# current Stacks version has a bug when calling populations...
populations -b 1 \
-M ${WORKDIR}/pop_map \
-P ${WORKDIR}/stacks/stacks/ \
-s -t 20 -m 10 -f p_value -k -r 0.75 

# all done :)
echo End time is `date`
 
