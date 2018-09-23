library(readr)
library(MASS)
library(calibrate)

library(ggplot2)
library(itsmr)
library(fracdiff)
library(aTSA)
library(fGarch)
library(rugarch)
library(dlm)
library(MTS)

library (forecast)
library(tseries);
library(astsa);

# data frame
ymat <- read.csv("~/Documents/MATLAB/MSc_Project_Code/sunspots/beta_gamma_delta/ymat.csv",head=FALSE);
colnames(ymat) <- c("year","date","time","row_min","row_max","row_loc",
                    "col_min","col_max","col_loc","ratio(b/w)","A(b)","A(w)",
                    "C1","C2","C","Mix1","Mix2");
row <- dim(ymat)[1];
col <- dim(ymat)[2];

# extract date and time vectors
date <- 20010000+ymat[,2];
time <- ymat[,3];
# change them to string and set x-axis
date_string <- sprintf("%08d",date);
time_string <- sprintf("%04d",time);
x <- paste(date_string, "T", time_string, sep = "")
x_row <- length(x);
xaxis = seq(1,x_row,1);

# area ratio (if NaN or Inf occurs, set them to 0)
ratio <- ymat[,10];

# A(B), A(W)
Ab <- ymat[,11];
Aw <- ymat[,12];

# curvature
C <- ymat[,15];

# plot the graph
plot(xaxis,C,'l',
     main = paste("curvature of polarity inversion line"),
     xlab="ordered timestamp ", ylab="C ");
axis(1, at=1:x_row, labels = x)

# Mixture
Mix1 <- ymat[,16];



# check if stationary using Dickey-Fuller Test
adf.test(C)

#to investigate if y_t and y_{t−1} are correlated
Cnew <- C
for (i in 1:length(C)-1) {Cnew[i]=C[i+1]} 
plot(C,Cnew,main="correlation of y_t on y_{t−1}")
C_diff <- diff(C, lag = 1 , differences= 1)
adf.test(C_diff)
plot(C_diff,type="l")

# take log
C <- log(C)

# plot ACF against lag
C.acs <- acf(C,lag.max=100,main="ACF for log(C)")

#plot periodogram
dat.pgram <- spec.pgram(C,plot=F)
x_dat.pgram <- log(dat.pgram$freq)
y_dat.pgram <- log(dat.pgram$spec)
plot(x_dat.pgram, y_dat.pgram, pch=16, main="log log periodogram plot", xlab="log(freq)", ylab="log(spectral density)")
reg <- lm(y_dat.pgram[2:200] ~ x_dat.pgram[2:200])
abline(reg, col="blue")
coeff=coefficients(reg)
legend(-4,-6,legend=c("slope",coeff[2]), cex=0.8)

# cross-validation
C.train <- C[1:90]
C.test <- C[91:100]

# arima model
model0 <- auto.arima(C.train,ic="aic")
model0

model1 <- arima(C.train,order=c(1,0,0))
summary(model1)
confint(model1)
plot(forecast(model1))
pred1 <- predict(model1,n.ahead=10)
MAE1 <- sum(abs(pred1$pred-C.test))/10
MSE1 <- sum((pred1$pred-C.test)^2)/10

# get an automatically best fitted arfima model
model2 <- fracdiff(C.train,nar=0,nma=3)
model2
summary(model2)
coeff(model2)
vcov(model2)
confint(model2)
plot(forecast(model2))
pred2 <- predict(model2,n.ahead=10)
MAE2 <- sum(abs(pred2$mean-C.test))/10
MSE2 <- sum((pred2$mean-C.test)^2)/10

# plot forecast
plot.new()
plot(1:length(C),C,"l",col="black",xlab="no. of timestamp",ylab="log(C)",
     main="Model Fitting using AR(1) and ARFIMA(0,1,3)")
lines(fitted(model1),col="blue")
lines(fitted(model2),col="orange")
lines(xaxis[91:100],pred1$pred,col="blue")
lines(xaxis[91:100],pred2$mean,col="orange")
abline(b=1,v=xaxis[90])
legend(35,-0.6, legend=c("ar(1)", "arfima(0,1,3)"),
       col=c("blue", "orange"), lty=1:2, cex=0.8)

