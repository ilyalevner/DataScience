a<- c(10:20)
a
b<- letters
b1<- b[4:13]
b<-b1
b

f<-c(1,1,1,0,0,0,0,0)

fv<-factor(f,levels=c(1,0), labels=c("NO","YES"))

help("objects")

.Ob <- 1
ls(pattern = "O")
ls(pattern= "O", all.names = TRUE)    # also shows ".[foo]"
