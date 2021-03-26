dat <- read.csv('./Dataset/sequences.csv')
library(dplyr)
library(stringr)
dat <- dat %>% filter(Nuc_Completeness == 'complete') %>% filter(Geo_Location != '')

dat_USA <- dat %>% filter(str_detect(Geo_Location, 'USA'))
dat_CHINA <- dat %>% filter(str_detect(Geo_Location, 'China'))
dat_AUSTRALIA <- dat %>% filter(str_detect(Geo_Location, 'Australia'))
dat_INDIA <- dat %>% filter(str_detect(Geo_Location, 'India'))
dat_JAPAN<- dat %>% filter(str_detect(Geo_Location, 'Japan'))

dat <- dat %>% filter(Nuc_Completeness == 'complete') %>% filter(Geo_Location != '')

