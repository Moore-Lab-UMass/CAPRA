# CAPRA
![image](https://github.com/Moore-Lab-UMass/CAPRA/assets/4357540/f0507fed-9121-40c8-b098-eab1e0f004a6)

CRE-centric Analysis and Prediction of Reporter Assays

## Step 0 - Pull and prep data from ENCODE portal

The initial step converts STARR-seq BAM files to a BED files denoting the position of each of the fragments. This particular script will download BAM files from the ENCODE portal, sort them using BEDtools, convert to BEDPE files and then finally output a BED file for each input BAM.

**Input data:**
* List of STARR-seq experiments (e.g. [STARR-BAM-List.txt](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/STARR-BAM-List.txt.gz)) with the following format

| Exp ID      | Biosample | Lab | RNA BAMs | DNA BAMs |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| ENCSR661FOW | K562  | Tim Reddy, Duke | ENCFF692WJN;ENCFF058NAC;ENCFF294XNE | ENCFF778LRW | 


**Additional scripts:**
* [pull-starr-bams.py](https://github.com/Moore-Lab-UMass/CAPRA/blob/main/Toolkit/pull-starr-bams.py)

**Required software:**
* [BEDTools](https://bedtools.readthedocs.io/en/latest/) (verion 2.30.0 was used in [Moore...Weng (2024) *bioRxiv*](https://www.biorxiv.org/content/10.1101/2024.12.26.629296v1))


## Step 1 - Extract overlapping fragments and create count matrix
This step creates quantification matrices by intersecting the STARR-seq fragments with cCREs. All fragments that overlap one cCRE in its entirety count towards the "solo" quantifications. All fragments that overlap two cCREs in their entirety count towards the "double" quantifications. Script will output a matrix with rDHS ID in the first column followed by DNA fragment counts then RNA fragment counts.

**Input data:**
* Fragment BED files from **Step 1**
* [GRCh38 cCREs](https://users.moore-lab.org/ENCODE-cCREs/Supplementary-Data/Supplementary-Data-1.GRCh38-cCREs-V4.bed.gz)
* [GRCh38 cCRE pairs](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/GRCh38-cCRE-Adjacent-Pairs.bed.gz)

**Required software:**
* [BEDTools](https://bedtools.readthedocs.io/en/latest/) (verion 2.30.0 was used in [Moore...Weng (2024) *bioRxiv*](https://www.biorxiv.org/content/10.1101/2024.12.26.629296v1))

## Step 2 - Run DESeq on matrices
This step calculates the normalized ratio of RNA to DNA fragments and statistical significance for each cCRE using DESeq2

**Input data:**
* Quantification matrices from **Step 2**

**Additional scripts:**
* [capra-deseq.R](https://github.com/Moore-Lab-UMass/CAPRA/blob/main/Toolkit/capra-deseq.R)

**Required software:**
* R (version 4.2.3 was used in [Moore...Weng (2024) *bioRxiv*](https://www.biorxiv.org/content/10.1101/2024.12.26.629296v1))
* DESeq2 (version 1.38.0 was used in [Moore...Weng (2024) *bioRxiv*](https://www.biorxiv.org/content/10.1101/2024.12.26.629296v1))

*Note - different versions of R and DESeq2 may produce slightly different quantifcation values*

