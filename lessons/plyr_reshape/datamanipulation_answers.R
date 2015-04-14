
###Exercise 1
#get to the correct file
setwd("~/Desktop/2015-04-17-ucsb/data/")
#load the file
iris = read.csv("iris.csv")
#load ggplot2, if you haven't already
library(ggplot2)
#plot using geom_point().
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species))+geom_point()

###Exercise 2
#

### Exercise 3
#how many setosa have a Sepal Length greater than 5?
a = filter(iris, Species== "setosa", Sepal.Length>5)
dim(a) #length, and width, of a.
# Species with the longest petal length:
head(arrange(iris, Petal.Length)) #shotest is setosa
head(arrange(iris, desc(Petal.Length))) #Longest is virginica

###Exercise 4
#Iris with longest average sepals:
a = iris %>% #Take the iris data
  group_by(Species) %>% #separate by species
  summarize(mean_sepal = mean(Sepal.Length)) #get the average sepal length
#mammal with the largest body length:mass ratio:
a = mammals %>%
  transform(length_to_mass = adult_head_body_len_mm / adult_body_mass_g) %>%
  arrange(desc(length_to_mass)) %>%
  select(species, length_to_mass)
#The vespertilinoid bat is the longest length relative to body mass. 