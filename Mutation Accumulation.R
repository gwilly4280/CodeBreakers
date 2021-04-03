library(ggplot2) #Load the ggplot2 library for graphic visualization

mut_acc <- read.csv('./Dataset/mutation_accumulation.csv') #Read in and save the mutation_accumulation file for manipulation and graphing

ggplot(mut_acc, aes(x = as.Date(Collection.Date), fill = Mutation))+ #Use this graph to record the number of mutation incidences over time (non-cumulative)
  geom_histogram(alpha = 1)+
  theme_bw()+
  scale_x_date(name = 'Collection Date')+
  scale_y_continuous(name = 'Count')


