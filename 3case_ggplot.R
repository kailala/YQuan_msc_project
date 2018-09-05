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


# Separate plots
#ggplot(d, aes(V1,value)) + 
#  geom_point() + 
#  stat_smooth() +
#  facet_wrap(~variable)


ggplot() +
  # blue plot
  geom_point(data=alpha, aes(V1, value),col="blue",show.legend=TRUE) + 
  #geom_smooth(data=alpha, aes(V1, value), fill="blue",
  #            colour="blue", size=1) +
  # red plot
  geom_point(data=beta, aes(V1, value),col="red",show.legend=TRUE) + 
  #geom_smooth(data=beta, aes(V1, value), fill="red",
  #            colour="red", size=1) +
  # green plot
  geom_point(data=betagamma, aes(V1, value), col="green",show.legend=TRUE) + 
  #geom_smooth(data=betagamma, aes(V1, value), fill="green",
  #            colour="green", size=1) +
  xlab(label = 'numerical quantity') +
  ylab(label = 'value') +
  ggtitle("Comparison of Numerical Features for 3 Cases") +
  theme_bw() 
  #scale_colour_discrete(values=cols)







