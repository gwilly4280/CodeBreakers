library(dplyr)
library(stringr)

### FILE 1 IN WORKFLOW ###
# Subsetting the data by country, and filtering by completeness to create a
# better dataset to answer our biological questions.

# Loading Sequence data & filtering by completeness, trimming un-used cols
dat <- read.csv('./Dataset/sequences.csv') %>%
  filter(Nuc_Completeness == "complete") %>%
  transmute(Accession, Length, Geo_Location, Collection_Date)

# Setting number of samples per country:
N <- 50

# Set seed for replicability
set.seed(1)

# Filter dataset by country, and sampling N random samples from each
dat_USA <- dat %>%
  filter(str_detect(Geo_Location, 'USA')) %>%
  mutate(Geo_Location = "USA") %>%
  slice_sample(n = N)

dat_CHINA <- dat %>%
  filter(str_detect(Geo_Location, 'China')) %>%
  mutate(Geo_Location = "CHN") %>%
  slice_sample(n = N)

dat_AUSTRALIA <- dat %>%
  filter(str_detect(Geo_Location, 'Australia')) %>%
  mutate(Geo_Location = "AUS") %>%
  slice_sample(n = N)

dat_INDIA <- dat %>%
  filter(str_detect(Geo_Location, 'India')) %>%
  mutate(Geo_Location = "IND") %>%
  slice_sample(n = N)

dat_JAPAN <- dat %>%
  filter(str_detect(Geo_Location, 'Japan')) %>%
  mutate(Geo_Location = "JPN") %>%
  slice_sample(n = N)

# Dataset with the selected countries
countries <- rbind(dat_JAPAN, dat_INDIA, dat_AUSTRALIA, dat_CHINA, dat_USA)

# Removing the temp data files
rm(dat, N, dat_AUSTRALIA, dat_CHINA, dat_USA, dat_INDIA, dat_JAPAN)
