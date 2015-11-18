library(leaflet)
library(shiny)
library (RMongo)

data <- read.csv('lonlatprice.csv', nrows = 20000)

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

shinyServer(function(input, output, session) {
  
  output$map <- renderLeaflet({
  leaflet() %>% setView(lng = -4.5, lat = 55, zoom = 6) %>% addTiles()
  })
  
   observe({
  
    leafletProxy("map") %>% clearMarkerClusters()  
    
    if( 1 == as.numeric(input$price)) {
      leafletProxy("map") %>% addMarkers(clusterOptions = markerClusterOptions(), lng = dataset1$lon, lat = dataset1$lat, popup = paste("Price: £", as.character(dataset1$price), sep = ""))
    }
    if(2 == as.numeric(input$price)) {
      leafletProxy("map") %>% addMarkers(clusterOptions = markerClusterOptions(), lng = dataset2$lon, lat = dataset2$lat, popup = paste("Price: £", as.character(dataset2$price), sep = ""))  
    }
    if(3 == as.numeric(input$price)) {
      leafletProxy("map") %>% addMarkers(clusterOptions = markerClusterOptions(), lng = dataset3$lon, lat = dataset3$lat, popup = paste("Price: £", as.character(dataset3$price), sep = "")) 
    }
    if(4 == as.numeric(input$price)) {
      leafletProxy("map") %>% addMarkers(clusterOptions = markerClusterOptions(), lng = dataset4$lon, lat = dataset4$lat, popup = paste("Price: £", as.character(dataset4$price), sep = "")) 
    }
    if(5 == as.numeric(input$price)) {
      leafletProxy("map") %>% addMarkers(clusterOptions = markerClusterOptions(), lng = dataset5$lon, lat = dataset5$lat, popup = paste("Price: £", as.character(dataset5$price), sep = ""))
    }
     
  })
  
  
})
