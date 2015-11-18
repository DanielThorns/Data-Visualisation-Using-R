library(RMongo)
library(leaflet)
library(foreach)

method1 <- function(j) {
  
  data <- read.csv('lonlatprice.csv', nrow = j)

  for(i in 1:ncol(data)) {
    data[,i] <- as.numeric(as.character(data[,i]))
  }

  data <- na.omit(data)
  colnames(data) <- c('longitude','latitude','price')

  dataset1 <- subset(data, data$price > 0 & data$price <= 100000)
  dataset2 <- subset(data, data$price > 100000 & data$price <= 300000)
  dataset3 <- subset(data, data$price > 300000 & data$price <= 500000)
  dataset4 <- subset(data, data$price > 500000 & data$price <= 1000000)
  dataset5 <- subset(data, data$price > 1000000)
}

method2 <- function(j) {
  test <- mongoDbConnect('hp')
  dataset1 <- dbGetQuery(test, 'houses', "{'price': {$gt: 0,$lt: 100000}}", skip = 0, limit = j/200)
  dataset2 <- dbGetQuery(test, 'houses', "{'price': {$gt: 100000,$lt: 300000}}", skip = 0, limit = j/200)
  dataset3 <- dbGetQuery(test, 'houses', "{'price': {$gt: 300000,$lt: 500000}}", skip = 0, limit = j/200)
  dataset4 <- dbGetQuery(test, 'houses', "{'price': {$gt: 500000,$lt: 1000000}}", skip = 0, limit = j/200)
  dataset5 <- dbGetQuery(test, 'houses', "{'price': {$gt: 1000000}}", skip = 0, limit = j/200)
}


calculateread <- function(t) {
  
  b <- matrix(ncol = 3, nrow = t)
  
  for (i in 1:t) {
    b[i,1] <- i
    b[i,2] <- system.time(method1(i*10000))[1]
    b[i,3] <-  system.time(method2(i*10000))[1]
  }
  
  return(b)
}

plotreadtime <- function() {
table <- calculateread(31)
plot(table[,1], table[,2], col = "red", xlab = "Amount of values (10000s)", ylab = "Time taken to load values (seconds)", type = "l", ylim = c(0,12), main = "Graph showing time taken to read and subset data from .csv file vs MongoDB", pch = 15)
points(table[,1], table[,2], pch = 15, col = "red")
lines(table[,1], table[,3], col = "blue", pch = 15)
points(table[,1], table[,3], pch = 15, col = "blue")
legend(x = locator(1),c(".csv File","MongoDB"), col = c("red","blue"), pch = 15)
}


m <- leaflet() %>% setView(lng = -4.5, lat = 55, zoom = 6) %>% addTiles()
m
m %>% addMarkers(clusterOptions = markerClusterOptions(), lng = test[,1], lat = test[,2], popup = paste("Price: £", as.character(test[,3]), sep = ""))

plotpoints <- function(map, points) {
  map %>% addMarkers(clusterOptions = markerClusterOptions(), lng = points[,1], lat = points[,2], popup = paste("Price: £", as.character(points[,3]), sep = ""))
}

calculateplot <- function(t) {
  
  b <- matrix(ncol = 2, nrow = t)
  
  for (i in 1:t) {
    b[i,1] <- i
    b[i,2] <- system.time(plotpoints(m, data[i*10000,]))[3]
  }
  
  return(b)
}

calculateread <- function(t) {
  return(foreach(i=1:t, .combine = 'rbind') %do% c(i,system.time(method1(10000*i))[1], system.time(method2(10000*i))[1]))
}
