

library(ape)
library(ggtree)
library(phytools)
library(ggplot2)
library(DataCombine)
library(ggrepel)
library(cowplot)
library(RColorBrewer)
library(face)
library(tidyr)
library(ggrepel)
library("viridis")
library(gridExtra)
library(plyr)
library(reshape)
library(cowplot)
library(randomcoloR)
library(ggnewscale)

theme_set(theme_cowplot())

##import tree
EC_tre <- read.tree("pangenome.tre")
EC_tre <-ladderize(midpoint.root(EC_tre))

write.tree(EC_tre, file = "mytree.tre")


#Original figure
annotated_treeonlyST <-ggtree(EC_tre, layout = "rectangular", ladderize=F)%<+% metadata +
  geom_tippoint(aes(subset=(Sample=="mine")), fill="red", color="black", shape=21, size=3)+
  theme(legend.position = "left") + 
  geom_treescale()+
  geom_tiplab(size = 2.5, align = TRUE)+
  coord_cartesian(xlim = c(0, 0.5))

## Modified for highlighting
annotated_treeonlyST <-ggtree(EC_tre, layout = "rectangular", ladderize = F) %<+% metadata +
  geom_tippoint(aes(subset = (Sample == "mine")), fill = "red", color = "black", shape = 21, size = 3) +
  theme(legend.position = "left") + 
  geom_treescale() +
  geom_tiplab(aes(color = ifelse(Sample == "mine", "red", "black")), size = 3, align = TRUE) +
  scale_color_manual(values = c("black", "red")) +
  coord_cartesian(xlim = c(0, 0.5))+
  guides(color = FALSE)


annotated_treeonlyST <- flip(annotated_treeonlyST, direction = "y") %>% layout()

n <- 19
palette <- distinctColorPalette(n)

#final_heatmap_geno
metadata<- read.delim("metadata.txt")

metadata$Year <- as.character(metadata$Year)
Source_meta <- data.frame(Source= metadata$Source)
Year_meta <- data.frame(Year= metadata$Year)
St_meta <- data.frame(ST= metadata$ST)

rownames(Source_meta) <- metadata$tip.label
rownames(Year_meta) <- metadata$tip.label
rownames(St_meta) <- metadata$tip.label

annotated_tree_meta <- gheatmap(annotated_treeonlyST, Source_meta, offset = 0.04, width=0.12, font.size=2.2, colnames_position= "top", colnames_angle = 50, colnames_offset_y = 0, hjust = .01) + scale_fill_manual(name= "Source", labels = c("floor swab", "OBF", "urine"), values = c("blue", "red", "green")) + theme(legend.title = element_text(10))
TempTree <- annotated_tree_meta + new_scale_fill()

annotated_tree_metaYear <- gheatmap(TempTree, Year_meta, offset = 0.06, width=0.12, font.size=2.2, colnames_position= "top", colnames_angle = 50, colnames_offset_y = 0, hjust = .01) + scale_fill_manual(name= "Collection year", labels = c("2018", "2019", "2020", "2021"), values = c("#238b45","#66c2a4", "#b2e2e2", "#edf8fb")) + theme(legend.title = element_text(10))
TempTree2 <- annotated_tree_metaYear + new_scale_fill()

annotated_tree_metaST <- gheatmap(TempTree2, St_meta, offset = 0.08, width=0.12, font.size=2.2, colnames_position= "top", colnames_angle = 50, colnames_offset_y = 0, hjust = .01) + scale_fill_manual(name= "ST", labels = c("1884", "405",  "1011", "354",  "131",  "73",   "38",   "UT",   "48",   "617",  "648",  "421",  "2178","2851", "1193", "162",  "167",  "448",  "973"), values = c(palette)) + theme(legend.title = element_text(10))
annotated_tree_metaST

roated_tree <- annotated_tree_metaST %>% rotate(180) %>% layout()


ggtree(EC_tre, layout = "rectangular", ladderize = F) %<+% metadata +
  geom_tippoint(aes(subset = (Sample == "mine")), fill = "red", color = "black", shape = 21, size = 3) +
  theme(legend.position = "left") + 
  geom_treescale() +
  geom_tiplab(aes(color = ifelse(Sample == "mine", "red", "black")), size = 3, align = TRUE) +
  scale_color_manual(values = c("black", "red")) +
  coord_cartesian(xlim = c(0, 0.5))+
  guides(color = FALSE)








