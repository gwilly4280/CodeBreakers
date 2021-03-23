# Load ape
library(ape)

library(adegenet)
#Country
library(dplyr)
Country<-(substring(sample_isolate$Name,86,88))
sample_isolate<-mutate(sample_isolate,Country=substring(sample_isolate$Name,86,88))

#To obtain the sequence we use the sapply function
isolatedseq<-sapply(sample_isolate$Target,strsplit,split="")

#Names and data formatted as DNAbin
names(isolatedseq)<-paste(1:nrow(sample_isolate),sample_isolate$Name,sep="_")
isolatedseq<-as.DNAbin(isolatedseq)

#Aligning sequences
seqalign<-muscle(isolatedseq,quiet=F)
#
checkAlignment(seqalign[1:20,1:3822])
aligned<-as.alignment(seqalign[1:20,1:3822])
aligned<-as.DNAbin(aligned)
muts<-findMutations(aligned[1:20,],from = 1)
muts

sample_isolate$Mutations<-mutations

#Gross Regex
mut<-lapply(muts, "[",  "short")
mutchar<- lapply(mut, as.character)
mutchar<-gsub("[()=]","",mutchar)
mutchar<-sub("\\w+?","",mutchar)
mutations<- c("Reference",mutchar)


