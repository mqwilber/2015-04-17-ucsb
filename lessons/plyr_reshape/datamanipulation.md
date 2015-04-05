---
layout: lesson
root: ../..
title: Data Manipulation - reshape2 and plyr
---

*Test - Umi Hoshijima* 

Sources: http://seananderson.ca/2013/10/19/reshape.html
http://rpubs.com/justmarkham/dplyr-tutorial
https://github.com/datacarpentry/R-dplyr-ecology/blob/master/03-data-analysis.Rmd

As scientists, we format datasheets to make our data entry intuitive. However, different forms of data analysis in R can require data in different formats. Manipulating data for various analyses and visualization can be facilitated by the package `reshape2`.

For our example, we will look at our dataset "irises", which is a famous dataset that measures the length and width of both sepals and petals on three species of irises (50 individuals each, 150 flowers total). This data is located in the "data" directory, and is called `iris.csv`. 

> ### EXERCISE 1 - Importing the `iris` dataset
>
> Import the data using the R console commands, and look at the first several lines.

The point of this dataset is to use flower shapes to characterize the different species. In order to do this, let's use our newfound ggplot skills to make a scatterplot, plotting `Sepal.Length` against `Sepal.Width`, and coloring the dots by `Species`. 

    library(ggplot2)
    ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species))+geom_point()

Great! Now let's instead view them as different subplots:

    ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width))+geom_point() + facet_wrap(~Species)

This data seems perfectly formatted for these plots. Each individual has a single row, with it species and each of its values. Let's now do a boxplot, comparing the distribution of `Sepal.Length` between each species:

    ggplot(iris, aes(x = Species, y = Sepal.Length))+geom_boxplot()

Great! Now can we make individual graphs doing this for the other measurements? Well, you can do individual plots, calling a different y value each time, but that's tedious. What you really want is to be able to use `facet_wrap` to split up your data. We just used `facet_wrap` to separate our data by `Species`, which we can do because we have a column for that. How can we make a column for our different measurements (`Sepal.Length`, `Sepal.Width`, etc.) and have a row for each individual measurement?

Essentially we want to go from this: 


| Sepal.Length | Sepal.Width | Petal.Length | Pedal.Width | Species |
|--------------|-------------|--------------|-------------|---------|
| 5.1          | 3.5         | 1.4          | 0.2         | setosa  |
| 4.9          | 3.0         | 1.4          | 0.2         | setosa  |
| 4.7          | 3.2         | 1.3          | 0.2         |         |

Luckily for us, there's a package in R called `reshape2` that can help you manipulate datasets like this. '



However, we encounter problems when we want to make a boxplot for each of these. If I want to compare the `Sepal.Length` distribution between species, 

* reshape to vertical using melt, show how to do the opposite using dcast. 
* explain dplyr - split-apply-recombine .
* use dplyr to do summary based on one or many variables. 
* 
* graph using ggplot? 
* 