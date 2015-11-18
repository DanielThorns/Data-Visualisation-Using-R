library(leaflet)
library(shiny)
library (RMongo)

test <- mongoDbConnect('hp')
dataset1 <- dbGetQuery(test, 'houses', "{'price': {$gt: 0,$lt: 100000}}", skip = 0, limit = 10000)
dataset2 <- dbGetQuery(test, 'houses', "{'price': {$gt: 100000,$lt: 300000}}", skip = 0, limit = 10000)
dataset3 <- dbGetQuery(test, 'houses', "{'price': {$gt: 300000,$lt: 500000}}", skip = 0, limit = 10000)
dataset4 <- dbGetQuery(test, 'houses', "{'price': {$gt: 500000,$lt: 1000000}}", skip = 0, limit = 10000)
dataset5 <- dbGetQuery(test, 'houses', "{'price': {$gt: 1000000}}", skip = 0, limit = 10000)

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
