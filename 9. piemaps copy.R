### 9th file in the workflow ###

library(stringr)
library(dplyr)
library(scatterpie)
library(tidyr)
library(reshape2)
library(ggmap)
library(readr)
#########Reformatting the mutations.csv data
mutations <- read_csv("Dataset/mutations.csv")
df<-mutations
spl<-str_split(df$Countries, ";")
#### The current df has multiple countries and their frequencies of the mutation in a cell
## This code splits the countries and frequencies into separate columns
chartdat<-data.frame(Designation = rep(df$Designation, sapply(spl, length)), quant = unlist(spl))
my.data.num <- as.numeric(str_extract(chartdat$quant, "[0-9]+"))
my.data.cha <- (str_extract(chartdat$quant, "[aA-zZ]+"))
datfram<-data.frame(Designation = rep(df$Designation, sapply(spl, length)),Country =my.data.cha, freq= my.data.num)


##Slicing the top 10 most frequent mutations in each country
topmut<-arrange(datfram, Country, desc(freq))
topmut<-topmut %>% group_by(Country)%>%
  slice_head(n = 10)
topmut<-topmut[-c(106:114,146:151,162:171),-c(1)]
#### Reshape in order to make the columns different mutations and fill in empty cells in the data
topmut$id <- ave(as.character(topmut$Country), topmut$Country, FUN = seq_along)

new<-dcast(topmut, Country ~ id, value.var="freq")
geonew<-new[-c(18,23),]
geonew[is.na(geonew)] <- 0
#####Pulling the long and lat for each country using Google maps api

register_google(key="AIzaSyDoi6Olbj77dHMgyZyfkLYNvJT55gUw4OA")
geonew<-mutate_geocode(geonew, Country,output = c("latlon"))
geonew<-geonew %>% relocate(lat,lon)


#Using world map data and  our long and lat to plot pie charts
worldmap <- map_data ("world")

piemap <- ggplot(worldmap) +
  geom_map(data = worldmap, map = worldmap, aes(x=long, y=lat, map_id=region), col = "white", fill = "gray50") +
  geom_scatterpie(aes(x=lon, y=lat, group = Country, r = 10),
                  data = geonew, cols = colnames(geonew[,c(4:13)]))

piemap

