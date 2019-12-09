library(shiny)
library(leaflet)
library(RCzechia)
library(htmlwidgets)
library(readxl)
library(sf)



server <- function(input, output) {
  
mapa <- reactive({ # reaktivní Leaflet.js objekt - pro zobrazení i uložení
    
    # je něco zadaného?
    if(is.null(input$input)){
      
      # nullová verze - nic není...
      vystup <-   leaflet() %>% 
        addProviderTiles('Stamen.Toner') %>% 
        addPolygons(data = republika('low'),
                    color = 'grey')
    } else {
      
      # pokud je něco zadaného = načíst
      dataset <- read_excel(input$input$datapath)
      
      # kontrola správnosti načteného souboru
      if(setequal(names(dataset), c("id", "lng", "lat", "kategorie", "popisek"))) {
        
        # je správně = překreslím leaflet
        paleta <- leaflet::colorFactor("viridis", 
                                       domain = dataset$kategorie)
        
        vystup <- leaflet(data = dataset) %>% 
          addProviderTiles('Stamen.Toner',
                           options = leafletOptions(attribution = 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> — Map data © <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors — vytvořeno pomocí <a href="https://www.jla-data.net">JLA generátor</a>')) %>% 
          addCircleMarkers(radius = 10, # size of the dots
                           fillOpacity = .7, # alpha of the dots
                           stroke = FALSE, # no outline
                           popup = ~paste0('<b>', dataset$id, '</b><br>', dataset$popisek),
                           color = paleta(dataset$kategorie),
                           clusterOptions = markerClusterOptions()) %>% 
          addLegend(position = "bottomright",
                    values = ~kategorie, # data frame column for legend
                    opacity = .7, # alpha of the legend
                    pal = paleta, # palette declared earlier
                    title = "kategorie") 
        
      } else {
        
        # katastrofická failure
        
        showNotification("soubor se nepovedlo nahrát!", type = 'error')
        
        # nullová verze - nic není...
        vystup <-   leaflet() %>% 
          addProviderTiles('Stamen.Toner') %>% 
          addPolygons(data = republika('low'),
                      color = 'grey')
        
      }
      
    }
    vystup # vracím leaflet objekt...
    
  }) # / fce
  
  
  # Define server logic       
  
  cesta <- reactiveVal()
    
    observe(output$map <- renderLeaflet({
        
      ukazuji <- mapa()

    }))
    
    
#   output$kontrola <- renderText({
#       if (is.null(input$input)) return('soubor nenahrán :(')
#       'soubor zpracován:)'
#       })
   
    output$stahovatko <- renderUI({
        if (!is.null(input$input)) downloadButton('output', label = 'Uložit výsledek')
    })
    
    output$output <- downloadHandler(
        
        filename = "leaflet.html",
        content = function(file) saveWidget(mapa(), file = file),
        contentType = "html"
        
    )
    
}

