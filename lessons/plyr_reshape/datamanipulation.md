---
layout: lesson
root: ../..
title: Data Manipulation - reshape2 and plyr
---

*Test - Umi Hoshijima* 

Sources: http://seananderson.ca/2013/10/19/reshape.html
http://rpubs.com/justmarkham/dplyr-tutorial
https://github.com/datacarpentry/R-dplyr-ecology/blob/master/03-data-analysis.Rmd


Reshaping data in R
-----

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
| 4.7          | 3.2         | 1.3          | 0.2         | setosa  |

To this:

| Species | Individual | Measurement  | Value |
|---------|------------|--------------|-------|
| setosa  | 1          | Sepal.Length | 5.1   |
| setosa  | 1          | Sepal.Width  | 3.5   |
| setosa  | 1          | Petal.Length | 1.4   |
| setosa  | 1          | Petal.Width  | 0.2   |
| setosa  | 2          | Sepal.Length | 4.9   |
| setosa  | 2          | Sepal.Width  | 3.0   |
| setosa  | 2          | Petal.Length | 1.4   |
| setosa  | 2          | Petal.Width  | 0.2   |
| setosa  | 3          | Sepal.Length | 4.7   |
| setosa  | 3          | Sepal.Width  | 3.2   |
| setosa  | 3          | Petal.Length | 1.3   |
| setosa  | 3          | Petal.Width  | 0.2   |

Luckily for us, there's a package in R called `reshape2` that can help you manipulate datasets like this. This package has two key functions: `melt` and `dcast`. For what we want to do (get rid of columns, add rows), we would use `melt`. For the opposite, use `dcast`. Think of it like working with metal - you can *melt* metal to elongate it vertically, and you can *cast* it to go back.

To add the `individual` column into our result, let's first make that column in our `iris` dataframe. the function `dim` gives us a list with 2 values: the rows and columns in the dataframe. We only want the number of rows, so we're going to go with:'

    nRows = dim(iris)[1]
    iris$Individual = 1:nRows

Now we can melt! Let's see what happens when we call the function:

    library(reshape2)
    iris2 = melt(iris)
    View(iris2)

Huh, that didn't do exactly what we wanted it to do. By default, `melt` will get rid of all columns with numerical values. Since we want to hold on to the `Individual` row, we have to manually tell `melt` what columns we want to keep.

    iris2 = melt(iris, id.vars =  c("Individual", "Species"))

Now let's plot our boxplot:

    ggplot(iris2, aes(x = Species, y = value))+geom_boxplot()+facet_wrap(~variable)

As an exercise, let's put our data back to its original shape using`dcast`. This has a slightly different syntax, and is in the shape of a formula. We put our id variables (the same ones we specified in `melt`) on the left of the `~`, and put the `variable` on the right. 

    iris3 = dcast(iris2, Individual+Species~variable)

This forumla can be a bit unintuitive at first, so don't feel discouraged if you don't get it the first time!

> ### EXERCISE 2 - Some reshape2 trick
>
> 

Summarizing and Operating: the dPlyr world
---------------------------------

Let's go back to our '


