library(stringr)
library(dplyr)
library(scatterpie)
library(tidyr)
library(reshape2)
library(ggmap)

#########Reformatting the mutations.csv data
df<-mutations
spl<-str_split(df$Countries, ";")
#### The current df has multiple countries and their frequencies of the mutation in a cell
## This code splits the countries andn frequencies into separate columns
chartdat<-data.frame(Designation = rep(df$Designation, sapply(spl, length)), quant = unlist(spl))
my.data.num <- as.numeric(str_extract(chartdat$quant, "[0-9]+"))
my.data.cha <- (str_extract(chartdat$quant, "[aA-zZ]+"))
datfram<-data.frame(Designation = rep(df$Designation, sapply(spl, length)),Country =my.data.cha, freq= my.data.num)


##Slicing the top 10 most frequent mutations in each country
topmut<-arrange(datfram, Country, desc(freq))
topmut<-topmut %>% slice_head(n = 10)
topmut<-topmut[-c(106:114,146:151,162:171),-c(1)]
#### Reshape in order to make the columns different mutations and fill in empty cells in the data
topmut$id <- ave(as.character(z$Country), topmut$Country, FUN = seq_along)

new<-dcast(topmut, Country ~ id, value.var="freq")
geonew<-new[-c(18,23),]
geonew[is.na(geonew)] <- 0
#####Pulling the long and lat for each country using google maps api

register_google(key="AIzaSyDoi6Olbj77dHMgyZyfkLYNvJT55gUw4OA")
geonew<-mutate_geocode(newt, Country,output = c("latlon"))
geonew<-geonew %>% relocate(lat,lon)



#Scatterpie code that will not work
ggplot() + geom_scatterpie(aes(x=geonew$lon, y=geonew$lat, group=geonew$Country), data=geonew,
                           cols=geonew[,c(4:13)] + coord_equal())
ggplot(geonew, aes(lon,lat))+geom_point()
p <- ggplot(geonew, aes(variable,value,fill=variable)) + geom_bar(stat="identity")
p + coord_polar() + facet_wrap(~X+Y,,ncol=6) + theme_bw()

world <- map_data('world')
p <- ggplot(world, aes(lon, lat)) +
  geom_map(map=world, aes(map_id=region), fill=NA, color="black") +
  coord_quickmap()
p + geom_scatterpie(aes(x=geonew$lon, y=geonew$lat, group=Country),
                    data=geonew, cols=geonew[,4:14], color=NA, alpha=.8)

d<-d[-c(26:50),]



######A different approach with different dat frame

#a function to pivot by country and keep designation
pivot_by_country <- function(data) {

  s1 = melt(data, id = c("Country", "Designation"), measure.vars = "freq")
  s2 = dcast(s1, Country ~ Designation, sum)

  s2$Total = rowSums(s2[,2:NCOL(s2)])
  return(s2)
}
#Pivotting and cleaning up new df
pivot<-pivot_by_country(w)
pivot = pivot[-c(18,27,29),-c(116)]
pivot<-mutate_geocode(pivot, Country,output = c("latlon"))
pivot<-pivot %>% relocate(Country,lat,lon)

###As Factor
pivot$Country<- as.factor(pivot$Country)
ggplot() + geom_scatterpie(aes(x=pivot$lon, y=pivot$lat, group=Country), data=pivot,cols =pivot[,c(2:114)]) + coord_equal()
ggplot() + geom_scatterpie(aes(x=lon, y=lat), data=pivot, cols=c(2:115)) + coord_fixed()
as.numeric(pivot$freq)

worldmap <- map_data ("world")

mapplot1 <- ggplot(worldmap) +
  geom_map(data = worldmap, map = worldmap, aes(x=long, y=lat, map_id=region), col = "white", fill = "gray50") +
  geom_scatterpie(aes(x=lon, y=lat, group = Country, r = 10),
                  data = geonew, cols = colnames(geonew[,c(4:13)]))

mapplot1

chartdat<-data.frame(Designation = rep(df$Designation, sapply(spl, length)), quant = unlist(spl))
chartdat %>%
  separate(chartdat$quant,
           into = c("text", "num"),
           sep = "(?<=[A-Za-z])(?=[0-9])"
  )
