dat <- read.csv('./Dataset/sequences.csv')
library(dplyr)
library(stringr)

dat <- dat %>% filter(Nuc_Completeness == 'complete') %>% filter(Geo_Location != '')

dat_USA <- dat %>% filter(str_detect(Geo_Location, 'USA')) %>% mutate(Geo_Location = "USA")
dat_CHINA <- dat %>% filter(str_detect(Geo_Location, 'China')) %>% mutate(Geo_Location = "CHN")
dat_AUSTRALIA <- dat %>% filter(str_detect(Geo_Location, 'Australia')) %>% mutate(Geo_Location = "AUS")
dat_INDIA <- dat %>% filter(str_detect(Geo_Location, 'India')) %>% mutate(Geo_Location = "IND")
dat_JAPAN<- dat %>% filter(str_detect(Geo_Location, 'Japan')) %>% mutate(Geo_Location = "JPN")
