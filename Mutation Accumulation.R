library(ggplot2) #Load the ggplot2 library for graphic visualization

mut_acc <- read.csv('./Dataset/mutation_accumulation.csv') #Read in and save the mutation_accumulation file for manipulation and graphing

# Setting temp variables
Date = c()
Mutation = c()
Index = c()
Country = c()
n = 1

# For loop to populate the temp variables
for (i in c(1:nrow(df_isolate))){
  muts = df_isolate$Mutations[[i]]
  for (j in c(1:length(muts))){
    Mutation[n] = muts[j]
    Date[n] = df_isolate$Date[i]
    Index[n] = i
    Country[n] = df_isolate$Geo_Location[i]
    n = n + 1
  }
}

# Building dataframe from visualization
mut_acc <- data.frame(Country, Date, Index, Mutation)

ggplot(mut_acc, aes(x = as.Date(Date), fill = Mutation))+ #Use this graph to record the number of mutation incidences over time (non-cumulative)
  geom_histogram(alpha = 1)+
  theme_bw()+
  scale_x_date(name = 'Collection Date')+
  scale_y_continuous(name = 'Count')

# Removing temp variables
rm(Date, Mutation, Index, Country, n, i, j)


