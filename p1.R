

library(igraph)
library(dplyr)

# get g14 edgelist and ignore weights
g14_edgelist <- read.csv("https://ona-book.org/data/g14_edgelist.csv")
g14_unweighted <- g14_edgelist |> 
  dplyr::select(-weight)

# create g14 graph
g14 <- igraph::graph_from_data_frame(g14_unweighted, directed = FALSE)
# calculate degree centrality for all vertices
igraph::degree(g14)




#画图：
install.packages('ggraph')
library(ggraph)
ggraph(g14,layout="lgl")+
  geom_edge_link(color="grey",alpha=0.7)+
  geom_node_point(aes(size=degree),color="lightblue",show.legend=FALSE)+
  scale_size(range=c(5,15))+geom_node_text(aes(names))+
  theme_void()
  
  
  