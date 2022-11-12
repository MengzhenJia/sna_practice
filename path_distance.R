#----------2022111 for sna path and distance 

#community  detection---
#learning resources: https://ona-book.org/paths-distance.html
#生成G14网络
library(igraph)
library(dplyr)
# get g14 edgelist and ignore weights
g14_edgelist <- read.csv("https://ona-book.org/data/g14_edgelist.csv")
g14_unweighted <- g14_edgelist |> 
  dplyr::select(-weight)
# create g14 graph
g14 <- igraph::graph_from_data_frame(g14_unweighted, directed = FALSE)
#install.packages("ggraph")
library(ggraph)
V(g14)$degree <- degree(g14)
V(g14)$betweenness <- betweenness(g14)
V(g14)$eigen <- eigen_centrality(g14)$vector
ggraph(g14,layout="lgl")+
geom_edge_link(color = "grey", alpha = 0.7)+
  geom_node_point(aes(size = degree), color = "lightblue",
                  show.legend = FALSE) +
  scale_size(range = c(5,15)) +
  geom_node_text(aes(label = name)) +
  theme_void()



