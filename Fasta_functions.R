"
Title:   Fasta_functions
Made by: Christian Garnons-Williams
Made on: 2021-03-18
Version: 2 (2021-03-21)
"

# Takes String FASTA file as input
# Returns dataframe w/ w/ 1 col for header, & 1 for raw sequence
# with each row representing a single FASTA entry from the FASTA file
separate_fasta <- function(fasta){
   fasta <- unlist(strsplit(fasta, split = "\n\n"))
   header <- gsub("(^>.*genome)(\\n|\\r).*", "\\1", fasta)
   seq <- gsub("^>.*genome(\\n|\\r)(.*)", "\\2", fasta)
   seq <- gsub("\\n|\\r", "", seq)
   return(data.frame(Name = header, Sequence = seq))
}


# Takes df created by *separate_fasta*, and a start seq, and end seq (as String)
# Returns df w/ new "Target" col: sequence w/in & including start:end motifs
isolate_seq <- function(df, start, end){
   df$Target = gsub(paste(".*(", start, ".*?",end, ").*", sep=""), "\\1", df$Sequence)
   return(df)
}