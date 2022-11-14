#title==chapter1:visualize a graph
#update:20221114
#author:monicajia
#source from: https://ona-book.org/index.html
#data prepare:
install.packages("onadata")
library(onadata)
# see a list of data sets
data(package = "onadata")
# find out more about a specific data set ('karate' example)
help(karate)

#import data from dataframe
library(igraph)
library(tidyverse)
karate_list<-read_csv("https://ona-book.org/data/karate.csv")
head(karate_list)
k_net<-igraph::graph_from_data_frame(karate_list,directed=FALSE)  #从dataframe导入到网络数据

#ploting-1.1 布局的设置
l<-igraph::layout_randomly(k_net)
plot(k_net,layout=l)
#另外两种布局layout_sugiyama & layout_with_dh
l2<-layout.sugiyama(k_net)
plot(k_net,layout=l2)
l3<-layout_with_dh(k_net)
plot(k_net,layout=l3)
#ploting-1.2 标签设置
V(k_net)$label<-ifelse(V(k_net)$name%in%c("Mr Hi","John A"),
                       V(k_net)$name,"")
V(k_net)$label.color<-"black"   #标签的颜色
v(k_net)$label.cex<-0.8     #标签的字号
V(k_net)$lable.family<-"arial"  #标签的字体family
V(k_net)$label.dist<-0  # 标签与定点之间的距离
plot(k_net,layout=l)  #绘图
#ploting-1.3 顶点设置
V(k_net)$color<-ifelse(V(k_net)$name %in% c("Mr Hi","John A"),
                       "lightblue",
                       "pink")
V(k_net)$size<-5
V(k_net)$shape<-ifelse(V(k_net)$name %in% c("Mr Hi","John A"),
                       "circle",
                       "square")
plot(k_net,layout=l)
#ploting-1.2 设置边的特征
E(k_net)$color<-"black"
E(k_net)$lty<-"dashed"
plot(k_net,layout=l)


#ploting-1.3 布局特征再调整
#将布局特征设置为一种网络属性
knet_grid<-add_layout_(k_net,on_grid())
head(knet_grid$layout)
#circle layout
circ<-layout_in_circle(k_net)
plot(k_net,layout=circ)
#sphere layout
sph<-layout_on_sphere(k_net)
plot(k_net,layout=sph)
#force-directed 力向图布局非常受欢迎，因为它们具有美观的效果，并且有助于有效地可视化顶点社区，特别是在边缘复杂性较低或中等的图中。

# F-R algorithm
fr <- layout_with_fr(k_net)
plot(k_net, layout = fr)
#k-k algorithm
kk<-layout_with_kk(k_net)
plot(k_net,layout=kk)
gem<-layout_with_gem(k_net)
plot(k_net,layout=gem)







