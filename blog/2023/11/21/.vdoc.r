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
#
### Library packages
library(here)
library(tidyverse)
library(Seurat)
library(SingleR)
library(ggrepel)

### Load data
load(here("learn", "PBMC_tutorial", "pbmc_tutorial_singleR.RData"))

### Check data
pbmc

### View the UMAP
DimPlot(pbmc, group.by = c("seurat_clusters", "labels"), reduction = "umap")
```
#
#
#
### Find the UMAP data
str(pbmc)

### Retrieve the coordinates of each cell, and cluster, celltype information
umap <- pbmc@reductions$umap@cell.embeddings %>% 
  as.data.frame() %>% 
  cbind(cell_type = pbmc@meta.data$labels)

head(umap)
```
#
#
### Define the colors
allcolour <- c(
    "#DC143C","#0000FF","#20B2AA","#FFA500","#9370DB","#98FB98","#F08080",
    "#1E90FF","#7CFC00","#FFFF00", "#808000","#FF00FF","#FA8072","#7B68EE",
    "#9400D3","#800080","#A0522D","#D2B48C","#D2691E","#87CEEB","#40E0D0",
    "#5F9EA0","#FF1493","#0000CD","#008B8B","#FFE4B5","#8A2BE2","#228B22",
    "#E9967A","#4682B4","#32CD32","#F0E68C","#FFFFE0","#EE82EE","#FF6347",
    "#6A5ACD","#9932CC","#8B008B","#8B4513","#DEB887"
)

### ggplot2
p <- ggplot(umap, aes(x = UMAP_1, y = UMAP_2, color = cell_type)) +
    geom_point(size = 1, alpha = 1) +
    ### MAP cluster with color
    scale_color_manual(values = allcolour) +
    ### Axis annotation
    geom_segment(
        aes(
            x = min(umap$UMAP_1) , y = min(umap$UMAP_2) ,
            xend = min(umap$UMAP_1) +3, yend = min(umap$UMAP_2)
        ), colour = "black", linewidth = 1,arrow = arrow(length = unit(0.3,"cm"))
    ) + 
    geom_segment(
        aes(
            x = min(umap$UMAP_1)  , y = min(umap$UMAP_2)  ,
            xend = min(umap$UMAP_1) , yend = min(umap$UMAP_2) + 3),
            colour = "black", linewidth = 1,arrow = arrow(length = unit(0.3,"cm"))
    ) +
    annotate(
        "text", x = min(umap$UMAP_1) +1.5, y = min(umap$UMAP_2) -1, 
        label = "UMAP_1", color="black",size = 3, fontface="bold"
    ) + 
    annotate(
        "text", x = min(umap$UMAP_1) -1, y = min(umap$UMAP_2) + 1.5, 
        label = "UMAP_2", color="black",size = 3, fontface="bold" ,angle=90
    ) + 
    theme(
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        legend.key=element_rect(fill= "white"),
        legend.text = element_text(size = 20),
        legend.key.size=unit(1, "cm")
    ) +
    ### legend label size
    guides(color = guide_legend(override.aes = list(size=5)))
#
#
#
#
#
### Calcualte the median coordinates of each cluster
cell_type_med <- umap %>%
  group_by(cell_type) %>%
  summarise(UMAP_1 = median(UMAP_1),
    UMAP_2 = median(UMAP_2)
  )
### Annotation
p + geom_text(
    aes(label = cell_type,size = 20), data = cell_type_med,
    point.padding=unit(0.5, "lines")
    )

#ggrepel添加
library(ggrepel)

p4 + 
  geom_label_repel(aes(label=cell_type), fontface="bold",data = cell_type_med,
                   point.padding=unit(0.5, "lines"))

#去掉legend
p4 +geom_label_repel(aes(label=cell_type), fontface="bold",data = cell_type_med, 
                     point.padding=unit(0.5, "lines")) +
  theme(legend.position = "none")
#
#
#
