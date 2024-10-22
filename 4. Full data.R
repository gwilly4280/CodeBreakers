
### FILE 4 IN WORKFLOW ###
# Adapting Spike reference code to work with repdf

remain = nrow(countries)
i = 1
j = 0
Repdf_fasta = ""
while(remain > 0){
  if (remain < 100)
    diff = remain
  else
    diff = 100
  j = j + diff
  Repdf_fasta <- paste(Repdf_fasta, entrez_fetch(db = "nuccore",
                                                 id = countries[i:j,]$Accession,
                                                 rettype = "fasta"), sep = "")
  i = i + diff
  remain = remain - diff
}

# Removing temp variables
rm(diff, i, j, remain)

## For the new df
# Cleaning FASTA
df_clean <- separate_fasta(Repdf_fasta)

# Isolating based on start & End motifs
df_isolate <- isolate_seq(df_clean, start_motif, end_motif)

# Checking length of each sequence
df_isolate <- df_isolate %>%
  mutate(seq_len = nchar(Target))

# Merging reference with df_isolate & adding relevant cols
df_isolate <- rbind(spike_ref, cbind(df_isolate,
                                     Geo_Location = countries$Geo_Location,
                                     Date = countries$Collection_Date))

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

N = nrow(df_isolate)

# Transforming alignment
checkAlignment(seqalign[1:N,1:3822])
aligned<-as.alignment(seqalign[1:N,1:3822])
aligned<-as.DNAbin(aligned)
muts<-findMutations(aligned[1:N,],from = 1)

#Gross Regex
mut<-lapply(muts, "[",  "short")
mutchar<- lapply(mut, as.character)
mutchar<-gsub("[()=]","",mutchar)
mutchar<-sub("\\w+?","",mutchar)
mutations<- c("Reference",mutchar)
df_isolate$Mutations <- mutations

# Removing extra variables
rm(df_clean, isolatedseq, muts, mut, mutchar, mutations, Repdf_fasta)
