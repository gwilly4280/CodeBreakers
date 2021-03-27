"
Title:   spike_reference_test
Made by: Christian Garnons-Williams
Made on: 2021-03-21
"
####### LOADING LIBRARIES #######
library(dplyr)
library(rentrez)

# Loading in Fasta_functions.R file
source("./Fasta_functions.R")

####### PREPARING SPIKE TEMPLATE #######

# Setting correct filename & extension
fileName <- "./Dataset/spike_reference.txt"

# Load in the reference sequence
spike_fasta <-  readChar(fileName, file.info(fileName)$size)

# Clean FASTA file & convert to format compatible with dataset
spike_ref <- separate_fasta(spike_fasta) %>%
  mutate(Target = Sequence,
         Sequence = "NULL",
         seq_len = nchar(Target),
         Geo_Location = "REF")

# Getting start & end motifs to capture our sequence of 12 bp/side
start_motif <- substr(spike_ref$Target, 1, 12)
end_motif <- substr(spike_ref$Target,
                    nchar(spike_ref$Target) - 11,
                    nchar(spike_ref$Target))

# Removing excess variables
rm(fileName, spike_fasta)

# Testing code commented out. If needed, remove the quotations at start/end of block
'
####### LOADING TEST DATA #######

# Load in sequence data & filter by completeness + ensure all have accession no.
sequences <- read.csv("./Dataset/sequences.csv") %>%
  filter(Nuc_Completeness == "complete",
         Accession != "")

# Get random sample of sequences for testing
sample <- sample.int(length(sequences$Accession), 20)

sample_fasta <- entrez_fetch(db = "nuccore",
                             id = sequences$Accession[sample],
                             rettype = "fasta")

####### TESTING SPIKE TEMPLATE #######

# Cleaning FASTA
sample_clean <- separate_fasta(sample_fasta)

# Isolating based on start & End motifs
sample_isolate <- isolate_seq(sample_clean, start_motif, end_motif)

# Checking length of each sequence
sample_isolate <- sample_isolate %>%
  mutate(seq_len = nchar(Target))

# Printing lenght
nchar(spike_seq)

# Checking if all isolated sequences are the same length
sample_isolate$seq_len == nchar(spike_seq)
# All sequences are the same length - successful extraction of the protein seq

# Removing clutter variables
rm(, , sample_isolate, sample_clean, sample, sample_fasta, sequences, )
'
