##### Answer to Exercise 1 ####

r <- 0.6
K <- 100
n0 <- 10

n1 <- round(n0 + r*n0*(1 - n0 / K))
n2 <- round(n1 + r*n1*(1 - n1 / K))

# Print varial
n0
n1
n2


# Bonus
paste("n2 more than 20: ", n2 > 20)
paste("n2 is an integer: ", is.integer(n2))


#### Answer to Exercise 2 ####

r <- 0.6
K <- 100
n <- numeric()
n <- c(n, 10)  # Append n in the first location

n <- c(n, round(n[1] + r*n[1]*(1 - n[1]/K)))  # Append 
n <- c(n, round(n[2] + r*n[2]*(1 - n[2]/K)))  # Append
n <- c(n, round(n[3] + r*n[3]*(1 - n[3]/K)))  # Append

# Print
n
paste("Grew by a factor of", n[4]/n[1])


#### Answer to Exercise 3 ####

r <- 0.6
K <- 100
n <- array(NA, dim=100)
n[1] <- 10

n[2] <- round(n[1] + r*n[1]*(1 - n[1]/K))
n[3] <- round(n[1] + r*n[2]*(1 - n[2]/K))
n[4] <- round(n[2] + r*n[3]*(1 - n[3]/K))

# Print n
n

t <- seq(0, 24.75, length=100)
t

n[t == 0.5]

#### Answer to Exercise 4 ####

r <- 1.9
K <- 100
n <- array(NA, dim=100)
n[1] <- 10

steps <- 2:100
for(i in steps){
  n[i] = round(n[i-1] + r*n[i-1]*(1 - n[i-1]/K))
}

plot(n, type='l')

#### Answer to Exercise 5 #####

# Set up initial parameters
r <- 1.9
K <- 100
n <- array(NA, dim=100)
n[1] <- 10

steps <- 2:100
for(i in steps){
  cata <- (runif(1) < 0.1)
  
  if(cata){
    # Catastrophe occurs
    n[i] = n[1]
  } else{
    # Catastrophe doesn't occur
    n[i] = round(n[i-1] + r*n[i-1]*(1 - n[i-1]/K))
  }
}

plot(n, type='l')

paste('Population was above 50 in', sum(n > 50), 'out of 100 steps')

#### Answer to Exercise 6 #####

# Set up initial parameters

grow_one_step <- function(n, r, K){
  
  # Function to grow a step following logistic growth
  return(round(n + r*n*(1 - n/K)))
}

logistic_growth <- function(r, K, n0, p=0.1){
  
  # Logistic growth function that takes in three parameters: 
  # r : Per capita growth rate
  # K : Carrying Capacity
  # n0 : Initial population size
  # p: probability of a catastrophe
  # Returns a population trajectory over 100 time steps
  
  n <- array(NA, dim=100)
  n[1] <- n0

  steps <- 2:100
  
  for(i in steps){
    cata <- (runif(1) < p)
    
    if(cata){
      # Catastrophe occurs
      n[i] = n[1]
    } else{
      # Catastrophe doesn't occur
      n[i] = grow_one_step(n[i - 1], r, K)
      
      #n[i] = round(n[i-1] + r*n[i-1]*(1 - n[i-1]/K)) 
    }
  }
  
  return(n)
}

n <- logistic_growth(1.9, 100, 10, p=0.01)
plot(n, type='l')