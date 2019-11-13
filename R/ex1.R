a<- c(10:20)
a
b<- letters
b1<- b[4:13]
b<-b1
b

f<-c(1,1,1,0,0,0,0,0)

fv<-factor(f,levels=c(1,0), labels=c("NO","YES"))

help("objects")


R <- c(1,2,3,4,5)
P <- c(1,1,3,4,3)
Ti <- c('Avatar','Titanic','Star Wars','Avengers','Jurassic Prarc')
W <- c(2787965,2187463,2068223,1844894,1671713)
Y <-c(2009,1997,015,2018,2015)
df <- data.frame(a,b,c,d,e)
class(df)
str(df)
summary(df)

df[2, 3]

