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
```
#
library(ggsci)
library(RColorBrewer)
library(viridis)
library(paletteer)
library(cols4all)
library(RImagePalette)
library(scales)
```
#
#
#
length(colors()) #657种颜色
show_col(colors()[1:100])
#配色来自：Nat Med. 2019 Aug;25(8):1251-1259. 
mycolor<-c("#80d7e1","#e4cbf2","#ffb7ba","#bf5046","#b781d2","#ece7a3",
            "#f5cbe1","#e6e5e3","#d2b5ab","#d9e3f5","#f29432","#9c9895")
show_col(mycolor)
DimPlot(pbmc5k, reduction = "umap",label=T)+ NoLegend() #读入任意创建好的seurat对象即可
DimPlot(pbmc5k, reduction = "umap",cols=mycolor,label=T)+ NoLegend()
#
#
#
#
devtools::install_github("joelcarlson/RImagePalette")
library(RImagePalette)
#加载图片
lifeAquatic <- jpeg::readJPEG("color.jpg")#UMAP图片来自：Nat Med. 2019 Aug;25(8):1251-1259. 
display_image(lifeAquatic)
#可以调整n的值来得到不同数量的颜色
mycolor <- image_palette(lifeAquatic, n=16) 
show_col(mycolor)
#
#
#
#
library(RColorBrewer)
display.brewer.all()
#调用单个调色板
mycolor<-brewer.pal(9, "Set1")
#调用多个调色板合并
b1<-brewer.pal(9, "Set1")
b2<-brewer.pal(8, "Set2")
mycolor<-c(b1,b2) 
#
#
#
#
library("ggsci")
vignette("ggsci")
DimPlot(pbmc5k, reduction = "umap",label=T)+ scale_color_nejm()+NoLegend()
mycolor<-pal_nejm("default", alpha = 0.5)(8) 
#
#
#
#
install.packages("paletteer")
library(paletteer)  
paletteer_c("scico::berlin", n = 10)
paletteer_d("RColorBrewer::Paired",n=12)
paletteer_dynamic("cartography::green.pal", 20)
#
#
#
remotes::install_github("mtennekes/cols4all")
library(cols4all)
#交互面板
c4a_gui()
#可以通过函数提取配色(色板名称+所需颜色数量)
mycolor <-c4a("light24", 9)
#
#
#
#
#配色来自：Nat Med. 2019 Aug;25(8):1251-1259. 
mycolor1<-c("#80d7e1","#e4cbf2","#ffb7ba","#bf5046","#b781d2","#ece7a3",
            "#f5cbe1","#e6e5e3","#d2b5ab","#d9e3f5","#f29432","#9c9895")
show_col(mycolor1,labels = F)
#配色来自：Immunity. 2020 May 19;52(5):808-824.e7.
mycolor2<-c("#e41e25","#307eb9","#4cb049","#974e9e","#f57f21","#f4ed35",
            "#a65527","#9bc7e0","#b11f2b","#f6b293")
show_col(mycolor2,labels = F)
#配色来自：Cell. 2019 Oct 31;179(4):829-845.e20.
mycolor3<-c("#b38a8f","#bba6a6","#d5b3a5","#e69db8","#c5ae8d","#87b2d4",
            "#babb72","#4975a5","#499994","#8e8786","#93a95d","#f19538",
            "#fcba75","#8ec872","#ad9f35","#8ec872","#d07794","#ff9796",
            "#b178a3","#e56464","#6cb25e","#ca9abe","#d6b54c") 
DimPlot(pbmc5k, reduction = "umap",group.by='seurat_clusters',label=T)+scale_color_manual(values = mycolor1)+NoLegend()
DimPlot(pbmc5k, reduction = "umap",group.by='seurat_clusters',label=T)+scale_color_manual(values = mycolor2)+NoLegend()
DimPlot(pbmc5k, reduction = "umap",group.by='seurat_clusters',label=T)+scale_color_manual(values = mycolor3)+NoLegend()
#
#
#
