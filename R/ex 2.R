df=iris
df

summary(df)
min(df$Sepal.Length)
min(df$Sepal.Width)
min(df$Petal.Length)
min(df$Petal.Width)
max(df$Sepal.Length)
max(df$Sepal.Width)
max(df$Petal.Length)
max(df$Petal.Width)

mean(df$Sepal.Length)
mean(df$Sepal.Width)
mean(df$Petal.Length)
mean(df$Petal.Width)


df1=mtcars
df1

sqrt(df1$mpg)
log(df1$disp)
(df1$wt)^3

s1 <- paste("Age","Gender","Height","Weight",sep="+")
s1

m1 <- matrix(c(4,7,-8,3,0,-2,1,-5,12,-3,6,9),ncol=4)
m1
rowMeans(m1,1)
colMeans(m1,1)
mean(m1)



az <-LETTERS
za <- order (az,decreasing = TRUE)
az [za]

for (i in 1:40) {
  x <- sample (x=1:10,size =1)
  print (x)
  if (x==8) {break
    }
}
x<-0
while(x!=8) {
  x <- sample (x=1:40,size = 1)
  print(x)
}
  



