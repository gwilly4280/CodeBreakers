dat <- read.csv('./Dataset/sequences.csv')
library(dplyr)
dat <- dat %>% filter(Nuc_Completeness == 'complete') %>% filter(Geo_Location != '')
