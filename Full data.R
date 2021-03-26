# A representative df, # of sequences from each country using the subsetting code
Repdf<-rbind(sample_n(dat_USA, 10),sample_n(dat_CHINA, 10),sample_n(dat_AUSTRALIA, 10),sample_n(dat_INDIA, 10),sample_n(dat_JAPAN, 10))

# Adapting Spike reference code to work with repdf
Repdf_fasta <- entrez_fetch(db = "nuccore",
                            id = Repdf$Accession,
                            rettype = "fasta")

## For the new df
# Cleaning FASTA
df_clean <- separate_fasta(Repdf_fasta)

# Isolating based on start & End motifs
df_isolate <- isolate_seq(df_clean, start_motif, end_motif)

# Checking length of each sequence
df_isolate <- df_isolate %>%
  mutate(seq_len = nchar(Target))
df_isolate<-cbind(df_isolate,Geo_Location=Newdf$Geo_Location)


#=================================
library(ape)
library(adegenet)
#Mutations
#To obtain the sequence we use the sapply function
isolatedseq<-sapply(df_isolate$Target,strsplit,split="")

#Names and data formatted as DNAbin
names(isolatedseq)<-paste(1:nrow(df_isolate),df_isolate$Name,sep="_")
isolatedseq<-as.DNAbin(isolatedseq)

#Aligning sequences
seqalign<-muscle(isolatedseq,quiet=F)

#
checkAlignment(seqalign[1:50,1:3822])
aligned<-as.alignment(seqalign[1:50,1:3822])
aligned<-as.DNAbin(aligned)
muts<-findMutations(aligned[1:50,],from = 1)

#Gross Regex
mut<-lapply(muts, "[",  "short")
mutchar<- lapply(mut, as.character)
mutchar<-gsub("[()=]","",mutchar)
mutchar<-sub("\\w+?","",mutchar)
mutations<- c("Reference",mutchar)
df_isolate$Mutations<-mutations
