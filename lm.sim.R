library(fracdiff)
#simulate long-memory data
lm.sim <- fracdiff.sim(100, ar = .2, ma = -.4, d = .3)
lm.sim
#plot graph
ts.plot(lm.sim$series,main="Simulated long-memory process")

# plot ACF against Lag
lm.acs <- acf(lm.sim$series, lag.max=100, type="correlation",plot=T,main="ACF of Simulated ARFIMA process")

