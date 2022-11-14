#title：appendix1：使用多个包创建网络并且可视化
#date: 20221114
#sourcelink:https://www.jessesadler.com/post/network-analysis-with-r/#networkd3
library(tidyverse)
install.packages("visNetwork")
library("networkD3")
edge_list <- tibble(from = c(1, 2, 2, 3, 4), to = c(2, 3, 4, 2, 1))
node_list <- tibble(id = 1:4)
edge_list
#import data
letters <- read.csv(url("https://raw.githubusercontent.com/jessesadler/intro-to-r/master/data/correspondence-data-1585.csv"))

sources <- letters %>%
  distinct(source) %>%
  rename(label = source)

destinations <- letters %>%
  distinct(destination) %>%
  rename(label = destination)

nodes <- full_join(sources, destinations, by = "label")
nodes <- nodes %>% rowid_to_column("id")
nodes

route <- letters %>% 
  group_by(source,destination) %>% 
  summarise(weight=n()) %>% 
  ungroup()


edges <- route %>% 
  left_join(nodes, by = c("source" = "label")) %>% 
  rename(from = id)

edges <- edges %>% 
  left_join(nodes, by = c("destination" = "label")) %>% 
  rename(to = id)

edges<-edges %>% 
  select( to ,from,weight)

#network包
library(network)
routes_network <- network(edges, vertex.attr = nodes, matrix.type = "edgelist", ignore.eval = FALSE)
routes_network
plot(routes_network, vertex.cex=4,mode="circle")


#igraph创建
library(igraph)
route_igraph<-graph_from_data_frame(d=edges,vertices=nodes,directed=TRUE)
route_igraph

#tidygraphgraph
library(tidygraph)
library(ggraph)
routes_tidy <- tbl_graph(nodes = nodes, edges = edges, directed = TRUE)
routes_igraph_tidy <- as_tbl_graph(route_igraph)

routes_tidy %>% 
  activate(edges) %>% 
  arrange(desc(weight))
ggraph(routes_tidy) + geom_edge_link() + geom_node_point() + theme_graph()
ggraph(routes_tidy, layout = "graphopt") + 
  geom_node_point() +
  geom_edge_link(aes(width = weight), alpha = 0.8) + 
  scale_edge_width(range = c(0.2, 2)) +
  geom_node_text(aes(label = label), repel = TRUE) +
  labs(edge_width = "Letters") +
  theme_graph()

ggraph(route_igraph, layout = "linear") + 
  geom_edge_arc(aes(width = weight), alpha = 0.8) + 
  scale_edge_width(range = c(0.2, 2)) +
  geom_node_text(aes(label = label)) +
  labs(edge_width = "Letters") +
  theme_graph()

#networkD3包
library(visNetwork)
library(networkD3)
visNetwork(nodes, edges)
edges <- mutate(edges, width = weight/5 + 1)
visNetwork(nodes, edges) %>% 
  visIgraphLayout(layout = "layout_with_fr") %>% 
  visEdges(arrows = "middle")


nodes_d3 <- mutate(nodes, id = id - 1)
edges_d3 <- mutate(edges, from = from - 1, to = to - 1)

forceNetwork(Links = edges_d3, Nodes = nodes_d3, Source = "from", Target = "to", 
             NodeID = "label", Group = "id", Value = "weight", 
             opacity = 1, fontSize = 16, zoom = TRUE)


sankeyNetwork(Links = edges_d3, Nodes = nodes_d3, Source = "from", Target = "to", 
              NodeID = "label", Value = "weight", fontSize = 16, unit = "Letter(s)")

