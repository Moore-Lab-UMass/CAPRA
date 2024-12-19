# CAPRA
![image](https://github.com/Moore-Lab-UMass/CAPRA/assets/4357540/f0507fed-9121-40c8-b098-eab1e0f004a6)

CRE-centric Analysis and Prediction of Reporter Assays

## Step 0 - Pull and prep data from ENCODE portal

The initial step in the pipeline is to convert the STARR-seq BAM files to a BED files denoting the position of each of the fragments. This particular script will download BAM files from the ENCODE portal, sort them using BEDtools, convert to BEDPE files and then finally output a BED file for each input BAM.

`./0_Pull-and-Prep-Data.sh`

The input data format is detailed below and can be generated directly for ENCODE data using the script `pull-starr-bams.py` in the Bonus Scripts folder

| Exp ID      | Biosample | Lab | RNA BAMs | DNA BAMs |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| ENCSR661FOW | K562  | Tim Reddy, Duke | ENCFF692WJN;ENCFF058NAC;ENCFF294XNE | ENCFF778LRW | 



## Step 1 - Extract overlapping fragments and create count matrix

This step uses BEDTools to intersect the STARR-seq fragments with cCREs. All fragments that overlap one cCRE in its entirety count towards the "solo" quantifications. All fragments that overlap two cCREs in their entirety count towards the "double" quantifications. Script will output a matrix with rDHS ID in the first column followed by DNA fragment counts then RNA fragment counts.

`./1_Extract-Fragments.sh`


## Step 2 - Run DESeq on matrices


## Step 3 - Compare solo and double quantifications
