library(shiny)
library(leaflet)
library(RCzechia)
library(readxl)
library(sf)

# Define server logic       
server <- function(input, output) {
    
    output$map <- renderLeaflet({
        leaflet() %>% 
            addProviderTiles('Stamen.Toner') %>% 
            addPolygons(data = republika('low'), 
                        color = 'grey')
    })
    
    output$kontrola <- renderText({
        if (is.null(input$input))
            return('soubor nenahrán :(')
        'soubor zpracován:)'
        })
    
    output$stahovatko <- renderUI({
        req(!is.null(input$input)) # 
        downloadButton('output', label = 'Uložit výsledek')
    })
    
}

