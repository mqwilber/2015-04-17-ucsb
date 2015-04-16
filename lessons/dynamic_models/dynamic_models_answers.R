## Answer key for dynamic modeling section
# Ex 1
# Earlier but necessary stuff
library(deSolve)

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

params0 <- c(0.01, 0.0025)
x_init <- c(10, 10, 0)
t = seq(1:100)
results2 <- ode(x_init, t, SIR.model, params0)

plot(results2[,1], results2[,2], type="l", col="black", ylab="S, I, and R individuals", xlab="Time (days)", main="SIR Model Output", ylim=c(0, 20), lwd=1.25)
lines(results2[,1], results2[,3], type="l", col="red", lwd=1.25)
lines(results2[,1], results2[,4], type="l", col="blue", lwd=1.25)
legend("right", c("S", "I", "R"), col=c("black", "red", "blue"), lty=1)

# Ex 2
algae_data<-read.csv("CunninghamMaasAlgaeData.csv",header=T)
require(deSolve)

logistic_growth <- function (t, x, pars){
  N <- x[1]
  r = pars[1]
  K = pars[2]
  dN = r * N * (1 - (N/K))
  list(c(dN))
}

t=seq(1:125)
x_init = 6
pars = c(0.1, 900)

logistic_results <- ode(x_init, t, logistic_growth, pars)

plot(logistic_results)

log.sse <- function(params0, data) {
 t <- data[,1]
 cells <- data[,2]
 r <- params0[1]
 K <- params0[2]
 N0 <- 6
 out <-as.data.frame(ode(y = c(N=N0), times=t, logistic_growth, parms=c(r,K), hmax=0.01))
 sse <- sum((out$N-cells)^2)
}

fit0 <- optim(pars, log.sse, data=algae_data)
fit0$par 
fit0$convergence

fit1 <- optim(fit0$par, log.sse, data=algae_data)
fit1$par

plot(algae_data$Time, algae_data$Cells, type='b', xlab='Day', ylab='Cells', col='red')
t <- seq(1, max(algae_data$Time), by=0.05)
mod.pred <- as.data.frame(ode(c(N0=6), t, logistic_growth, fit1$par, , hmax=0.01))
lines(t, mod.pred$N)
legend("bottomright", c("Model", "Data"), col=c("black", "red"), lty=c(1,5))


