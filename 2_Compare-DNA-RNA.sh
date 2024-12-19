#Jill Moore
#Moore Lab - UMass Chan
#December 2024

#Usage: ./2_Compare-DNA-RNA.sh

workingDir=~/scratch/Results
exp=ENCSR661FOW

cd $workingDir

Rscript Toolkit/capra-deseq.R $exp-Matrix.Solo-Filtered.txt 1 3
Rscript Toolkit/capra-deseq.R $exp-Matrix.Double-Pair.txt 1 3

