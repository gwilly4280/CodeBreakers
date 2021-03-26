dat <- read.csv('./Dataset/sequences.csv')
library(dplyr)
library(stringr)

dat <- read.csv('./Dataset/sequences.csv')

# Filter dataset by completeness
dat <- dat %>% filter(Nuc_Completeness == 'complete')

# Collect country
dat_USA <- dat %>% filter(str_detect(Geo_Location, 'USA')) %>% slice_sample(n = 100)

dat_CHINA <- dat %>% filter(str_detect(Geo_Location, 'China'))%>% slice_sample(n = 100)

dat_AUSTRALIA <- dat %>% filter(str_detect(Geo_Location, 'Australia')) %>% slice_sample(n = 100)

dat_INDIA <- dat %>% filter(str_detect(Geo_Location, 'India'))%>% slice_sample(n = 100)

dat_JAPAN<- dat %>% filter(str_detect(Geo_Location, 'Japan'))%>% slice_sample(n = 100)

# Dataset with the selected countries
countries <- data.frame(dat_JAPAN, dat_INDIA, dat_AUSTRALIA, dat_CHINA, dat_USA)
