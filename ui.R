
library(leaflet)
library(shiny)

shinyapps::setAccountInfo(name='####',
                          token='#####',
                          secret='####') #Fill these in with shinyapps account details
shinyUI(
  
  fluidPage(
                
        div(class="outer",
        
          includeCSS("styles.css"),
            
          leafletOutput("map", height = "100%", width = "100%"),
       
    
          div(class = "test",
          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                  draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                  width = 330, height = "auto", alpha = 0.4,
                  
                  h2("UK Housing Prices"),
                  
                  radioButtons("price", "House Prices:",choices = c("£0-£100,000" = 1,"£100,001-£300,000" = 2,"£300,001-£500,000" = 3,"£500,001-£1,000,000" = 4,">£1,000,000" = 5), selected = 1)

                  )
          
                  )
                          
    
        )
      
    
  )
)



