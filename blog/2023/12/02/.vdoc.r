# Optimize colors, size and direction
my36colors <- c(
    '#E5D2DD', '#53A85F', '#F1BB72', '#F3B1A0', '#D6E7A3', '#57C3F3', '#476D87',
    '#E95C59', '#E59CC4', '#AB3282', '#23452F', '#BD956A', '#8C549C', '#585658',
    '#9FA3A8', '#E0D4CA', '#5F3D69', '#C5DEBA', '#58A4C3', '#E4C755', '#F7F398',
    '#AA9A59', '#E63863', '#E39A35', '#C1E6F3', '#6778AE', '#91D0BE', '#B53E2B',
    '#712820', '#DCC1DD', '#CCE0F5', '#CCC9E6', '#625D9E', '#68A180', '#3A6963',
    '#968175'
)

VlnPlot(
    sce2, 
    features = top_marker$gene,
    stack = TRUE,
    sort = TRUE,
    cols = my36colors,
    split.by = "celltype", # color for each cluster
    flip = TRUE
  ) +
    theme(legend.position = "none") +
    ggtitle("Identity on x-axis")

```{r}
vln.dat=FetchData(sce2,c(top_marker$gene,"celltype","seurat_clusters"))

vln.dat$Cell <- rownames(vln.dat)
vln.dat.melt <- reshape2::melt(vln.dat, id.vars = c("Cell","seurat_clusters"), 
                               measure.vars = top_marker$gene,
                               variable.name = "gene", 
                               value.name = "Expr") |>
  group_by(seurat_clusters,gene) |> 
  mutate(fillcolor=mean(Expr))

# Plot 
ggplot(vln.dat.melt, aes(factor(seurat_clusters), Expr, fill = gene)) +
  geom_violin(scale = "width", adjust = 1, trim = TRUE) +
  facet_grid(rows = vars(gene), scales = "free", switch = "y") 





