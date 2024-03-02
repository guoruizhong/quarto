#
#
#
#
#
#
#
#
#
#
#
knitr::opts_chunk$set(
    # fig.width = 6, 
    # fig.height = 3.8,
    fig.align = "center", 
    # fig.retina = 3,
    out.width = "100%", 
    warning = FALSE,
    # evaluate = FALSE,
    collapse = TRUE
)
#
#
#
#
#| warning: false

# Library packages
library(here)
library(tidyverse)
library(Seurat)
library(SingleR)
library(ggrepel)
library(patchwork)

# Load PBMC dataset
pbmc_data <- Read10X(data.dir = "./projects/pbmc3k/hg19/")

# Initialize the seurat boject witht raw (non-normalized data)
pbmc <- CreateSeuratObject(
    counts = pbmc_data, project = "pbmc3k", min.cells = 3, min.features = 200
)
# View the data
pbmc
dim(pbmc_data)

# Example a few genes in the first thirty cells
pbmc_data[c("CD3D", "TCL1A", "MS4A1"), 1:30]
#
#
#
#
#
#
# The [[ operator can add columns to object metadata. This is a great place to stash QC stats
pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")

# Show QC metrics for the first 5 cells
head(pbmc@meta.data, 5)

# Visualize QC metrics as a violin plot
VlnPlot(pbmc, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

# FeatureScatter is typically used to visualize feature-feature relationships, but can be used
# for anything calculated by the object, i.e. columns in object metadata, PC scores etc.
plot1 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "percent.mt")
plot2 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
plot1 + plot2

pbmc <- subset(pbmc, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)
#
#
#
#
#
pbmc <- NormalizeData(pbmc, normalization.method = "LogNormalize", scale.factor = 10000)
# pbmc <- NormalizeData(pbmc)
# pbmc@assays$RNA@counts is the raw count data
str(pbmc)

# Simply look at the data after normalization
# par(mfrow = c(1,2))
# hist(colSums(pbmc$RNA@counts@i),breaks = 50)
# hist(colSums(pbmc$RNA@data@i),breaks = 50)
#
#
#
#
pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)

# Identify the 10 most highly variable genes
top10 <- head(VariableFeatures(pbmc), 10)

# Plot variable features with and without labels
plot1 <- VariableFeaturePlot(pbmc)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
plot1 + plot2
```
#
#
#
all_genes <- rownames(pbmc)
pbmc <- ScaleData(pbmc, features = all_genes)
# Remove unwanted sources of variation
# pbmc <- ScaleData(pbmc, vars.to.regress = "percent.mt")
#
#
#
#
#
#
pbmc <- RunPCA(pbmc, features = VariableFeatures(object = pbmc))
# Examine and visualize PCA results a few different ways
print(pbmc[["pca"]], dims = 1:5, nfeatures = 5)
```
#
#
#
VizDimLoadings(
    pbmc, dims = 1:2, 
    nfeatures = 20,
    reduction = "pca"
)
# PCA dotplot
DimPlot(pbmc, reduction = "pca") + NoLegend()

# PCA heatmap
DimHeatmap(pbmc, dims = 1, cells = 500, balanced = TRUE)
DimHeatmap(pbmc, dims = 1:15, cells = 500, balanced = TRUE)
```
#
#
#
#
# NOTE: This process can take a long time for big datasets, comment out for expediency. More
# approximate techniques such as those implemented in ElbowPlot() can be used to reduce

# Computation time
pbmc <- JackStraw(pbmc, num.replicate = 100)
pbmc <- ScoreJackStraw(pbmc, dims = 1:20)

JackStrawPlot(pbmc, dims = 1:15)
#
#
#
#
#
ElbowPlot(pbmc)
#
#
#
#
#
# Returns a set of genes, based on the JackStraw analysis, that have statistically significant associations with a set of PCs.
# ?PCASigGenes
head(PCASigGenes(pbmc,pcs.use=2,pval.cut = 0.7))
```
#
#
#
pbmc <- FindNeighbors(pbmc, dims = 1:10)
pbmc <- FindClusters(pbmc, resolution = 0.5)

# Look at cluster IDs of the first 5 cells
head(Idents(pbmc), 5)

# Look at the cells of specific cluster
head(subset(as.data.frame(pbmc@active.ident),pbmc@active.ident=="2"))

# Retrieve the cells of a cluster
subpbmc <- subset(x = pbmc,idents="2")
subpbmc
head(subpbmc@active.ident,5)
#
#
#
#
#
#
#
# If you haven't installed UMAP, you can do so via 
reticulate::py_install(packages = "umap-learn")

pbmc <- RunUMAP(pbmc, dims = 1:10)

# Note that you can set `label = TRUE` or use the LabelClusters function to help label
# Individual clusters
DimPlot(pbmc, reduction = "umap")
#
#
#
#
#
pbmc <- RunTSNE(pbmc, dims = 1:10)

head(pbmc@reductions$tsne@cell.embeddings)

DimPlot(pbmc, reduction = "tsne")
```
#
#
#
# Note that you can set `label = TRUE` or use the LabelClusters function to help label
# Individual clusters
plot1 <- DimPlot(pbmc, reduction = "umap", label = TRUE)
plot2 <- DimPlot(pbmc, reduction = "tsne", label = TRUE)
plot1 + plot2
#
#
#
#
#
#
#
# Find all markers of cluster 2
cluster2_markers <- FindMarkers(pbmc, ident.1 = 2)
head(cluster2_markers, n = 5)

# Find all markers distinguishing cluster 5 from clusters 0 and 3
cluster5_markers <- FindMarkers(pbmc, ident.1 = 5, ident.2 = c(0, 3))
head(cluster5_markers, n = 5)

# Find markers for every cluster compared to all remaining cells, report only the positive ones
pbmc_markers <- FindAllMarkers(pbmc, only.pos = TRUE)
pbmc_markers %>%
    group_by(cluster) %>%
    dplyr::filter(avg_log2FC > 1)
# ?FindAllMarkers

cluster0_markers <- FindMarkers(
    pbmc, ident.1 = 0, logfc.threshold = 0.25, test.use = "roc", 
    only.pos = TRUE
)
```
#
#
#
#
### Show expression probability distributions across clusters
VlnPlot(pbmc, features = c("MS4A1", "CD79A"))
# You can plot raw counts as well
VlnPlot(pbmc, features = c("NKG7", "PF4"), layer = "counts", log = TRUE)

# Visualizes feature expression on a tSNE or PCA plot
FeaturePlot(
    pbmc, features = c(
        "MS4A1", "GNLY", "CD3E", "CD14", "FCER1A", "FCGR3A", 
        "LYZ", "PPBP","CD8A"
    )
)

# Expression heatmap for given cells and features
top10 <- pbmc_markers %>%
    group_by(cluster) %>%
    top_n(n = 10, wt = avg_log2FC)
DoHeatmap(pbmc, features = top10$gene) + NoLegend()
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
new_cluster_ids <- c(
    "Naive CD4 T", "CD14+ Mono", "Memory CD4 T", "B", "CD8 T", "FCGR3A+ Mono","NK", "DC", "Platelet"
)
names(new_cluster_ids) <- levels(pbmc)
pbmc <- RenameIdents(pbmc, new_cluster_ids)
DimPlot(
    pbmc, reduction = "umap", label = TRUE, pt.size = 0.5
) + 
NoLegend()
#
#
#
