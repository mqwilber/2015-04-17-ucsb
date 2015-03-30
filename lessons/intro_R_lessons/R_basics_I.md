---
layout: lesson
root: ../..
title: Scientific Programming with R
---

*Prepared by Mark Wilber, Original Material from Justin Kitzes and Tom Wright*

<!-- # Novice R materials

* Draw concept map of where we are headed towards best scientific practices, and reproducibility.
* Its really important that you know what you did. More journals/grants/etc. are also making it important for them to know what you did.
* A lot of scientific code is *not* reproducible.
* If you keep a lab notebook, why are we not as careful with our code?
* We edit each others manuscripts, but we don't edit each other's code.
* If you write your code with "future you" in mind, you will save yourself and others a lot of time. -->

# What is R?

R is a versatile, open source programming language that was specifically designed for data analysis. As such R is extremely useful both for statistics and data science. Inspired by the programming language S.

* Open source software under GPL.
* Superior (if not just comparable) to commercial alternatives. R has over 5,000 user contributed packages at this time. It's widely used both in academia and industry.
* Available on all platforms.
* Not just for statistics, but also general purpose programming.
* Is (sort of) object oriented and functional.
* Large and growing community of peers.

# Introduction to RStudio

There are four windows in RStudio that we will refer to throughout the workshop

1. The R Script: Where you write R code
2. The R Console: Where you execute R code
3. The R Environment: Where you see you defined variables
4. R "Information": Where you see plots, help and other R information

## 1. Individual things

The most basic component of any programming language are "things", also called variables or
(in special cases) objects.

The most common basic "things" in R are integers and doubles (i.e. numerics), characters, logicals, and
some special objects of various types. We'll meet many of these as we go through the lesson.

    # A thing
    2

    # Another thing
    "hello"

Things can be stored as variables using `<-`.  `=` also works, but R programmers are picky about `<-`

    a <- 2
    b <- "hello"
    c <- TRUE  # This is case sensitive

    # Print the different variables
    a
    b
    c

We can figure out the type of these things using the `typeof` function

    typeof(a)
    typeof(b)
    typeof(c)

## 2. Commands that operate on things

Just storing data in variables isn't much use to us. Right away, we'd like to start performing
operations and manipulations on data and variables.

There are three very common means of performing an operation on a thing.

### 2.1 Use an operator

All of the basic math operators work like you think they should for numbers. They can also
do some useful operations on other things, like characters. There are also logical operators that
compare quantities and give back a `logical` variable as a result.

    # Standard math operators work as expected on numbers
    a <- 2
    b <- 3
    a + b  # Addition
    a * b  # Multiplication
    a ^ b  # Powers
    a / b  # Division

Logical operators compare two things. This amounts to asking R a question

1. `x > y`: R, is x greater than y?
2. `x == y`: R, is x the same as y?
3. `x <= y`: R, is x less than or equal to y?
4. `x & y`: R, are both x and y `TRUE`?
5. `x | y`: R, is either x or y `TRUE`?

R will either answer `TRUE` or `FALSE`

    a <- (1 > 3)
    b <- (3 == 3)
    a
    b
    a | b
    a & b

### 2.2 Use a function

These will be very familiar to anyone who has programmed in any language, and work like you
would expect.

    # There are thousands of functions that operate on things
    typeof(3.3)
    round(3.3)
    as.integer(3.3)
    paste("3.3 rounded is", round(3.3))  # Paste together characters and integers

To find out what a function does type a `?` before the function name (or just Google it!)
        
    ?round
    round(4.567, digits=1)

Many useful functions are in external packages and you need to install them and load them into the R environment.  For example, what if we wanted to figure out how to do a negative binomial regression in R?

    # Look at the following function
    ?glm.nb

Hmmm, that probably didn't work for you because the function lives in an external package called `MASS`.  We need to install package and then load the package.

    # Install the package
    install.packages("MASS") # MASS has quotes
    library(MASS)  # MASS does not have quotes
    ?glm.nb

There are thousands of R packages with many useful functions and datasets!  That is one of the huge advantages of R, everyone can contribute.

> ### EXERCISE 1 - Introducing logistic growth
> 
> Throughout this lesson, we will successively build towards a program that will calculate the
> logistic growth of a population of bacteria in a petri dish (or bears in the woods, if you
> prefer). The exercises will build on each other - if at any time you get behind, you can find the answers to the previous exercises here and catch up.
> 
> As a reminder, a commonly used discrete time equation for logistic population growth is
> 
> >n(t+1) = n(t) + r n(t) [1 - n(t) / K]
> 
> where n(t) is the population size at time t, r is the net per capita growth rate, and K is the
> carrying capacity of the dish/woods.
> 
> To get started, write Python expressions that do the following:
> 
> 1. Create variables for `r`, `K`, and `n0`, setting these equal to 0.6, 100, and 10, respectively.
> 1. Create the variable `n1` and calculate it's value. Do the same for `n2`.
> 1. Check the type of `n2` - what is it?
> 1. Modify your calculations for `n1` and `n2` so that these values are rounded to the nearest
> integer.
> 
> __Bonus__
> 
> 1. Test whether `n2` is larger than 20, and print out a line that says "n2 more than 20: " followed by the answer (either TRUE or FALSE).
> 1. Figure out how to ask R whether `n2` is an integer


## 3. Collections of things

Once the number of variables that you are interested in starts getting large, working with them
all individually starts to get unwieldy. To help stay organized, we can use collections of things.

The most fundamental type of collection is a `vector`.  A vector is a collection of elements that are most commonly `character`, `logical`, `integer` or `numeric`.

You can create an empty vector with `vector()`. (By default the mode is `logical`. You can be more explicit as shown in the examples below.) It is more common to use direct constructors such as `character()`, `numeric()`, etc

    x <- vector()  # Empty vector

    # With a length and type
    vector("character", length = 10)
    character(5)  # character vector of length 5
    numeric(5)  # numeric vector of length 5 
    logical(5)  # Logical vector of length 5

You can easily make vectors that contain data using the `c()` function

    # Make a vector with numbers
    x = c(1, 2, 3)
    x
    length(x)

    # Make a vector with characters
    y = c("R", "is", "awesome")
    y

    # What happens here
    z = c(1, 2, "hello")
    z
    typeof(z)

You can easily add elements to vectors as well

    # Make an empty vector
    x = numeric()

    # Add 2 to x
    x = c(x, 2)
    x

    y = 1:10  # Make a numeric vector with numbers 1 - 10
    y

    # Add y to x
    z = c(x, y)
    z

You can then look at specific things in the vector by specifying the *index*

    # Look at the first thing. Index 1
    z[1]

    # Look at the 2-5 things. Indices 2 - 5
    z[2:5]

    # Look at the last thing. Index 11
    z[11]


> ### EXERCISE 2 - Storing population size in a list
> 
> Reuse your code from Exercise 1 and do the following:
> 
> 1. Modify your code so that the values of `n0`, `n1`, and `n2` are stored in a numeric vector and not separate individual variables. HINT: You can start off by declaring an empty list using the syntax `n = numeric()`, and then append each new calculated value of `nt` to the list.
>  
> 1. Get the first and last values in the list, calculate their ratio, and print out "Grew by a factor of" followed by the result.
> 
> __Bonus__
> 
> 1. Extract the last value in two different ways: first, by using the index for the last item in the list, and second, presuming that you do not know how long the list is.
>  
> 1. Change the values of `r` and `K` to make sure that your cell still runs correctly and gives reasonable answers.
> 

### 3.1 Arrays 

Arrays are just vectors, but they can be n-dimensional. If we make a 1 dimensional array it will behave exactly like a vector
    
    # Fill an array with NAs a space holders
    x <- array(NA, dim=10)
    x
    length(x)
    x[1]
    x <- c(x, 10)

But we could make multidimensional arrays as well.

    # Make a 2-D array
    x <- array(NA, dim = c(5, 5))
    x
    dim(x)  # Check the dimensions of the array

We can add elements to this 2-D array just like you would think

    # Set element in row 1 and column 3 equal to 3
    x[1, 3] <- 3
    x

You can also do element-wise arithmetic on arrays (or vectors)

    x <- c(1, 2, 3, 4, 5)
    x * 2
    x / 2
    x ** 2
    sin(x)

Logical operators also work on arrays and they return arrays containing logical variables.  

    x > 3
    x == 3

You can also use logical arrays to subset arrays. This is called logical indexing.  For example, let's get an array that only contains values greater than 2

    x <- c(1, 2, 3, 4)
    y <- x[x > 2]
    y

You can also easily make arrays of number sequences

    # Sequence of 1 through 10
    a <- 1:10
    a

    # Sequence from 0 to 10 with 25 equally spaced elements
    b = seq(0, 10, length=25)
    b


> ### EXERCISE 3 - Storing data in arrays
> 
> Copy your code from Exercise 2 and do the following:
> 
> 1.  Pre-allocate an array containing 100 blank space (i.e. NAs) as if we were going to fill in 100 time steps. Modify your code from Exercise 2 so that you fill your the first 4 elements of your array using array indexing rather than appending.
2. Imagine that each discrete time step actually represents 0.25 of an hour. Create an array `t` storing 100 time step, in hours, from 0 to 24.75. For example, t[1] should be 0 t[1] should be 0.25, etc.
3. Use logical indexing to extract the value of `n` corresponding to a `t` of 0.5.

## 4. Repeating yourself

So far, everything that we've done could, in principle, be done by hand calculation. In this section
and the next, we really start to take advantage of the power of programming languages to do things
for us automatically.

We start here with ways to repeat yourself. The two most common ways of doing this are known as for
loops and while loops. For loops in R are useful when you want to cycle over all of the items
in a collection (such as all of the elements of an array), and while loops are useful when you want to
cycle for an indefinite amount of time until some condition is met.  We will focus on for loops in this workshop.

    # A basic for loop in R!
    wordlist <- c('hi', 'hello', 'bye')
    for(word in wordlist){
        print(word)
    }

You can sum a collection of numbers with a loop (though this is very inefficient!)

    # Sum all of the values in a collection using a for loop
    numlist <- c(1, 4, 77, 3)

    total <- 0
    for(num in numlist){
        total <- total + num
    }

    total

We often want to loop over indexes of collections
    
    wordrange <- 1:length(wordlist)
    wordrange

    for(i in wordrange){
        print(wordlist[i])
    }

Once we start looping through large numbers of values it is often better to plot the data.  We will cover this in much more detail, but here is a quick example.

    x <- 1:100
    y <- x^2
    plot(y, type='l')  # Make a line plot

> ### EXERCISE 4 - Using loops to repeat calculations
> 
> FINALLY, let's get smart about our calculations of `nt`. Copy your code from Exercise 3 into the box
below, and do the following:
> 
> 1. Write a for loop to fill in the values of `nt` for 100 time steps. HINT: You will need to create an array of the step numbers using a command like `steps <- 2:100`. (Why does this array start at 2 and not at 1?). Then, loop over the values of the `steps`, and use each step value to index the array `n`.
> 
> 1. Plot the array `n`.
> 1. Play around with the values of `r` and `K` and see how it changes the plot. What happens if you set `r` to 1.9 or 3?

## 5. Making choices

Often we want to check if a condition is `TRUE` and take one action if it is, and another action if the
condition is `FALSE`. We can achieve this in R with an if statement.

__TIP:__ You can use any expression that returns a boolean value (`TRUE` or `FALSE`) in an if statement.
Common boolean operators are ==, !=, <, <=, >, >=.

    # A simple if statement
    x <- 3
    if(x > 0){
        print('x is positive')
    } else if(x < 0){
        print('x is negative')
    } else{
        print('x is zero')
    }

If statements can also rely simply on logical variables

    # If statements can rely on boolean variables
    x <- -1
    test <- x > 0
    typeof(test)
    test

    # You can also do an if statement in one line without the brackets
    if(test) print('Test was true')


### EXERCISE 5 - Making the model stochastic with an if statement

> Deterministic models are boring, so let's introduce some element of randomness
>into our logistic growth model. We'll model a simple "catastrophe" process, in
>which a catastrophe happens in 10% of the time steps that reduces the population
> back down to the size at n0. Copy your code from Exercise 4 into the box below,
> and do the following:

> 1. Inside your for loop, add a variable called `cata`, for catastrophe, that will be `TRUE` if a catastrophe
> has occurred, and `FALSE` if it hasn't. A simple way to do this is to generate a random number using
> `runif(1)`, which will give you a random number between 0 and 1. Check whether this number
> is less than 0.1 - this check will be `TRUE` 10% of the time.
1. Using your logical variable `cata`, add an if statement to your for loop that checks whether `cata` is
> true in each time step. If it is true, set the population back to the size at n[0]. Otherwise, perform
> the usual logistic growth calculation.
> 1. Plot your results. Run the code again to see a different growth trajectory.

> __Bonus__

> 1. Now that you have the array `n`, count the number of time steps in which the population was above 50.
> Although you can do this with a for loop (loop through each value of `nt`, check if it is > 50, and if so
> increment a counter), you can do this in one line with a simple logical operation.
> HINT: If you take the sum of a logical array (using `sum()`), it will give you the number of
> `TRUE` values (since a `TRUE` is considered to be a 1, and False is a 0).


## 6. Creating chunks with functions and modules

One way to write a program is to simply string together commands, like the ones described above, in a long
file, and then to run that file to generate your results. This may work, but it can be cognitively difficult
to follow the logic of programs written in this style. Also, it does not allow you to reuse your code
easily - for example, what if we wanted to run our logistic growth model for several different choices of
initial parameters?

The most important ways to "chunk" code into more manageable pieces is to create functions and then
to gather these functions into modules, and eventually packages.  The R packages that you download from CRAN essentially collections of functions, though they also contain datasets and high level chunks called objects. Below we will discuss how to create
functions in R. Functions are good for making code more **reusable**, **readable**, and **maintainable**.

We've been using functions all day

    # Some examples of R functions
    x <- 3.333333
    round(x, 2)
    sin(x)

Creating a function can be cognitively difficult your first time.  The first step is to define a function.  Here is how we define a function in R.

    fahr_to_celsius <- function(temp) {

      celsius <- (temp - 32) * (5 / 9)
      return(celsius)

    }

A function has a few crucial parts

1. A name (`fahr_to_celsius`)
2. Parameters (`temp`)
3. A return value (`celsius`).  One feature unique to R is that the return statement is not required. R automatically returns whichever variable is on the last line of the body of the function. 

Next, we get to use the function. You pass in *arguments* to the function. 
    
    # Freezing point of water
    fahr_to_celsius(32)

    # Boiling point of water
    fahr_to_celsius(212)

You often want to document your function to describe what it does.  You can do that with comments

    fahr_to_celsius <- function(temp) {

        # Function takes in the argument temp in Fahrenheit  and converts 
        # it to Celsius

        celsius <- (temp - 32) * (5 / 9)
        return(celsius)

    }

Functions can also have default parameters, which don't need to be passed as arguments when the function is called.

    say_hello <- function(time, people){
        # Function returns a pleasant greeting
        return(paste('Good', time, people))
    }

    say_hello('afternoon', 'friends')

Let's now give `people` a default value.  In the example below, people will now have the value of `world` unless we explicitly specify otherwise.

    say_hello <- function(time, people='world'){
        # Function returns a pleasant greeting
        return(paste('Good', time, people))
    }

    say_hello('afternoon')

    say_hello('afternoon', 'students')

> ### EXERCISE 6 - Creating a logistic growth function

>Finally, let's turn our logistic growth model into a function that we can use over and over again. 
> Copy your code from Exercise 5 into the box below, and do the following:
> 
> 1. Turn your code into a function called `logistic_growth` that takes four arguments: `r`, `K`, `n0`,
> and `p` (the probability of a catastrophe). Make `p` a default parameter with a default value of 0.1.
> Have your function return the `n` array.
> 1. Write a nice comment describing what your function does.
> 1. Call your function with different values of the parameters to make sure it works.
> Store the returned value of `n` and make a plot from it.
> 
> __Bonus__
> 
> 1. Refactor (i.e. make more readable and reusable) your function by pulling out the line that actually performs the calculation of the new
> population given the old population. Make this line another function called `grow_one_step` that takes
> in the old population, `r`, and `K`, and returns the new population. Have your `logistic_growth` function
> use the `grow_one_step` function to calculate the new population in each time step.


















