---
layout: lesson
root: ../..
title: Data, plotting, and analysis 
---

*Edited and updated by Mark Wilber, Original material from Tom Wright*

**Supplementary Material**: [Data from 5 sites as zip](../../data/anuerysm_data.zip), [answers to exercises](R_data_plotting_analysis_answers.R)

For this lesson we are going to be using 5 datasets in which 100 patients were were examined and 9 variables about the patients were recorded such as anuerisms, blood pressure, age, etc.  Download the data by clicking [here](../../data/anuerysm_data.zip) or by clicking the **Supplementary Material** link above and save the data file into the directory `~/Desktop/workshop/`. 

The datasets we will use in this workshop are stored in comma-separated values (CSV) format: each row holds information for a single patient, and the columns represent different variables of that patient.

With this dataset, we want to:

* Load that data into memory
* Calculate the average values for the different variables across patients, and
* Plot some results

**Objectives**

* Read tabular data from a file into a program.
* Assign values to variables.
* Select individual values and subsections from data.
* Perform operations on a data frame of data.
* Display simple graphs.

### 1. Loading Data

To load our data, first we need to locate our data.
We can change the current working directory to the location of the CSV files using the function `setwd` (meaning "set the working directory")
For example, if the CSV files are located in a directory named `workshop` on our Desktop, we would change the working directory using the following command:

    setwd("~/Desktop/workshop/")

Just like in the Unix Shell, we type the command and then press `Enter` (or `return`).
Alternatively you can change the working directory using the RStudio GUI using the menu option `Session` -> `Set Working Directory` -> `Choose Directory...`

Now we could load the data into R using `read.csv`:

    dat <- read.csv("anuerysm_data_site-1.csv", header = TRUE)

The expression `read.csv(...)` asks R to run the function `read.csv`

`read.csv` has two [arguments](../../gloss.html#argument): the name of the file we want to read, and whether the first line of the file contains names for the columns of data.
The filename needs to be a character string (or [string](../../gloss.html#string) for short), so we put it in quotes.
Assigning the second argument, `header`, to be `TRUE` indicates that the data file does have column headers.

> **Tip:** `read.csv` actually has many more arguments that you may find useful when importing your own data in the future. You learn more about these options by typing `?read.csv`

### 2. Examining the data structure

Now that our data is in memory, we can start doing things with it. 
First, let's ask what type of thing `dat` *is*:

    class(dat)

The output tells us that data currently is a data frame in R. 
This is similar to a spreadsheet in Excel that many of us are familiar with using.
Data frames are very useful for storing data because you can have a continuous variable, e.g. rainfall, in one column and a categorical variable, e.g. month, in another.

Here are some useful dataframe functions

#### Useful data frame functions

* `head()` - shown first 6 rows
* `tail()` - show last 6 rows
* `dim()` - returns the dimensions
* `nrow()` - number of rows
* `ncol()` - number of columns
* `str()` - structure of each column
* `names()` - shows the `names` attribute for a data frame, which gives the column names.

For example, we can look at the first few rows of our data set by typing

    head(dat)

Equivalently, you could just look at your data in the RStudio viewer!

### 3. Column types

A data frame is made up of columns of data. The columns do not have to have the same type.

We can use the `class()` function to examine a single column.
    
    dat[,5]
    class(dat[,5])

The type `factor` is a very useful column type in R.

The function `str()` gives information about all the columns in a dataframe.

    str(dat)

We see the first two columns (ID and Gender) are type factor. Factors are a very useful datatype in R and we will look at them in detail next. The Group column is a logical datatype (values are `TRUE` or `FALSE`). 5 columns (BloodPressure, Aneurisms_q1-4) are all type integer. One column is type num (Age).

### 4. Addressing data

There are 3 main ways to address data in a data frame:
* By Index
* By Logical vector
* By Name (columns only)

#### 4.1 By Index
We can see the dimensions, or shape, of the data frame like this:

    dim(dat)

This tells us that our data frame, `dat`, has `150` rows and `5` columns.

If we want to get a single value from the data frame, we can provide an [index](../../gloss.html#index) in square brackets, just as we do in math:


    # First value in dat
    dat[1, 1]
    # Middle value in dat
    dat[30, 4]

An index like `[30, 20]` selects a single element of a data frame, but we can select whole sections as well. 
For example, we can select the first ten patients (rows) of values for the first four variables (columns) like this:

    dat[1:10, 1:4]

The slice `1:4` means, "Start at index 1 and go to index 4."

The slice does not need to start at 1, e.g. the line below selects rows 5 through 10:

    dat[5:10, 1:4]

We can use the function `c`, which stands for **c**ombine, to select non-contiguous values:

    dat[c(3, 8, 37, 56), c(1, 3, 6)]

We also don't have to provide a slice for either the rows or the columns.
If we don't include a slice for the rows, R returns all the rows; if we don't include a slice for the columns, R returns all the columns.
If we don't provide a slice for either rows or columns, e.g. `dat[, ]`, R returns the full data frame.

    # All columns from row 5
    dat[5, ]
    # All rows from column 4
    dat[, 4]

#### 4.2 Logical addressing

We have seen how to address data structures using an index. Logical addressing is another useful approach.  Logical vectors can be created using the `Relational Operators` that we saw in the first lessons. e.g. `< , > ,  == , !=`.
    
    # Get all Patients with ages greater than 18. Age is column 5
    x <- dat[, 5] > 18
    x
    dat[x, 5]

#### 4.3 By Name
Columns in a dataframe can be named. In our case these names came from the header row of the csv file. Column names can be listed with the `names()` command.

    names(dat)

Columns can be addressed using the `$` operator

    dat$Age
    dat$Gender

> **Exercise 1**
> A subsection of a data frame is called a slice.
> We can take slices of character vectors as well:
> 
>     element <- c("o", "x", "y", "g", "e", "n")
>     # first three characters
>     element[1:3]
>     # last three characters
>     element[4:6]
> 
> 1.  If the first four characters are selected using the slice `element[1:4]`, how can we obtain the first four characters in reverse order?
>2.  What is `element[-1]`?
    What is `element[-4]`?
    Given those answers, what does `element[-1:-4]` do?
> 3. Returning to the dataset, select all rows `dat` with lower case "m" for Gender.  How many are there?

### Combining indexing and assignment

We have seen how we slice data using indexing and how we can assign values to variables using the assignment operator.
We can combine these two operations:

    x <- c(5,3,7,10,15,13,17)
    x[x>10] <- 0

> **Exercise 2**
> 
> 1. Combine indexing and assignment to correct the Gender column so that all values of 'm' and 'f' are uppercase.

### 5. Factors

*This section is taken from the datacarpentry lessons git@github.com:datacarpentry/datacarpentry.git*

Factors are used to represent categorical data. Factors can be ordered or
unordered and are an important class for statistical analysis and for plotting.

Factors are stored as integers, and have labels associated with these unique
integers. While factors look (and often behave) like character vectors, they are
actually integers under the hood, and you need to be careful when treating them
like strings.

Once created, factors can only contain a pre-defined set values, known as
*levels*. By default, R always sorts *levels* in alphabetical order. For
instance, if you have a factor with 2 levels:

    sex <- factor(c("male", "female", "female", "male"))

R will assign `1` to the level `"female"` and `2` to the level `"male"` (because
`f` comes before `m`, even though the first element in this vector is
`"male"`). You can check this by using the function `levels()`, and check the
number of levels using `nlevels()`:

    levels(sex)
    nlevels(sex)

Sometimes, the order of the factors does not matter, other times you might want
to specify the order because it is meaningful (e.g., "low", "medium", "high") or
it is required by particular type of analysis. Additionally, specifying the
order of the levels allows to compare levels:

    food <- factor(c("low", "high", "medium", "high", "low", "medium", "high"))
    levels(food)
    food <- factor(food, levels=c("low", "medium", "high"))
    levels(food)
    min(food) ## doesn't work

    food <- factor(food, levels=c("low", "medium", "high"), ordered=TRUE)
    levels(food)
    min(food) ## works!

In R's memory, these factors are represented by numbers (1, 2, 3). They are
better than using simple integer labels because factors are self describing:
`"low"`, `"medium"`, and `"high"`" is more descriptive than `1`, `2`, `3`. Which
is low?  You wouldn't be able to tell with just integer data. Factors have this
information built in. It is particularly helpful when there are many levels
(like the subjects in our example data set).

### Converting factors

If you need to convert a factor to a character vector, simply use
`as.character(x)`.

Converting a factor to a numeric vector is however a little trickier, and you
have to go via a character vector. Compare:

    f <- factor(c(1, 5, 10, 2))
    as.numeric(f)               ## wrong! and there is no warning...
    as.numeric(as.character(f)) ## works...
    as.numeric(levels(f))[f]    ## The recommended way.

> **Exercise 3**
> 
> The function `table()` tabulates observations and can be used to create
> bar plots quickly. For instance:
> 
>    ## Question: How can you recreate this plot but by having "control"
>    ## being listed last instead of first?
>    exprmt <- factor(c("treat1", "treat2", "treat1", "treat3", "treat1", "control", "treat1", "treat2", "treat3"))
>    table(exprmt)
>    barplot(table(exprmt))

    exprmt <- factor(exprmt, levels=c("treat1", "treat2", "treat3", "control"))
    barplot(table(exprmt))

### Removing levels from a factor

In the previous challenge we updated the data for Gender. R still thinks the levels "m" and "f" are valid for the Gender data.

    levels(dat$Gender)

The `droplevels` function will remove any unused levels

    dat<-droplevels(dat)
    levels(dat$Gender)

### Manipulating Data

Now let's perform some common mathematical operations to learn about our inflammation data.
When analyzing data we often want to look at partial statistics, such as the maximum value per patient or the average value per eye. 
One way to do this is to select the data we want to create a new temporary data frame, and then perform the calculation on this subset:

    # first row, columns 6 to 9
    patient_1 <- dat[1, 6:9]
    # max aneurism for patient 1
    max(patient_1)

We don't actually need to store the row in a variable of its own. 
Instead, we can combine the selection and the function call:

    # max inflammation for patient 2
    max(dat[2, 6:9])

R also has functions for other commons calculations, e.g. finding the minimum, mean, median, and standard deviation of the data:

    # minimum number of aneurisms in quadrant 1
    min(dat[, 6])
    # mean number of aneurisms in quadrant 1
    mean(dat[,6])
    # median number of aneurisms in quadrant 1
    median(dat[, 6])
    # standard number of aneurisms in quadrant 1
    sd(dat[, 6])

> **Tip:** Using the function `summary(dat)` will give us summary statistics of all of the columns in the dataset.

What if we need the maximum aneurisms for all patients, or the average for each eye?

To support this, we can use the `apply` function.

> **Tip:** To learn about a function in R, e.g. `apply`, we can read its help documentation by running `help(apply)` or `?apply`.

`apply` allows us to repeat a function on all of the rows (`MARGIN = 1`) or columns (`MARGIN = 2`) of a data frame.

Thus, to obtain the average aneurisms of each patient we will need to calculate the mean of all of the rows (`MARGIN = 1`) of the data frame.

    avg_patient_aneurisms <- apply(dat[,6:9], 1, mean)

And to obtain the average aneurisms for both eyes we will need to calculate the mean of all of the columns (`MARGIN = 2`) of the data frame.

    avg_eye_aneurisms <- apply(dat[,6:9], 2, mean)

Since the second argument to `apply` is `MARGIN`, the above command is equivalent to `apply(dat, MARGIN = 2, mean)`.  

> **Tip:** Some common operations have more efficient alternatives.
For example, you can calculate the row-wise or column-wise means with `rowMeans` and `colMeans`, respectively.


>**Exercise 4**
> 
> Make a new column in `dat` called `average_anuerism` which is the average aneurisms over Aneurisms_q1-4 for each patient (*Hint*: Try `dat['average_anuerism'] = something` for making the new column).  Write your new data as a csv file using the function `write.csv(...)`.


### 6. Exploratory Plotting!



### 7. Combining concepts: A full analysis

Now that you are familiar with the basics of R computing, reading and writing data, and plotting let's work through an analysis work flow you might encounter in your everyday work. Here is the **goal**.

> You have collected data on eye aneurisms across 5 sites and stored in the data in 5 separate files `aneurism_data_site-1.csv`, `aneurism_data_site-2.csv`, ..., 
> `aneurism_data_site-5.csv`. You are interested in asking the question whether the average number eye aneurysms for a given person depends on treatment type, blood pressure, or sex for each site separately.
> 

This may seem daunting, but you can do this analysis using what you have learned so far.  The best way to approach any analysis is to break it into chunks (maybe even functions!).

1. Load in your data
1. If necessary, clean up your data.
1. Define a new response variable that is the mean of your aneurysms
1. Visualize your data with a few plots
1. Run your analysis on each of your cleaned data sets
1. Output the results
1. Repeat for all 5 datasets

Here's at outline of how this problem might look in pseudocode. Let's build on this as the as we progress through the next sections

    analyze <- function(filename){
        # A function that plots and analyzes aneurysm data

        # 1. Load in data in filename and save it to a variable

        # 2. Clean your data

        # 3. Define a new response that is the mean number of anuerysms

        # 4. Visualize your data with a few plots

        # 5. Run an analysis for each dataset and return results

    }

#### 7.1 Load in your data

> **Exercise 5**: Within the function `analyze`, use `read.csv` to load in the `filename` and assign it to the variable `tdata`. What is the `class` of this filename? Test that your function works.

#### 7.2 Clean your data

Let's reuse the code that we previously wrote in this lesson to clean our data.

    tdata$Gender[tdata$Gender == "m"] = "M"
    tdata$Gender[tdata$Gender == "f"] = "F"
    tdata <- droplevels(tdata)

Let's test if our function works.

    analyze("aneurism_data_site-1.csv")
 
>**Exercise 6**: Make your code more readable by making the cleaning step a separate function of its own called `clean_data` that takes in a dataframe as an argument, cleans the data set and returns the cleaned dataset. *Hint*:  Make sure you define the `clean_data` function *before* the `analyze` function.

#### 7.3 Make a new variable

We now want to define a new variable called `average_anuerism` in our dataframe which is the average over all four anuerism columns.  Let's just copy the code we used before

    tdata['avg_anuerism'] <- apply(data[, 6:9], MARGIN=1, mean)

or

    tdata['avg_anuerism'] <- rowMeans(tdata[, 6:9])

#### 7.4 Visualize your data with a few plots

> **Exercise 7**: Choose one or two of the plots you learned and plot the data in some way to visualize whether Gender, Treatment, and/or BloodPressure might be having some effect of average number of anuerysms per person.

#### 7.5 Fit a statistical model to the data and return results

R is an amazing statistical environment that you can begin to explore once you understand the inner workings of R. To answer our question we are going two of the thousands of statistical functions that R has to offer: `lm` (Linear Model) and `anova`.

    # Fit a linear model. Response on the left predictors on the right
    fit <- lm(avg_aneurism ~ Gender + Group + BloodPressure, data=tdata)
    results <- anova(fit)
    return(results)

Now you have a function that performs your analysis on a single dataset! 

#### 7.6 Repeat for all 5 datasets 

We know how to repeat ourselves - use loops. In the case we might want to loop over the all 5 datasets and use our `analyze` function on each.  But how do we get the names for these data sets?

    # Set your working direction to your data file
    setwd("~/Desktop/workshop/")

The `ls` command in the shell has an equivalent command in R called `list.files()`

    # Look at the files in the data directory
    list.files()
    all_files <- list.files()
    all_files

Great! But how do we just get the anuerysm files? We can use a default argument of `list.files()` called `pattern`.  This argument allows you to only select certain files that match the pattern.

    # List all files that start with aneurysm
    all_files <- list.files(pattern="anuerysm")
    all_files

Now `all_files` contains the filenames of all of our datafiles

> **Exercise 8**: Loop through `all_files` and run `analyze` on each data file. Print the results of each analysis to the Rconsole.
> 

Congratulations! You have completed your analysis! Go write the paper.

<!-- #### Key Points the first 5 sections

* Use `variable <- value` to assign a value to a variable in order to record it in memory.
* Objects are created on demand whenever a value is assigned to them.
* The function `dim` gives the dimensions of a data frame.
* Use `object[x, y]` to select a single element from a data frame.
* Use `from:to` to specify a sequence that includes the indices from `from` to `to`.
* All the indexing and slicing that works on data frames also works on vectors.
* Use `#` to add comments to programs.
* Use `mean`, `max`, `min` and `sd` to calculate simple statistics.
* Use `apply` to calculate statistics across the rows or columns of a data frame.
 -->