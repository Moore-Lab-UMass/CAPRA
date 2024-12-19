#Jill Moore
#Moore Lab - UMass Chan
#December 2024

#Usage: Rscript capra-deseq.R {input} {# dna} {# rna}

library(DESeq2)
library(stringr)

args = commandArgs(trailingOnly=TRUE)
inputData = args[1]
outputData = str_replace(inputData, "Matrix", "DESeq2")
dnaCol = args[2]
rnaCol = args[3]

d = read.table(inputData, header=T, sep="\t", row.names=1)
metadata = c(rep("dna", dnaCol), rep("rna", rnaCol))
meta = data.frame(metadata) 
names(meta)=c("assay")
row.names(meta)=names(d)

dds = DESeqDataSetFromMatrix(countData = d, colData = meta, design= ~ assay)
dds = DESeq(dds, betaPrior=TRUE)
res = results(dds)

write.table(res, outputData, sep="\t", quote=F)
