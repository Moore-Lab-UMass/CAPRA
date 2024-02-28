#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./1_Extract-Fragments.sh 

workingDir=/tmp/JEM
dataDir=~/scratch/Results
list=~/GitHub/CAPRA/Input-Data/STARR-BAM-List.txt
ccre=~/GitHub/CAPRA/Input-Data/GRCh38-cCREs.bed
pairs=~/GitHub/CAPRA/Input-Data/GRCh38-cCRE-Adjacent-Pairs.bed
outputDir=~/scratch/Results
exp=ENCSR661FOW

mkdir -p $workingDir
cd $workingDir
mkdir -p $outputDir

dna=$(awk -F "\t" '{if ($1 == "'$exp'") print $8}' $list | \
	awk -F ";" '{printf "%s", $1; for(i=2;i<=NF;i+=1) printf " %s", $i; print ""}')

rna=$(awk -F "\t" '{if ($1 == "'$exp'") print $7}'  $list | \
	awk -F ";" '{printf "%s", $1; for(i=2;i<=NF;i+=1) printf " %s", $i; print ""}')


echo "Begining solo fragment analysis ..."

sort -k4,4 $ccre | awk 'BEGIN{print "rdhs"}{print $4}' > tmp.matrix

echo -e "\t" "Running DNA fragment intersections ..."
for d in ${dna[@]}
do
    echo $d
    dnaBed=$dataDir/$d.bed
    bedtools intersect -c -a $dnaBed -b $ccre > tmp.1
    awk '{if ($NF == 1) print $0}' tmp.1 > tmp.2
    bedtools intersect -f 1 -c -a $ccre -b tmp.2 > tmp.col
    sort -k4,4 tmp.col | awk 'BEGIN{print "DNA"}{print $NF}' | paste tmp.matrix - > tmp.tmp
    mv tmp.tmp tmp.matrix
done

echo -e "\t" "Running RNA fragment intersections ..."
for r in ${rna[@]}
do
	echo $r
    rnaBed=$dataDir/$r.bed
    bedtools intersect -c -a $rnaBed -b $ccre > tmp.1
    awk '{if ($NF == 1) print $0}' tmp.1 > tmp.2
    bedtools intersect -f 1 -c -a $ccre -b tmp.2 > tmp.col
    sort -k4,4 tmp.col | awk 'BEGIN{print "RNA"}{print $NF}' | paste tmp.matrix - > tmp.tmp
    mv tmp.tmp tmp.matrix
done

awk '{if (NR == 1 || $2 > 0) print $0}' tmp.matrix > $outputDir/$exp-Matrix.Solo-Filtered.V7.txt
rm tmp.*


echo "Begining double fragment analysis ..."

sort -k4,4 $pairs | awk 'BEGIN{print "rdhs"}{print $4}' > tmp.matrix

echo -e "\t" "Running DNA fragment intersections ..."
for d in ${dna[@]}
do
    echo $d
    dnaBed=$dataDir/$d.bed
    bedtools intersect -c -a $dnaBed -b $ccre > tmp.1
    awk '{if ($NF == 2) print $0}' tmp.1 > tmp.2
    bedtools intersect -F 1 -c -a tmp.2 -b $ccre > tmp.3
    awk '{if ($NF == 2) print $0}' tmp.3 > tmp.4
    bedtools intersect -f 1 -c -a $pairs -b tmp.4 > tmp.col
    sort -k4,4 tmp.col | awk 'BEGIN{print "DNA"}{print $NF}' | paste tmp.matrix - > tmp.tmp
    mv tmp.tmp tmp.matrix
done

echo -e "\t" "Running RNA fragment intersections ..."
for r in ${rna[@]}
do
    echo $r
    rnaBed=$dataDir/$r.bed
    bedtools intersect -c -a $rnaBed -b $ccre > tmp.1
    awk '{if ($NF == 2) print $0}' tmp.1 > tmp.2
    bedtools intersect -F 1 -c -a tmp.2 -b $ccre > tmp.3
    awk '{if ($NF == 2) print $0}' tmp.3 > tmp.4
    bedtools intersect -f 1 -c -a $pairs -b tmp.4 > tmp.col
    sort -k4,4 tmp.col | awk 'BEGIN{print "RNA"}{print $NF}' | paste tmp.matrix - > tmp.tmp
    mv tmp.tmp tmp.matrix
done

awk '{if (NR == 1 || $2 > 0) print $0}' tmp.matrix > $outputDir/$exp-Matrix.Double-Pair.V7.txt
rm tmp.*

cd
rm -r /tmp/JEM

