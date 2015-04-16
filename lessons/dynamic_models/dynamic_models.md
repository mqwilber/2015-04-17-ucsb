---
layout: lesson
root: ../..
title: Dynamic Models
---
*Written by Louise Stevenson and Cherie Briggs*

**Supplementary Material**: [Data for Exercise 2](../../data/CunninghamMaasAlgaeData.csv), [Answers to exercises](dynamic_models_answers.R)

### Introduction to Solving Ordinary Differential Equations
The function 'lsoda' in the R package, deSolve, calculates numerical solutions to systems of first order ordinary differential equations for a given set of parameter values and initial conditions (this is one of a number of ODE solving packages in R).

The first thing you need to do is load the deSolve package.

    install.packages("deSolve")
    library(deSolve)

There are two steps involved in obtain numerical solutions to differential equations:

1. Write the derivative function (`func`), that describes the right hand side of the differential equations.
`func` must take as its first three arguments the current time (t), the current values of the variables (y), and a vector containing the parameter values. It must also return a list (using list(item1, item2, item3), where the items can be any R objects) whose elements are a vector of ODEs (see examples below).

2. Use `lsoda` to solve the differential equations.
`lsoda`'s main arguments are the starting values (`y`), the times at which you want to compute the values of the variables you are interested in (`times`), the derivative function (`func`), and some parameters (`parms`).

The function call will look something like

    lsoda(initial values, time interval, function, parameters)

### SIR (Susceptible-Infected-Resistant) Model Example

For this exercise, we're going to use the example of a SIR (Susceptible-Infected-Resistant) Model. This model has three state variables:

1. S - the density of susceptible (uninfected) individuals

2. I - the density of infected individuals

3. R - the number of recovered individuals, who are now resistant to further infection

<img src="http://i.imgur.com/rdFWsJJ.png"/>

<center> <img src="http://jmbe.asm.org/asm/index.php/jmbe/article/viewFile/429/html/4674"/> </center>

<center><a href="http://jmbe.asm.org/asm/index.php/jmbe/article/viewFile/429/html/4674">source</a></center>

&#946; is the transmission rate, in which we are assuming susceptible individuals are becoming infected by randomly encountering infected individuals

&#947; is the rate of removal from the infected class, such that the average duration that an individual remains infectious is 1/&#947;

### Simulating our SIR model

    SIR.model <- function (t, x, params) {
     S <- x[1]
     I <- x[2]
     R <- x[3]
     beta <- params[1]
     gamma <- params[2]
     dS <- -beta*S*I
     dI <- beta*S*I-gamma*I
     dR <- gamma*I
     list(c(dS,dI,dR))
    }

We've defined our derivative as a function with three inputs:

1. t - time

2. x - our state variables (we will set the initial values or starting places or all of our state variables)

3. params - parameter values

In the first part of the model function, we set the initial values of our state variables and the values of our parameters:

    S <- x[1]
    I <- x[2]
    R <- x[3]
    beta <- params[1]
    gamma <- params[2]

Then we define the differential equations the describe how the state variables change through time and packs the results into a "list" to export the results:

    dS <- -beta*S*I
    dI <- beta*S*I-gamma*I
    dR <- gamma*I
    list(c(dS,dI,dR))

Let's say that our first guess of &#946; is 0.001 and &#947; is 0.5. Not that in the derivative, we defined the first parameter in our parameter vector as &#946; and the second as &#947; - make sure you order it in the same way.

    params0 <- c(0.001, 0.05)

Now let's define the initial conditions (initial values of the state variables). Let's imagine that the populations of all three state variables (S, I, and R) start at 20, 10, and 5 individuals each, respectively. Again, note the order that we define the state variables in the derivative function - S, I, and then R. Make sure you retain that order.

    x_init <- c(20, 10, 5)

Let's simulate the model for 14 days:

    t <- seq(1:100)

Let's simulate the model to see what the results are. Remember our ODE solver (`lsoda`)'s inputs from previously:

    results <- ode(x_init, t, SIR.model, params0)

R has simulated our model for 14 days and stored the values in the matrix results. The column order is: 1) time, 2) state variable 1 (S), 3) state variable 2 (I), and 4) state variable 3 (R).

    plot(results[,1], results[,2], type="l", col="black", ylab="S, I, and R 
        individuals", xlab="Time (days)", main="SIR Model Output", ylim=c(0, 20), lwd=1.25)
    lines(results[,1], results[,3], type="l", col="red", lwd=1.25)
    lines(results[,1], results[,4], type="l", col="blue", lwd=1.25)
    legend("bottomleft", c("S", "I", "R"), col=c("black", "red", "blue"), lty=1)

>### Exercise 1

>What happens to the predicted dyanmics of this system if you:

>1. Increase the transmission rate to 0.01
>2. Decrease the recovery rate to 0.0025
>3. Start with 10 susceptible, 10 infected, and 0 recovered individuals

>Make a plot of your results.

### Data to fit to SIR model

Suppose we have the following data on the number of individuals infected with flu (I(t)) each day during a 2-week epidemic:

    day <- seq(1:14)
    flu <- c(3, 8, 28, 76, 222, 293, 257, 237, 192, 126, 70, 28, 12, 5)
    plot(day, flu, type='b')

You can create an R dataframe named “fludata” using the command:

    fludata <- data.frame(day,flu)

### Fitting continuous-time models to data
If we can assume that the only source of variability in our data is measurement error (variability imposed by our imperfect observation of the world) and that the measurement error is symmetrically distributed with a constant variance around the mean of our data, we can use the method of **least squares** to estimate model parameters. In the case that errors are normally distributed with a Gaussian distribution then least squares estimates are also the **maximum likelihood** estimates.

Now we set up a function that will calculate the sum of the squared differences between the observations and the model at any parameterization (more commonly known as **sum of squared errors**). First we'll define our initial values again and our starting values of the parameters (our best guess of the parameter values we're estimating):

    params0 <- c(0.01, 0.0025)
    x_init <- c(762, 1, 0)

Next the function to calculate the sum of squared errors:

    sse.sir <- function(params0, data) {
     t <- data[,1]
     cases <- data[,2]
     beta <- params0[1]
     gamma <- params0[2]
     S0 <- x_init[1]
     I0 <- x_init[2]
     R0 <- x_init[3]
     out <-as.data.frame(ode(y= c(S=S0,I=I0,R=R0), times=t, SIR.model, parms=c(beta,gamma), hmax=0.01))
     sse <- sum((out$I-cases)^2)
    }

Just like the model function we defined above, we again need to give this function three inputs: parameter values, initial values of the state variables, and time. This time we also give the SSE function data with which to minimize the sum of squared error (`data[,2]``).

The lines:

    t <- data[,1]
    cases <- data[,2]

assign the first column of the data to t, and the second column of the data to cases. Within this function, cases now contains our data on the actual infected number of cases through time.

    out <-as.data.frame(ode(y= c(S=S0,I=I0,R=R0), times=t, SIR.model, 
        parms=c(beta,gamma), hmax=0.01))

generates the numerical solution to the ordinary differential equations described in the function `SIR.model` for the given set of parameters and generates the output at the same time points t for which we have data.

The final line:

    sse<-sum((out$I-cases)^2)

for each time point subtracts the actual number of infected cases from the predicted number of Infecteds from the model, squares this difference, and adds up these squared differences for all of the time points. `sse.sir` now contains the sum of squared differences between the actual and predicted number of infected.

We would like to be able to simultaneously find the values of both &#946; and &#9467; which will give us a two dimensional surface over which we’d like to find the minimum SSE. The process to find the minimum is called optimization, and there are a number of algorithms available for doing this numerically. In R, we’ll use the function `optim`, for which the default algorithm is the Nelder-Mead algorithm.

To find the values of &#946; and &#9467; that simultaneously minimize the sums of squared differences between the model and data, we use:

    fit0 <- optim(params0, sse.sir, data=fludata)
    fit0$par

The `optim` function requires three inputs: an initial set of parameters to optimize over, a function to be minimized (or maximized), and data to compare to the model function. We are storing the results of this optimization procedure in a structure that we are calling `fit0`. `fit0$par` gives the best set of parameters found - the algorithm found the lowest value of sse for &#946; = 0.00257 and &#9467; = 0.473.

`fit0$value` gives the value of the function (in this case the sum of squared errors) corresponding to the estimated parameters. In our case we get:

    fit0$value

`fit0$convergence` tells whether the routine converged (i.e. successfully found a minimum). A value of 0 for this means that it worked.

    fit0$convergence

The first set of parameters isn’t always the best. You can re-run the optimization procedure, starting at your previous best fit:

    fit1 <- optim(fit0$par, sse.sir, data=fludata)
    fit1$par

Finally, we can plot the model prediction with these best-fit parameters (the result of having the ode solver calculate the numerical solution of the model for the parameter estimates) against the data ("day" and "flu"):

    plot(fludata$day, fludata$flu, type='b', xlab='Day', ylab='I(t)', ylim=c(0,350), col='red')
    t <- seq(1, max(fludata$day), by=0.05)
    mod.pred <- as.data.frame(ode(c(S=762, I=1, R=0), t, SIR.model, fit1$par, hmax=0.01))
    lines(t, mod.pred$I)
    legend("topright", c("Model", "Data"), col=c("black", "red"), lty=c(1,5))
    
>### Exercise 2:
>Let's return to the logistic growth equation we discussed in the Intro to R lesson yesterday. Simulate the logistic growth model for 120 hours and then fit the model to data on the nitrite limited growth of the microalga *Chlamydomonas* from Cunningham and Maas (1978) (Get the data by clicking [here](../../data/CunninghamMaasAlgaeData.csv): 'CunninghamMaasAlgaeData.csv'). Cunningham and Maas grew a freshwater green algae,  We're thinking about models in continuous (not discrete) time, and the model for logistic growth of a popoulation (N):
>$$ dN/dt = rN (1 - N/K) $$
>Begin by simulating the logistic growth model with a starting population of 6 cells/ &#956; L, a growth rate of 0.1 1/hr and a carrying capacity of 900 cells/&#956;L. Then estimate the parameters 'r' and 'K' using the data provided from Cunningham and Maas (1978) ('CunninghamMaasAlgaeData.csv') and a SSE method (use the parameter values you used to simulate the model as your first guess). Show the fit of the model to the data with a plot.
