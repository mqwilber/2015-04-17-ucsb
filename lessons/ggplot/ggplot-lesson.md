---
layout: lesson
root: ../..
title: ggplot
---

*by Thomas C. Smith, based on material by Naupaka Zimmerman, Andrew Tredennick, & Kartik Ram*

#What is ggplot?

- The 'gg' stands for grammar of graphics.  
- A syntax for making plots and figures.
- Defines components of a figure.
- Coherent, consistent syntax for a range of plotting.

#### Compare to "base" graphics:

- `plot(BloodPressure~Age, data=dat)`

vs.

- `ggplot2(data=dat, aes(x=Age, y=BloodPressure)) + geom_point()`

# Why do we need another plotting method?

Both base R and `ggplot2` have limitations in different areas, and either can be used to make publication quality figures.  Arguably, ggplot excels over base graphics for data exploration and consistent syntax.

`ggplot` Pros: | `ggplot` Cons:|
---------------|---------------|
consistent, concise syntax | different syntax from the rest of R|
intuitive (to many) | does not handle a few types of output well (e.g. NMDS output)|
visually appealing by default | |
entirely customizable | |

base graphics Pros:     |base graphics Cons:|
------------------------|-------------------|
simple, straightforward for simple plots| syntax gets cumbersome for complex figures especially those with separate panels or requiring lots of indexing to show treatments/groups.|
entirely customizable|fiddly for adjusting positions, sizes, etc.|

# Getting Started:

* install.packages("ggplot2", dependencies = TRUE)

Other packages that will enhance ggplots:

  - `ggthemes, gridExtra, devtools, colorbrewer` and many, many others.

```{r}
library("ggplot2")
```

> Tip: **`qplot`** - You may come across `qplot` as a function within `ggplot2` that allows you to make quick plots without really learning ggplot2 syntax.  Don't bother, just lear.

#Parts of a ggplot plot:
There are several essential parts of any plot, and in `ggplot2`, they are:
  
  1. the function: `ggplot()`
  2. the arguments:
    a. **data**
    b. **aes**
    c. **geom**
    d. stats
    e. facets
    f. scales
    g. theme
    h. others

We won't cover all of these in much depth, but if you are comfortable with what we show you today, exploring the vast functionality of `geom, stats, scales, and theme` should be a pleasure.

##`ggplot()`
Some people like to assign (`<-`) their plot function to a variable, like this:

`myplot<-ggplot(...)`

##`data`
- This is the data you want to plot
- Must be a data.frame

```{r}
head(iris)
```

Let's **build** a scatter plot of Sepal Length and Sepal Width

`myplot<-ggplot2(data=iris... )`

##`aes` 
For **aes**thetics.

How your data are to be visually represented.  One of your variables will be your independent (x) variable, another will be your dependent (y) variable.

- some people call this *mapping*
- which data on the x
- which data on the y
- also: color, size, shape, transparency
- any character of the plot you set in `aes()` becomes a global setting for your figure.

```{r}
myplot<-ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))
summary(myplot)
```
So far, we have told ggplot where to look for data, and how to represent that data, but not what to do with it.

##`geom` for **geom**etry
This is how we create the layer we actually see as our figure.  
These are the geometric objects likes points, lines, polygons, etc. that are in the plot

  - `geom_point()`
  - `geom_line()`
  - `geom_boxplot()`
  - `geom_text()`
  - `geom_bar()`
  - `geom_hline()`
  - > 25 more!

Let's add a geom to make a scatter plot:
```{r}
myplot<-ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))
myplot+geom_point()
summary(myplot)
```
###Changing the aesthetics of a `geom`:
Let's increase the size of the data points...
```{r}
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+
  geom_point(size=3)
```

...or add some **useful** color:
```{r}
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species))+
  geom_point(size=3)
```

Using color to differentiate data points with respect to species allows us to see that *setosa* has a pretty distinct sepal length-width relationship, relative to the other two species.  

If you need to use black and white, you can differentiate points by shape:
```{r}
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width, shape=Species))+
  geom_point(size=3)
```

or, exactly the same result:
```{r}
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+
  geom_point(aes(shape=Species), size=3)
```

If you don't like those shapes, set some other shapes:
```{r}
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+
  geom_point(aes(shape=Species), size=3)+
  scale_shape_manual(values=c(1,2,16))
```
Here we used a `geom_scale` to map specific point shapes onto their species values.  If aes() maps shape or color to a grouping variable, then you can use a scale geom to set the values for your shape or color.

### geoms for summarization:
**Boxplot**:  

```{r}
ggplot(data=iris, aes(x=Species, y=Sepal.Width))+
  geom_boxplot()
```

**Histogram** - here you need only specify one vector to be visualized in your `aes()`:
```{r}
ggplot(data=iris, aes(x=Sepal.Width))+
  geom_histogram()
```
> Tip: For most histograms, don't feel like you are not challenging yourself if you still use `hist()` in base graphics: Its often much less typing.

## `facets`
**OMG**, we totes **LOVE** facets.

Facets are panels in which plots of mapped variables are arranged according to a categorical grouping variable(s).  

In the `iris` dataset, we can use Species as the grouping variable:

```{r}
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+
  geom_point(size=3)+
  facet_grid(.~Species)
```

Specifying the group variable on the left `facet_grid(Species~.)` arranges facets in one column, on the right `facet_grid(~.Species)` in one row.  You can also facet by two (or more) grouping variables.  If we had a categorical site variable in `iris`, that would look like `facet_grid(Site~Species)`

You can also use `facet_wrap()`, which we will show you in the next lesson.

## `stats`
The `geom_boxplot()` and `geom_histogram()` are stats components, and there are a bunch. We don't have a lot of time to cover these, but they are extremely valuable, especially if you are using ggplot2 for reporting results, rather than just exploratory plotting.  

Here is another: you can add a linear fit line to a scatter plot:

```{r}
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+
  geom_point(size=3)+
  geom_smooth(method=lm)
```

## `theme`
Themes allow you to specify how the non-data components of your figure look, e.g. legends, axis labels, and backgrounds.

Using our color-coded scatterplot of Sepal Width vs Sepal Length, lets make our axis labels and such worthy of our next committee meeting.

By default it looked like:

```{r echo=FALSE}
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+
  geom_point()
```

But it could look like:

```{r}
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width,color=Species))+
  geom_point(size=3)+
  theme(legend.key=element_rect(fill=NA),
        legend.position="bottom",
        axis.title=element_text(angle=0, size=18, face="bold"),
        legend.text=element_text(angle=0, size=12, face="bold"),
        panel.background=element_rect(fill=NA))
```

Obviously, one can really go nuts with her/his themes... 

```{r}
library("wesanderson")
```

...and create your own custom themes.

##Saving a ggplot figure:
You can use the same approach we showed in the basic plotting lesson, or try this:

```{r}
ggsave("myplot.jpg", width=8, height=8, unit="cm", dpi=300)
```

In both methods, you can save as most any image format (jpeg, TIFF, PNG, PDF, etc.), as well as specify the size and resolution (dpi) of the image.

##Lastly:
> Tip: ggplot2 will probably not replace all other graphics tools.  You may still use base graphics, and you may export ggplot figures to Powerpoint or Photoshop for final labeling and composition, or to combine figures and images.

Graphics are an important part of the beginning - data exploration - and end -  presentation of results - of the analysis process.  We hope we have shown you the building blocks for making excellent figures!

# Examples

# Exercise 1:
  > a) Reproduce the boxplot of Blood Pressure vs. Gender (the `aneurysm` data we were calling `dat` yesterday) using your new `ggplot2` skills.
  > b) What can you do to see if the pattern is similar throughout all three Groups?

### Answer to Exercise 1: ###
recall that:
dat<-read.csv("C://Users//Thomas//Documents//2015-04-17-ucsb//data//aneurysm_data_site-1.csv", header = TRUE)
index_m<-dat$Gender=='m'
index_f<-dat$Gender=='f'
index_M<-dat$Gender=='M'
index_F<-dat$Gender=='F'
#
dat$GenderCorrected<-NULL
dat$GenderCorrected[index_f]<-"Female"
dat$GenderCorrected[index_F]<-"Female"
dat$GenderCorrected[index_m]<-"Male"
dat$GenderCorrected[index_M]<-"Male"
#
#par(mar=c(5,5,1,1))
#boxplot(BloodPressure~GenderCorrected, data=dat, 
#        ylim=c(50,200),
#        ylab=c("Blood Pressure (mm Hg)"), xlab=c("Gender"),
#        col="light grey",
#        cex.axis=2, cex.lab=2, 
#        font.lab=2,
#        lwd=4)
#abline(mean(dat$BloodPressure),0)

#answer:
# Part A:
ggplot(data=dat, aes(x=GenderCorrected, y=BloodPressure))+
  geom_boxplot()
#Part B:
ggplot(data=dat, aes(x=GenderCorrected, y=BloodPressure))+
  geom_boxplot()+
  facet_wrap(~Group)
  


# Exercise 2:
  > Using the `iris` data, create a faceted figure that includes three panels, one for each species; each panel should include a scatter plot of Petal.Width vs. Petal.Length; lastly, include a linear fit on each panel.  Manipulate the theme to improve the appearance of the figure.

### Answer to Exercise 2: ###

str(iris)
ggplot(data=iris, aes(x=Petal.Length, y=Petal.Width))+
  geom_point()+
  geom_smooth(method="lm")+
  facet_wrap(~Species, scales="free_x")


