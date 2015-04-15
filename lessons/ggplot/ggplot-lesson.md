---
layout: lesson
root: ../..
title: ggplot
---

*by Thomas C. Smith, based on material by Naupaka Zimmerman, Andrew Tredennick, & Kartik Ram*

**Supplementary Material**: [answers to exercises](ggplot-lesson-answers.R)

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

ggplot2 Pros: | ggplot2 Cons:|
---------------|---------------|
consistent, concise syntax | different syntax from the rest of R|
intuitive (to many) | does not handle a few types of output well (e.g. NMDS output)|
visually appealing by default | |
entirely customizable | |

base graphics Pros:     |base graphics Cons:|
------------------------|-------------------|
simple, straightforward for simple plots| syntax gets cumbersome for complex figures especially those with separate panels or requiring lots of indexing to show treatments/groups.|
entirely customizable|fiddly for adjusting positions, sizes, etc.| 

***
# Getting Started:

Here's how to install ggplot2:

    install.packages("ggplot2", dependencies = TRUE)  
    library("ggplot2")

Other packages that will enhance ggplots:

  - `ggthemes, gridExtra, devtools, colorbrewer` and many, many others.

> Tip: **`qplot`** - You may come across `qplot` as a function within `ggplot2` that allows you to make quick plots without really learning ggplot2 syntax.  Don't bother, just learn ggplot!.

***
#Parts of a ggplot plot:
There are several essential parts of any plot, and in `ggplot2`, they are:
  
  1. the function: `ggplot()`
  2. the arguments:
    - **data**
    - **aes**
    - **geom**
    - stats
    - facets
    - scales
    - theme
    - ...and others

We won't cover these in much depth, but if you are comfortable with what we show you today, exploring the vast functionality of `geom, stats, scales, and theme` should be a pleasure.
***
##`ggplot()`
Some people like to assign (`<-`) their plot function to a variable, like this:

    myplot<-ggplot(...)
***
##`data`
- This is the data you want to plot
- Must be a data.frame

For this lesson, we are going to look at the `iris` data set that lives in R.

    head(iris)  

Let's **build** a scatter plot of Sepal Length and Sepal Width

    myplot<-ggplot(data=iris... )


***
##`aes` 
For **aes**thetics.

How your data are to be visually represented.  One of your variables will be your independent (x) variable, another will be your dependent (y) variable.

- some people call this *mapping*
- which data on the x
- which data on the y
- also: color, size, shape, transparency
  


    myplot<-ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))
    summary(myplot)  

So far, we have told ggplot where to look for data, and how to represent that data, but not what to do with it.
***
##`geom` 
For **geom**etry.  
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

    myplot<-ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))  
    myplot+geom_point()  
    summary(myplot)  

###Changing the aesthetics of a `geom`:  
Lets increase the size of the data points...  

    ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+  
    geom_point(size=3)


...or add some **useful** color:

    ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species))+  
    geom_point(size=3)


Using color to differentiate data points with respect to species allows us to see that *setosa* has a pretty distinct sepal length-width relationship, relative to the other two species.  

If you need to use black and white, you can differentiate points by shape:  

    ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width, shape=Species))+  
    geom_point(size=3)


or, exactly the same result:

    ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+
    geom_point(aes(shape=Species), size=3)


If you dont like those shapes, set some other shapes:

    ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+ 
    geom_point(aes(shape=Species), size=3)+
    scale_shape_manual(values=c(1,2,16))

Here we used a `geom_scale` to map specific point shapes onto their species values.  If aes() maps shape or color to a grouping variable, then you can use a scale geom to set the values for your shape or color.

### geoms for summarization:
**Boxplot**:  

    ggplot(data=iris, aes(x=Species, y=Sepal.Width))+
    geom_boxplot()


**Histogram** - here you need only specify one vector to be visualized in your `aes()`:

    ggplot(data=iris, aes(x=Sepal.Width))+  
    geom_histogram()

> Tip: For most histograms, don't feel like you are not challenging yourself if you still use `hist()` in base graphics: Its often much less typing.

***
## `facets`
Facets are panels in which plots of mapped variables are arranged according to a categorical grouping variable(s).  

In the `iris` dataset, we can use Species as the grouping variable:

    ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+  
    geom_point(size=3)+  
    facet_grid(.~Species)

Specifying the group variable on the left `facet_grid(Species~.)` arranges facets in one column, on the right `facet_grid(~.Species)` in one row.  You can also facet by two (or more) grouping variables.  If we had a categorical site variable in `iris`, that would look like `facet_grid(Site~Species)`

You can also use `facet_wrap()`, which we will show you in the next lesson.

***
# Exercise 1:
  > a) Reproduce the boxplot of Blood Pressure vs. Gender (the `aneurysm` data we were calling `dat` yesterday) using your new `ggplot2` skills.  
  
  > b) What can you do to see if the pattern is similar throughout all three Groups?


## `stats`
For `stats`istics.  
The `geom_boxplot()` and `geom_histogram()` are stats components, and there are a bunch. We don't have a lot of time to cover these, but they are extremely valuable, especially if you are using ggplot2 for reporting results, rather than just exploratory plotting.  

Here is another: you can add a linear fit line to a scatter plot:

    ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+  
    geom_point(size=3)+  
    geom_smooth(method=lm)  

***
## `theme` and controlling figure appearance
Themes allow you to specify how the non-data components of your figure look, e.g. legends, axis labels, and backgrounds.

First though, there are ways to control the appearance of your data points by setting a value to them, or mapping them to a grouping variable. You can do this in the aes() or in the geom, but any character of the plot you set in `aes()` becomes a global setting for your figure.  For axample, if you set `aes(..., color=pink)`, then all the data in your figure will be pink, no matter what (or how many) geoms you map to the variables.

You can control the non-data elements (text, axes, legends) using themes.
Using our color-coded scatterplot of Sepal Width vs Sepal Length, lets add a theme to make our figure worthy of our next committee meeting.

Rerun the code to see how the plot looked by default:

    ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width))+
    geom_point()

But with theme, it could look like:

    ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width,color=Species))+
    geom_point(size=3)+
    theme(legend.key=element_rect(fill=NA),
        legend.position="bottom",
        axis.title=element_text(angle=0, size=18, face="bold"),
        legend.text=element_text(angle=0, size=12, face="bold"),
        panel.background=element_rect(fill=NA))


Obviously, one can really go nuts with her/his themes... and create your own customs:

    install.packages("wesanderson")
    library(wesanderson)

To see color palettes:

    wes_palette("Royal1")

For those studying predation/medium sized mammals/trophic cascades, try:

    wes_palette("FantasticFox")
    
...and for the marine biologists (or their interns):

    wes_palette("Zissou")
    ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + 
    geom_point(size = 7) + 
    scale_color_manual(values = wes_palette("Zissou")) + 
    theme_gray()



***
##Saving a ggplot figure:
You can use the same approach we showed in the basic plotting lesson, or try this:

    ggsave("myplot.jpg", width=8, height=8, unit="cm", dpi=300)

In both methods, you can save as most any image format (jpeg, TIFF, PNG, PDF, etc.), as well as specify the size and resolution (dpi) of the image.

***
##Lastly:
> Tip: ggplot2 will probably not replace all other graphics tools.  You may still use base graphics, and you may export ggplot figures to Powerpoint or Photoshop for final labeling and composition, or to combine figures and images.

Graphics are an important part of the beginning - data exploration - and end -  presentation of results - of the analysis process.  We hope we have shown you the building blocks for making excellent figures!

***
# Exercise 2:
  > Using the `iris` data, create a faceted figure that includes three panels, one for each species; each panel should include a scatter plot of Petal.Width vs. Petal.Length; lastly, include a linear fit on each panel.  Manipulate the theme to improve the appearance of the figure.
  
  > Save your figure and email it to your advisor, with the subject line "For your refrigerator!"



