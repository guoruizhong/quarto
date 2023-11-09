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
#| echo: false
#| warning: false
#| message: false

# BiocManager::install("harmony", force = TRUE)
# if (!requireNamespace("BiocManager", quietly = TRUE))
#     install.packages("BiocManager")
# BiocManager::install("harmony", version = "3.8")
#  devtools::install_github('immunogenomics/harmony', force = TRUE)
# devtools::install_github("JEFworks/MUDAN")
colors_use <- c(`jurkat` = '#810F7C', `t293` = '#D09E2D',`half` = '#006D2C')
### function for plot
do_scatter <- function(umap_use, meta_data, label_name, no_guides = TRUE,
                       do_labels = TRUE, nice_names, 
                       palette_use = colors_use,
                       pt_size = 4, point_size = .5, base_size = 12, 
                       do_points = TRUE, do_density = FALSE, h = 6, w = 8) {
    umap_use <- umap_use[, 1:2]
    colnames(umap_use) <- c('X1', 'X2')
    plt_df <- umap_use %>% data.frame() %>% 
        cbind(meta_data) %>% 
        dplyr::sample_frac(1L) 
    plt_df$given_name <- plt_df[[label_name]]
    
    if (!missing(nice_names)) {
        plt_df %<>%
            dplyr::inner_join(nice_names, by = "given_name") %>% 
            subset(nice_name != "" & !is.na(nice_name))
        
        plt_df[[label_name]] <- plt_df$nice_name        
    }
    
    plt <- plt_df %>% 
        ggplot2::ggplot(aes_string("X1", "X2", col = label_name, fill = label_name)) + 
        theme_test(base_size = base_size) + 
        theme(panel.background = element_rect(fill = NA, color = "black")) + 
        guides(color = guide_legend(override.aes = list(stroke = 1, alpha = 1,
                                                        shape = 16, size = 4)), 
               alpha = FALSE) +
        scale_color_manual(values = palette_use) + 
        scale_fill_manual(values = palette_use) +    
        theme(plot.title = element_text(hjust = .5)) + 
        labs(x = "PC 1", y = "PC 2") 
    
    if (do_points) 
        plt <- plt + geom_point(shape = '.')
    if (do_density) 
        plt <- plt + geom_density_2d()    
    
    
    if (no_guides)
        plt <- plt + guides(col = FALSE, fill = FALSE, alpha = FALSE)
    
    if (do_labels) {
        data_labels <- plt_df %>% 
            dplyr::group_by_(label_name) %>% 
            dplyr::summarise(X1 = mean(X1), X2 = mean(X2)) %>% 
            dplyr::ungroup()
        
        plt <- plt + geom_label(data = data_labels, label.size = NA,
                        aes_string(label = label_name), 
                        color = "white", size = pt_size, alpha = 1,
                        segment.size = 0) +
                guides(col = FALSE, fill = FALSE)
    }
    
    return(plt)
}
###  library
library(harmony)
library(MUDAN)
library(Seurat)
library(tidyverse)
library(here)
library(cowplot)
```
#
#
#
#| warning: false
data(cell_lines)
scaled_pcs <- cell_lines$scaled_pcs
meta_data <- cell_lines$meta_data
### cells cluster by dataset initially
p1 <- do_scatter(scaled_pcs, meta_data, "dataset") +
    labs(title = "Colored by dataset")
p2 <- do_scatter(scaled_pcs, meta_data, "cell_type") +
    labs(title = "Colored by cell type")
### combine plot
cowplot::plot_grid(p1, p2)
#
#
#
#
#
#| warning: false
harmony_embeddings <- harmony::RunHarmony(
    scaled_pcs, meta_data, "dataset", verbose = FALSE
)
p1 <- do_scatter(harmony_embeddings, meta_data, "dataset") +
labs(title = "Colored by dataset")
p2 <- do_scatter(harmony_embeddings, meta_data, "cell_type") +
    labs(title = "Colored by cell type")
### combine plot
cowplot::plot_grid(p1, p2, nrow = 1)
```
#
#
#
#| eval: false
### get data
data("pbmcA")
data("pbmcB")
dim(pbmcA)
dim(pbmcB)

### downsize the number of cells in each PBMC dataset
pbmcA <- pbmcA[, 500] # take 500 cells
pbmcB <- pbmcB[, 2000] # take 500 cells
#
#
#
#
#
#| eval: false
### combine into one coutns matrix
genes_int <- intersect(rownames(pbmcA), rownames(pbmcB))
cd <- cbind(pbmcA[genes_int, ], pbmcB[genes_int, ])

### meta data
meta <- c(rep("pbmcA", ncol(pbmcA)), rep("pbmcB", ncol(pbmcB)))
names(meta) <- c(colnames(pbmcA), colnames(pbmcB))
meta <- factor(meta)

cd[1:5, 1:2]
meta[1:5]
```
#
#
#
#| eval: false
### CPM normalization
mat <- MUDAN::normalizeCounts(cd, verbose = FALSE)

### variance normalize, identify overdispersed genes
matnorm_info <- MUDAN::normalizeVariance(mat, details = TRUE, verbose = FALSE)

### log transform
matnorm <- log10(matnorm_info$mat + 1)

### 30 PCs on over dispersed genes
pcs <- MUDAN::getPcs(
    matnorm[matnorm_info$ods, ],
    nGenes = length(matnorm_info$ods),
    nPcs = 30, 
    verbose = FALSE
)
### TSNE embedding with regular PCS
emb <- Rtsne::Rtsne(
    pcs,
    is_distance = FALSE,
    perplexity = 30, 
    num_threads = 1,
    verbose = FALSE
)$Y
rownames(emb) <- rownames(pcs)
### plot
par(mfrow = c(1, 1), mar = rep(2, 4))
MUDAN::plotEmbedding(
    emb, groups = meta, show.legend = TRUE,
    xlab = NA, ylab = NA,
    main = "Regular tSNE Embedding",
    verbose = FALSE
)
```
#
#
#
#| eval: false
par(mfrow = c(2, 2), mar = rep(2, 4))
invisible(
    lapply(
        c("MS4A1", "CD3E", "FCGR3A", "CD14"),
        function(x) {
            gexp <- log10(mat[x, ] + 1)
            plotEmbedding(
                emb, col = gexp, xlab = "NA",
                ylab = NA, main = x,
                verbose = FALSE
            )
        }
    )
)
```
#
#
#
#| eval: false
annot_bad <- getComMembership(pcs, k = 30, method = igraph::cluster_louvain)
par(mfrow = c(1, 1), mar = rep(2, 4))
plotEmbedding(
    emb, groups = annot_bad, show.legend = TRUE,
    xlab = NA, ylab = NA,
    main = "Jointly-indentified cell clusters",
    verbose = FALSE
)
#
#
#
#| eval: false
### look at cell-type proportion per sample
t(table(annot_bad, meta))/as.numeric(table(meta))
# Look at cell-type proportions per sample
# print(t(table(annot_bad, meta))/as.numeric(table(meta)))
#
#
#
#
#
### load required data
data("pbmc_stim")

### generate seurat object
pbmc <- CreateSeuratObject(
    counts = cbind(pbmc.stim, pbmc.ctrl),
    project = "PBMC",
    min.cells = 5
) 

### separete conditions
pbmc@meta.data$stim <- c(
    rep("STIM", ncol(pbmc.stim)),
    rep("CTRL", ncol(pbmc.ctrl))
)

### generate a union of highly variable genes
pbmc <- pbmc |> Seurat::NormalizeData(verbose = FALSE)

VariableFeatures(pbmc) <- split(row.names(pbmc@meta.data), pbmc@meta.data$stim) %>% lapply(function(cells_use) {
    pbmc[,cells_use] %>%
        FindVariableFeatures(selection.method = "vst", nfeatures = 2000) %>% 
        VariableFeatures()
}) %>% unlist %>% unique

pbmc <- pbmc |> 
    ScaleData(verbose = FALSE) |> 
    RunPCA(features = VariableFeatures(pbmc), npcs = 20, verbose = FALSE)
```
#
#
#
p1 <- DimPlot(object = pbmc, reduction = "pca", pt.size = .1, group.by = "stim")
p2 <- VlnPlot(object = pbmc, features = "PC_1", group.by = "stim", pt.size = .1)
cowplot::plot_grid(p1,p2)
#
#
#
#
#
#
### run harmony to perform integrated analysis
pbmc <- RunHarmony(pbmc, "stim", plot_convergence = TRUE)

### directly access the new harmony embeddings
harmony_embeddings <- Embeddings(pbmc, "harmony")
harmony_embeddings[1:5, 1:5]

### inspection of the modalities
p1 <- DimPlot(object = pbmc, reduction = "harmony", pt.size = .1, group.by = "stim")
p2 <- VlnPlot(object = pbmc, features = "harmony_1", group.by = "stim", pt.size = .1)
plot_grid(p1,p2)
```
#
#
#
DimHeatmap(object = pbmc, reduction = "harmony", cells = 500, dims = 1:3)
```
#
#
#
pbmc <- pbmc |> 
    ### perform clustering using the harmonized vectors of cells
    FindNeighbors(reduction = "harmony", dims = 1:20) |> 
    FindClusters(resolution = 0.5) |> 
    identity()
### TSNE
pbmc <- pbmc %>%
    RunTSNE(reduction = "harmony")
p1 <- DimPlot(pbmc, reduction = "tsne", group.by = "stim", pt.size = .1)
p2 <- DimPlot(pbmc, reduction = "tsne", label = TRUE, pt.size = .1)
plot_grid(p1, p2)
```
#
#
#
FeaturePlot(object = pbmc, features= c("CD3D", "SELL", "CREM", "CD8A", "GNLY", "CD79A", "FCGR3A", "CCL2", "PPBP"), 
            min.cutoff = "q9", cols = c("lightgrey", "blue"), pt.size = 0.5)
#
#
#
### UMAP
pbmc <- pbmc |> 
    RunUMAP(reduction = "harmony", dims = 1:20)
p1 <- DimPlot(pbmc, reduction = "umap", group.by = "stim", pt.size = .1, split.by = 'stim')
### identify shared cell types with clustering analysis
p2 <- DimPlot(pbmc, reduction = "umap", label = TRUE, pt.size = .1)
plot_grid(p1, p2)
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
sessionInfo()
#
#
#
