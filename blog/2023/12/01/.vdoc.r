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
    fig.align = "center", # fig.retina = 3,
    out.width = "100%", warning = FALSE, # evaluate = FALSE,
    collapse = TRUE
)
```
#
#
#
#
#
#| warning: false
#| message: false
library(here)
library(tidyverse)
library(patchwork)
library(ggsci)
library(Seurat)
library(RColorBrewer)
library(viridis)
library(paletteer)
library(cols4all)
library(RImagePalette)
library(scales)
#
#
#
#
#
#
# gray colors
cbp <- c("gray", "lightgray", "darkgray", "black")
p1 <- barplot(1:4, col = cbp)
# 4 colors
cbp <- c(
  "#b8b8b8", "#02ff00", "#f9a506", "#ff3c31"
)
p2 <- barplot(1:4, col = cbp)
# 6 colors
cbp <- c(
  "#4C72B0", "#55A868", "#C44E52", "#8172B2", "#CCB974", "#64B5CD"
)
p3 <- barplot(1:6, col = cbp)

(p1 + p2 + p3)/
# 8 colors
cbp <- c(
  "#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", 
  "#D55E00", "#CC79A7"
)
p4 <- barplot(1:8, col = cbp)
(p4 + p5)
# 9 colors
cbp <- c(
    "#000000", "#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", 
    "#0072B2", "#D55E00", "#CC79A7"
)
p5 <- barplot(1:9, col = cbp)
#
#
#
#
#
load(here("projects", "2023_scRNA_Seurat", "pbmc_tutorial.RData"))
# 657 colors
length(colors())
show_col(colors()[1:50])
cbp <-c(
  "#80d7e1","#e4cbf2","#ffb7ba","#bf5046","#b781d2","#ece7a3",          "#f5cbe1","#e6e5e3","#d2b5ab","#d9e3f5","#f29432","#9c9895"
)
show_col(cbp)
## Single cell plot
p1 <- DimPlot(pbmc, reduction = "umap",label = T) + NoLegend()
p2 <- DimPlot(pbmc, reduction = "umap",cols = cbp,label = T)+ NoLegend()
p1 + p2
#
#
#
#
library(RColorBrewer)
display.brewer.all()
col <- brewer.pal(9, "Set1")
b1 <- brewer.pal(9, "Set1")
b2 <- brewer.pal(8, "Set2")
mycolor <- c(b1,b2) 
```
#
#
library(ggsci)
# vignette("ggsci")
DimPlot(pbmc, reduction = "umap", label = TRUE) + 
  scale_color_nejm() +
  NoLegend()
mycolor <- pal_nejm("default", alpha = 0.5)(8) 
```
#
#
library(paletteer)  
paletteer_c("scico::berlin", n = 10)
paletteer_d("RColorBrewer::Paired",n=12)
paletteer_dynamic("cartography::green.pal", 20)
```
#
#
# remotes::install_github("mtennekes/cols4all")
library(cols4all)
# c4a_gui()
mycolor <-c4a("light24", 9)
#
#
#
# Color from：Nat Med. 2019 Aug;25(8):1251-1259. 
cbp <-c(
    "#80d7e1","#e4cbf2","#ffb7ba","#bf5046","#b781d2","#ece7a3",
    "#f5cbe1","#e6e5e3","#d2b5ab","#d9e3f5","#f29432","#9c9895"
)
show_col(cbp, labels = TRUE)
DimPlot(pbmc, reduction = "umap", group.by='seurat_clusters', label = T) +
  scale_color_manual(values = cbp)+
  NoLegend()

# Color from：Immunity. 2020 May 19;52(5):808-824.e7.
cbp <- c(
   "#e41e25","#307eb9","#4cb049","#974e9e","#f57f21","#f4ed35",
  "#a65527","#9bc7e0","#b11f2b","#f6b293"
)
show_col(cbp, labels = TRUE)
DimPlot(pbmc, reduction = "umap", group.by='seurat_clusters', label=T) + 
  scale_color_manual(values = cbp)+
  NoLegend()

# Color from：Cell. 2019 Oct 31;179(4):829-845.e20.
cbp <- c(
  "#b38a8f","#bba6a6","#d5b3a5","#e69db8","#c5ae8d","#87b2d4",
  "#babb72","#4975a5","#499994","#8e8786","#93a95d","#f19538",
  "#fcba75","#8ec872","#ad9f35","#8ec872","#d07794","#ff9796",
  "#b178a3","#e56464","#6cb25e","#ca9abe","#d6b54c"
)
show_col(cbp, labels = TRUE)
DimPlot(pbmc, reduction = "umap", group.by='seurat_clusters', label = T) + 
  scale_color_manual(values = cbp) +
  NoLegend()
#
#
#
#
#| eval: false
# devtools::install_github("joelcarlson/RImagePalette")
library(RImagePalette)
lifeAquatic <- jpeg::readJPEG("color.jpg")
display_image(lifeAquatic)
mycolor <- image_palette(lifeAquatic, n=16) 
show_col(mycolor)
#
#
#
