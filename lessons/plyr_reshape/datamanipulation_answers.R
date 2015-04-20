
###Exercise 1

#load ggplot2, if you haven't already. Also install and load reshape2.
library(ggplot2)
install.packages("reshape2")
library(reshape2)
#read in data from whereever it lies on your computer. 
dat = read.csv("aneurysm_data_site-1.csv")

#"melt" data by specifying rows you want to keep. Values in unspecified columns will be aggregated into a single column. 
# We'll specify all rows except for the last four aneurysm statistics. 
dat2 = melt(dat, id.vars = c("ID", "Gender", "Group", "BloodPressure", "Age"))
#x axis will show Blood Pressure, y axis will show value of the aneurysm statistic
plotAneur = ggplot(data = dat, aes(x = BloodPressure, y = value)+
  #scatterplot these data, with the colour corresponding to the Age of the patient. 
  #Both the british and american spellings of "colour"/"color" work here. 
  geom_point(aes(colour = Age))+
  #split the scatterplot by "variable", which is the new column that was created by "melt" that includes the column names each datum came from. 
  facet_wrap(~variable)
#Display.
plotAneur

#To retrace your steps using dcast(), we will reference the same variables that we wanted to keep with "melt", as well as the column which has the factors that we wish to turn into new columns. 
#Syntax: dcast(data, columns+you+want+to+keep ~ columnOfVariables, 
dat3 = dcast(dat2, ID+Gender+Group+BloodPressure+Age ~ variable)



###Exercise 2
#

### Exercise 3
#how many setosa have a Sepal Length greater than 5?
a = filter(iris, Species== "setosa", Sepal.Length>5)
nrow(a) #number of rows of 'a',which would correspond to the number of individuals that conform to these requirements. 
#answer here should be 22. 
# Species with the longest petal length:
short_petals = arrange(iris, Petal.Length) 
short_petals[1,"Species"] #returns the species name for row 1.shortest is setosa
#you could do this in one line as such: arrange(iris, Petal.Length) [1,"Species"]
long_petals = arrange(iris, desc(Petal.Length)) #Longest is virginica
long_petals[1,"Species"]
#you could also do this in one line as above. 
#you could also do this by looking at the last line in short_petals,
#using nrow to get the number of rows in a, which is also the index for the last row in a:
short_petals[nrow(a),"Species"] 

###Exercise 3
#Iris with longest average sepals:
a = iris %>% #Take the iris data
  group_by(Species) %>% #separate by species
  summarize(mean_sepal = mean(Sepal.Length)) %>% #get the average sepal length in another new dataframe.
  arrange(desc(mean_sepal)) #Arrange so largest mean sepal length is at the top. 
  
# Species mean_sepal
# 1  virginica      6.588
# 2 versicolor      5.936
# 3     setosa      5.006

#The longest mean sepal length belongs to virginica. 


#mammal with the largest body length:mass ratio:
b = mammals %>% #We'll save the output in variable 'b'.
  #Transform will add this column to the existing data.frame, unlike summarize which will make a new one. 
  #we don't group_by() anything because we want to do this calculation on individuals. 
  transform(length_to_mass = adult_head_body_len_mm / adult_body_mass_g) %>%
  #Arrange by this new column, with highest values first. 
  arrange(desc(length_to_mass)) %>%
  #To reduce clutter, let's get rid of columns we aren't interested in. ONly displaying species and length_to_mass. 
  select(species, length_to_mass)
#The vespertilinoid bat is the longest length relative to body mass. 
