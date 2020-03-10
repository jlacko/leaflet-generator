library(shiny)
library(leaflet)
library(htmlwidgets)
library(leaflet.extras)
library(readxl)
library(writexl)
library(sf)



server <- function(input, output) {
  
  jsou_chyby <- reactiveVal(FALSE)
  
  mapa <- reactive({ # reaktivní Leaflet.js objekt - pro zobrazení i uložení

    # je něco zadaného?
    if(is.null(input$input)){
      
      # nullová verze - nic není...
      vystup <- leaflet() %>% 
        addProviderTiles('CartoDB.Positron') 
      
      return(vystup) # vracím a skončím
      
    }      

    # pokud je něco zadaného = načíst
    dataset <- read_excel(input$input$datapath)
    
    # incializace prázdných chyb
    chybar <<- data.frame() 
    jsou_chyby(FALSE)
    
        
    # kontrola správnosti hlaviček  souboru
    if(!setequal(names(dataset), c("id", "lng", "lat", "category", "label"))) {
      
      # katastrofická failure
      showNotification("Unexpected structure of input; check header row!", type = 'error')
      
      # nullová verze - nic není...
      vystup <- leaflet() %>% 
          addProviderTiles('CartoDB.Positron') 
          
      return(vystup) # končím předčasně!
          
    }
        
    #kontrola, zda jsou souřadnice číselné
    chyby <- is.na(as.numeric(dataset$lng)) | is.na(as.numeric(dataset$lat))
    
    if(sum(chyby) != 0) {
      
      jsou_chyby(TRUE)
      
      showNotification(paste('Warning: removed', sum(chyby) , 'non-numerical coordinates!'), type = 'warning')
      
      # aktualizovat chybář
      chybar <<- rbind(chybar, subset(dataset, chyby))
      
      # eliminace chyb
      dataset <- subset(dataset, !chyby) 
          
      # konverze na číselné hodnoty souřadnic
      dataset$lng <- as.numeric(dataset$lng) 
      dataset$lat <- as.numeric(dataset$lat)

          }
        
    #kontrola, zda nejsou souřadnice haluz
      chyby <- abs(dataset$lng) > 180  | abs(dataset$lat) > 90
    if(sum(chyby) != 0) {
      
      jsou_chyby(TRUE)
      
      showNotification(paste('Warning: removed', sum(chyby) , 'coordinates out of bounds!'), type = 'warning')

      # aktualizovat chybář
      chybar <<- rbind(chybar, subset(dataset, chyby))
                
      # eliminace chyb
      dataset <- subset(dataset, !chyby) 
          
    }
      
    showNotification(paste('Processed', nrow(dataset) , 'plausible looking coordinates.'), type = 'message')
      
      
    # je správně = překreslím leaflet
    paleta <- leaflet::colorFactor("viridis", 
                                   domain = dataset$category)
          
    vystup <- leaflet(data = dataset) %>% 
      addProviderTiles('CartoDB.Positron',
                       options = leafletOptions(opacity = .75,
                                                attribution = 'Map tiles by <a href="http://stamen.com", target="_blank">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0", target="_blank">CC BY 3.0</a> — Map data © <a href="https://www.openstreetmap.org/copyright", target="_blank">OpenStreetMap</a> contributors — created with <a href="https://www.jla-data.net/eng/jla-leaflet-generator/", target="_blank">JLA Leaflet Generator</a>')) %>% 
      addCircleMarkers(radius = 5, # size of the dots
                       fillOpacity = 1, # alpha of the dots
                       stroke = FALSE, # no outline
                       popup = ~paste0('<b>', dataset$id, '</b><br>', dataset$label),
                       color = paleta(dataset$category)) %>% 
      addLegend(position = "bottomright",
                values = ~category, # data frame column for legend
                opacity = 1, # alpha of the legend
                pal = paleta, # palette declared earlier
                title = "Category:") %>% 
      addResetMapButton()
    
    vystup # vracím leaflet objekt...
      
  }) # / fce
  
  
  # Define server logic       
  observe(output$map <- renderLeaflet({
      mapa()
    }))
  
   
    output$stahovatko <- renderUI({ # stahovátko - čudlík se ukáže až po zadání souboru
      if (!is.null(input$input)) downloadButton('output', label = 'Save leaflet')
    })
    
    output$chybovatko <- renderUI({ # chybovátko - čudlík se ukáže, pokud existují chyby
      if (jsou_chyby()) downloadButton('chybar', label = 'Save errors')
    })
    
    output$output <- downloadHandler( # ukládátko -  stisknutí uloží soubor do lokálu
      filename = "leaflet.html",
      content = function(file) saveWidget(mapa(), file = file),
      contentType = "html")
    
    
    output$chybar <- downloadHandler( # ukládátko -  stisknutí uloží soubor do lokálu
      filename = "errors.xlsx",
      content = function(file) write_xlsx(chybar, path = file),
      contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")

}

