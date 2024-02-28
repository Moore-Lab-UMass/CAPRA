# CAPRA
![image](https://github.com/Moore-Lab-UMass/CAPRA/assets/4357540/f0507fed-9121-40c8-b098-eab1e0f004a6)

CRE-centric Analysis and Prediction of Reporter Assays

## Step 0 - Pull and prep data from ENCODE portal

The initial step in the pipeline is to convert the STARR-seq BAM files to a BED files denoting the position of each of the fragments. This particular script will download BAM files from the ENCODE portal, sort them using BEDtools, convert to BEDPE files and then finally output a BED file for each input BAM.

`./0_Pull-and-Prep-Data.sh`

The input data format is detailed below and can be generated directly for ENCODE data using the script `pull-starr-bams.py` in the Bonus Scripts folder

| Exp ID      | Biosample | Lab | Description | Local file location | RNA BAMs | DNA BAMs |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
| ENCSR661FOW | K562  | Tim Reddy, Duke | NA | NA | ENCFF692WJN;ENCFF058NAC;ENCFF294XNE | ENCFF778LRW | 




## Step 1 - Extract overlapping fragments and create count matrix


## Step 2 - Run DESeq on matrices


## Step 3 - Compare solo and double quantifications
