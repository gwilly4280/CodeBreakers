library(ape)
library(ggtree)
library(reshape2)
large<-read.FASTA("seqs.afa")
largedm<-dist.dna(large, model="K80")
largemat<-as.matrix(largedm)
largemelted<-melt(largemat)
largeTree<-nj(largedm)
Full_length<-ggtree(largeTree, branch.length='none')+ geom_tiplab()
Full_length

<<<<<<< HEAD:10.Full_phylo.R
####Matrix Visualized

largemelted$Var1<-gsub("^(.{3}).*", "\\1", largemelted$Var1)
largemelted$Var2<-gsub("^(.{3}).*", "\\1", largemelted$Var2)
large_mat_vis<-ggplot(data = largemelted, aes(x=Var1, y=Var2, fill=value)) +
=======
### #10 IN WORKFLOW ### 

ggplot(data = PDat, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile()
library(maps)
PDat$Var1<-gsub(Country)
PDat2<-PDat
PDat2$value[PDat2$value>0.2]<-NA
ggplot(data = PDat2, aes(x=Var1, y=Var2, fill=value)) +
>>>>>>> da31b81b2b79ff84f3ffa25dacf0c016876c03e4:9.2 (10) .Full_phylo.R
  geom_tile()+scale_fill_gradientn(colours=c("white","blue","green","red")) +
  theme(axis.text.x = )
large_mat_vis
