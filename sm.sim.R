#ARMA simulate data
arma.sim <- arima.sim(model=list(ar=c(0.5,-0.2),ma=c(0.6,0.1)),n=100)
arma.sim

#plot ARMA data
ts.plot(arma.sim,main="Simulated short-memory process")

# plot ACF against Lag
arma.acs <- acf(arma.sim, lag.max=100, type="correlation",plot=T,main="ACF of Simulated ARMA process")

