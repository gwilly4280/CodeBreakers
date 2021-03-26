library(readr)
mutations <- read_csv("Dataset/mutations.csv")
SpikeStart<-21563
mutations$RelativeLocation<-mutations$Location- SpikeStart
