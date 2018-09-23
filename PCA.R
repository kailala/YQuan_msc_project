library(rARPACK)

# data frame
ymat <- read.csv("~/Documents/MATLAB/MSc_Project_Code/sunspots/beta_gamma_delta/ymat_for_PCA.csv",head=FALSE);
colnames(ymat) <- c("year","date","time","row_min","row_max","row_loc",
                    "col_min","col_max","col_loc","ratio(b/w)","A(b)","A(w)",
                    "C1","C2","C","Mix1","Mix2");
ymat <- as.matrix(ymat);
ymat_sub <- cbind(ymat[,10:12],ymat[,15:16]);
head(ymat_sub)

# conduct PCA
pca1 <- princomp(ymat_sub,scores=TRUE,cor=TRUE)
summary(pca1)
loadings(pca1)
plot(pca1)
screeplot(pca1,type="l",main="Scree Plot")
biplot(pca1,main="Biplot in PCA")
