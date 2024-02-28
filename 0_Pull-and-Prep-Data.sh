#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./0_Pull-and-Prep-Data.sh

workingDir=/tmp/JEM
outputDir=~/scratch/Results/

mkdir -p $workingDir
cd $workingDir

dataDir=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Data
list=~/GitHub/CAPRA/Input-Data/STARR-BAM-List.txt

k=$(wc -l $list | awk '{print $1}')

for j in `seq 1 1 $k`
do
    exp=$(awk -F "\t" '{if (NR == '$j') print $1}'  $list)
    lab=$(awk -F "\t" '{if (NR == '$j') print $4}'  $list)
    expDir=$dataDir/$exp

    dna=$(awk -F "\t" '{if (NR == '$j') print $8}'  $list | \
        awk -F ";" '{printf "%s", $1; for(i=2;i<=NF;i+=1) printf " %s", $i; print ""}')
    rna=$(awk -F "\t" '{if (NR == '$j') print $7}'  $list | \
        awk -F ";" '{printf "%s", $1; for(i=2;i<=NF;i+=1) printf " %s", $i; print ""}')
        
    for bam in ${dna[@]}
    do
        echo -e "\t" $bam
        wget https://www.encodeproject.org/files/$bam/@@download/$bam.bam
        samtools sort -n -@ 16 -o $bam.sorted.bam $bam.bam
        bedtools bamtobed -bedpe -i $bam.sorted.bam > $bam.bedpe
        cp $bam.bedpe $outputDir/
        awk '{print $1 "\t" $2 "\t" $6 "\t" $7}' $bam.bedpe > $bam.bed
        cp $bam.bed $outputDir
        rm $bam.bed $bam.bedpe $bam.sorted.bam
    done
        
    for bam in ${rna[@]}
    do
        echo -e "\t" $bam
        wget https://www.encodeproject.org/files/$bam/@@download/$bam.bam
        samtools sort -n -@ 16 -o $bam.sorted.bam $bam.bam
        bedtools bamtobed -bedpe -i $bam.sorted.bam > $bam.bedpe
        cp $bam.bedpe $outputDir
        awk '{print $1 "\t" $2 "\t" $6 "\t" $7}' $bam.bedpe > $bam.bed
        cp $bam.bed $outputDir
        rm $bam.bed $bam.bedpe $bam.sorted.bam $bam.bam
    done
done
