library(ggplot2)
library(reshape2)
a <- read.csv("~/Documents/MATLAB/MSc_Project_Code/sunspots/a_row.csv",head=FALSE);
row.names(a) <- c("ratio(b/w)","A(b)","A(w)","C","Mix1");
alpha <- melt(a, id.vars="V1")

b <- read.csv("~/Documents/MATLAB/MSc_Project_Code/sunspots/b_row.csv",head=FALSE);
row.names(b) <- c("ratio(b/w)","A(b)","A(w)","C","Mix1");
beta <- melt(b, id.vars="V1")

bg <- read.csv("~/Documents/MATLAB/MSc_Project_Code/sunspots/bg_row.csv",head=FALSE);
row.names(bg) <- c("ratio(b/w)","A(b)","A(w)","C","Mix1");
betagamma <- melt(bg, id.vars="V1")

ggplot() +
  # blue plot
  geom_point(data=alpha, aes(V1, value),col="blue",show.legend=TRUE) + 

  # red plot
  geom_point(data=beta, aes(V1, value),col="red",show.legend=TRUE) + 

  # green plot
  geom_point(data=betagamma, aes(V1, value), col="green",show.legend=TRUE) + 

  xlab(label = 'numerical quantity') +
  ylab(label = 'value') +
  ggtitle("Comparison of Numerical Features for 3 Cases") +
  theme_bw() 


