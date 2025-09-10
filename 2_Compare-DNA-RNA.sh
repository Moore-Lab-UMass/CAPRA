#!/bin/bash

#Jill Moore
#Moore Lab - UMass Chan
#December 2024

#Usage: ./2_Compare-DNA-RNA.sh

workingDir=~/Lab/scratch/Results
scriptDir=~/GitHub/CAPRA/Toolkit
exp=ENCSR661FOW

cd $workingDir

Rscript $scriptDir/capra-deseq.R $exp-Matrix.Solo-Filtered.txt 1 3
Rscript $scriptDir/capra-deseq.R $exp-Matrix.Double-Pair.txt 1 3

