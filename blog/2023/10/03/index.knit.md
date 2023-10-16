---
title: "Learning scRNA-seq data analysis using Seurat package"
date: 2023-09-13
date-modified: last-modified
categories:
  - scRNA-seq
# image: workflow.png
image: scRNAseq.png
draft: true
execute: 
  freeze: true
  # echo: false
  warning: false
  # eval: false
---




## Preparing reference files for scRNA-seq

```bash
### create conda env for mapping reads
conda create --name kb
conda activate kb
pip install kb-python
```

```bash
### navigate to directory and active kb environment 230907_DIY_Transcriptomics/data/pbmc_1k_raw
kb ref -d human -i Homo_sapiens.GRCh38.cdna.all.index -g t2g.txt
```
![](scRNAseq1.png)

## Mapping reads for scRNA-seq data

```bash
kb count pbmc_1k_v3_S1_mergedLanes_R1.fastq.gz pbmc_1k_v3_S1_mergedLanes_R2.fastq.gz -i Homo_sapiens.GRCh38.cdna.all.index -x 10XV3 -g t2g.txt -t 8 --cellranger
```
![](scRNAseq2.png)

## Imporing data into R























