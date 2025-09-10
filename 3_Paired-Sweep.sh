
#Jill Moore
#Moore Lab - UMass Chan
#June 2025

#Usage: ./3_Paired-Sweep.sh cCRE-Pair.bed

ccrePair=$1

inputData=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Data/ENCSR661FOW
dna=$inputData/ENCFF778LRW.bed
rna1=$inputData/ENCFF692WJN.bed
rna2=$inputData/ENCFF058NAC.bed
rna3=$inputData/ENCFF294XNE.bed

id1=$(head -n 1 $ccrePair | awk '{print $5}')
id2=$(tail -n 1 $ccrePair | awk '{print $5}')

dnaTotal=$(wc -l $dna | awk '{print $1}')
rna1Total=$(wc -l $rna1 | awk '{print $1}')
rna2Total=$(wc -l $rna2 | awk '{print $1}')
rna3Total=$(wc -l $rna3 | awk '{print $1}')

chrom=$(head -n 1 $ccrePair | awk '{print $1}')
start=$(head -n 1 $ccrePair | awk '{print $2}')
stop=$(tail -n 1 $ccrePair | awk '{print $3}')

for j in `seq $start 10 $stop`; do     awk 'BEGIN{print "'$chrom'" "\t" '$j' "\t" '$j'+10 "\t" "Region-'$j'"}'; done > 10bp.bed

head -n 1 $ccrePair | bedtools intersect -u -F 1 -a $dna -b stdin > dna.1bed
head -n 1 $ccrePair | bedtools intersect -u -F 1 -a $rna1 -b stdin > rna1.1bed
head -n 1 $ccrePair | bedtools intersect -u -F 1 -a $rna2 -b stdin > rna2.1bed
head -n 1 $ccrePair | bedtools intersect -u -F 1 -a $rna3 -b stdin > rna3.1bed

bedtools intersect -c -a 10bp.bed -b dna.1bed | awk '{print $0 "\t" $NF/'$dnaTotal'*1000000}' > tmp1.dna
bedtools intersect -c -a 10bp.bed -b rna1.1bed | awk '{print $0 "\t" $NF/'$rna1Total'*1000000}' > tmp1.rna1
bedtools intersect -c -a 10bp.bed -b rna2.1bed | awk '{print $0 "\t" $NF/'$rna2Total'*1000000}' > tmp1.rna2
bedtools intersect -c -a 10bp.bed -b rna3.1bed | awk '{print $0 "\t" $NF/'$rna3Total'*1000000}' > tmp1.rna3
  
paste tmp1.dna tmp1.rna1 tmp1.rna2 tmp1.rna3 | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $12 "\t" $18 "\t" $24}' > tmp1.summary


tail -n 1 $ccrePair | bedtools intersect -u -F 1 -a $dna -b stdin > dna.2bed
tail -n 1 $ccrePair | bedtools intersect -u -F 1 -a $rna1 -b stdin > rna1.2bed
tail -n 1 $ccrePair | bedtools intersect -u -F 1 -a $rna2 -b stdin > rna2.2bed
tail -n 1 $ccrePair | bedtools intersect -u -F 1 -a $rna3 -b stdin > rna3.2bed

bedtools intersect -c -a 10bp.bed -b dna.2bed | awk '{print $0 "\t" $NF/'$dnaTotal'*1000000}' > tmp2.dna
bedtools intersect -c -a 10bp.bed -b rna1.2bed | awk '{print $0 "\t" $NF/'$rna1Total'*1000000}' > tmp2.rna1
bedtools intersect -c -a 10bp.bed -b rna2.2bed | awk '{print $0 "\t" $NF/'$rna2Total'*1000000}' > tmp2.rna2
bedtools intersect -c -a 10bp.bed -b rna3.2bed | awk '{print $0 "\t" $NF/'$rna3Total'*1000000}' > tmp2.rna3
  
paste tmp2.dna tmp2.rna1 tmp2.rna2 tmp2.rna3 | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $12 "\t" $18 "\t" $24}' > tmp2.summary

mv tmp1.summary $id1"-"$id2.CAPRA-Sweep.txt
mv tmp2.summary $id2"-"$id1.CAPRA-Sweep.txt

rm tmp* *bed
