"
Title:    Mutation_functions
Made by:  Christian Garnons-Williams
Made on:  2021-03-25
Version:  1
Requires: dplyr must be loaded for all functions to run
"

########### Work with the Extracted mutations ###########

# Building the 'not in' operator for important future uses
'%notin%' <- Negate('%in%') # Took me a half an hour to get this working smh

# Function to isolate mutations from output of Alignment.R processes
# Takes processed dataframe with mutations identified
# Returns dataframe containing only
get_muts <- function(mutant_df){
  not_mut = c("haracter0", "Reference")
  return(mutant_df %>% filter(Mutations %notin% not_mut))
}

########### Work with the reference mutations ###########

# Load mutation file
mutations <- read.csv("./Dataset/mutations.csv")

# Function for extracting usable mutations from the reference mutation dataset
extract_mut <- function(raw_muts, pos){
  muts <- strsplit(raw_muts, split = " > ")[[1]]
  origin <- strsplit(muts, split = "")[[1]]
  new <- strsplit(muts, split = "")[[2]]
  for (i in c(1:3)){
    if (!grepl(origin[i], new[i])){
      return(paste((i-1 + pos), ":" , tolower(origin[i]), "->", tolower(new[i]), sep=""))
    }
  }
}

# Dyplr code to convert the mutations into something usable
mutations_ref <- mutations %>%
  group_by(row.names(mutations)) %>%
  mutate(Change = extract_mut(Change,Location))

rm(mutations)
