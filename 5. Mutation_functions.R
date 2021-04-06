"
Title:    Mutation_functions
Made by:  Christian Garnons-Williams
Made on:  2021-03-30
Version:  4
Requires: dplyr must be loaded for all functions to run
"

### FILE 5 IN WORKFLOW ###

########### Work with the reference mutations ###########

# Load mutation file
mutations <- read.csv("./Dataset/mutations.csv")

# Function for extracting usable mutations from the reference mutation dataset
extract_mut <- function(raw_muts, pos){
  muts <- strsplit(raw_muts, split = " > ")[[1]]
  origin <- strsplit(muts, split = "")[[2]] # flipped here to be compatible with our dataset
  new <- strsplit(muts, split = "")[[1]]
  for (i in c(1:3)){
    if (!grepl(origin[i], new[i])){
      return(paste((pos - 21562), ":" , tolower(origin[i]), "->", tolower(new[i]), sep=""))
    }
  }
}


# Dyplr code to convert the mutations into something usable
mutations_ref <- mutations %>%
  group_by(row.names(mutations)) %>%
  mutate(Change = extract_mut(Change,Location))

# Remove row.names columns
mutations_ref <- mutations_ref[-8]

# Removing the temp variable
rm(mutations, extract_mut)



########### Work with the Extracted mutations ###########

# Create function to clean date
# Assumes if day unspecified, = 01
# Assumes if moth unspecified, = January (01)
clean_date <- function(date_str){
  if (nchar(date_str) == 7){
    date_str <- paste(date_str, "-01", sep = "")
  } else if (nchar(date_str) == 4){
    date_str <- paste(date_str, "-01-01", sep = "")
  }
  return (date_str)
}

# Function searching through mutations_ref using df_isolate mutations.
# Takes a single row's cleaned mutations & the reference file as argument.
# Returns vector of mutation names from the reference data if found;
# if match not found, returns unchanged mutation notation.
# Called by "clean_mut()"
get_name <- function(muts, ref_muts){
  for (i in c(1:length(muts))){
    result = grep(paste("^", muts[i], sep=""), ref_muts$Change)
    if (length(result) > 0){ # If match found
      muts[i] = ref_muts$Designation[result]
    }
  }
  return (muts)
}

# Function to extract mutation info from a single row of df_isolate mutations.
# Takes a single row's raw mutations & the reference file as argument.
# Returns LIST of mutation names from the reference data if found;
# if match not found, cleaned mutation notation is returned instead.
# Calls: get_name(), to perform comparison to reference data
clean_mut <- function(mut, ref_muts){
  not_mut = c("haracter0", "Reference")
  if (mut %in% not_mut){ # If no mutation:
    newmut = list("Reference")
  } else{ # If mutation:
    newmut = gsub("[\"\\]", "", strsplit(mut, ", ")[[1]])
    newmut = list(get_name(newmut, ref_muts)) # Calls get_name()^
  }
  return (newmut) # Returns as list, so it can be stored in dataframe
}

# Dplyr code to rapidly process the entire dataset
df_isolate <- df_isolate %>%
  group_by(row.names(df_isolate)) %>%
  mutate(Mutations = I(clean_mut(Mutations, mutations_ref)), # calls clean_mut()
         Date = clean_date(Date)) # Cwhile we're here, formatting the date colu

# Delete temp row.names column
df_isolate = df_isolate[-8]
