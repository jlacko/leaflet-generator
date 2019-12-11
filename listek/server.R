library(shiny)
library(leaflet)
library(RCzechia)
library(htmlwidgets)
library(readxl)
library(writexl)
library(sf)



server <- function(input, output) {
  
  jsou_chyby <- reactiveVal(FALSE)
  
  mapa <- reactive({ # reaktivní Leaflet.js objekt - pro zobrazení i uložení
    

    
    # je něco zadaného?
    if(is.null(input$input)){
      
      # nullová verze - nic není...
      vystup <-   leaflet() %>% 
        addProviderTiles('Stamen.Toner') %>% 
        addPolygons(data = republika('low'),
                    color = 'grey')
      
      return(vystup) # vracím a skončím
      
    }      
        
        
    # pokud je něco zadaného = načíst
    dataset <- read_excel(input$input$datapath)
    
    # incializace prázdných chyb
    chybar <<- data.frame() 
    jsou_chyby(FALSE)
    
        
    # kontrola správnosti hlaviček  souboru
    if(!setequal(names(dataset), c("id", "lng", "lat", "kategorie", "popisek"))) {
      
      # katastrofická failure
      showNotification("Zpracování souboru se nezdařilo, zkontrolujte hlavičku!", type = 'error')
      
      # nullová verze - nic není...
      vystup <-   leaflet() %>% 
          addProviderTiles('Stamen.Toner') %>% 
          addPolygons(data = republika('low'),
                      color = 'grey')
          
      return(vystup)
          
    }
        
    #kontrola, zda jsou souřadnice číselné
    chyby <- is.na(as.numeric(dataset$lng)) | is.na(as.numeric(dataset$lat))
    
    if(sum(chyby) != 0) {
      
      jsou_chyby(TRUE)
      
      showNotification(paste('Pozor, odstraněno', sum(chyby) , 'nečíselných souřadnic!'), type = 'warning')
      
      # aktualizovat chybář
      chybar <<- rbind(chybar, subset(dataset, chyby))
      
      # eliminace chyb
      dataset <- subset(dataset, !chyby) 
          
      # konverze na číselné hodnoty souřadnic
      dataset$lng <- as.numeric(dataset$lng) 
      dataset$lat <- as.numeric(dataset$lat)

          }
        
    #kontrola, zda nejsou souřadnice haluz
      chyby <- abs(dataset$lng) > 180  | abs(dataset$lat) > 180
    if(sum(chyby) != 0) {
      
      jsou_chyby(TRUE)
      
      showNotification(paste('Pozor, odstraněno', sum(chyby) , 'souřadnic mimo interval ± 180!'), type = 'warning')

      # aktualizovat chybář
      chybar <<- rbind(chybar, subset(dataset, chyby))
                
      # eliminace chyb
      dataset <- subset(dataset, !chyby) 
          
    }
      
    # je správně = překreslím leaflet
    paleta <- leaflet::colorFactor("Spectral", 
                                   domain = dataset$kategorie)
          
    vystup <- leaflet(data = dataset) %>% 
    addProviderTiles('Stamen.Toner',
                     options = leafletOptions(opacity = .75,
                                              attribution = 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> — Map data © <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors — vytvořeno v <a href="https://www.jla-data.net/cze/jla-leaflet-generator/">JLA generátoru</a>')) %>% 
    addCircleMarkers(radius = 10, # size of the dots
                     fillOpacity = 1, # alpha of the dots
                     stroke = FALSE, # no outline
                     popup = ~paste0('<b>', dataset$id, '</b><br>', dataset$popisek),
                     color = paleta(dataset$kategorie),
                     clusterOptions = markerClusterOptions()) %>% 
    addLegend(position = "bottomright",
              values = ~kategorie, # data frame column for legend
              opacity = 1, # alpha of the legend
              pal = paleta, # palette declared earlier
              title = "kategorie") 
    
    vystup # vracím leaflet objekt...
      
  }) # / fce
  
  
  # Define server logic       
  observe(output$map <- renderLeaflet({
      mapa()
    }))
  
   
    output$stahovatko <- renderUI({ # stahovátko - čudlík se ukáže až po zadání souboru
      
      if (!is.null(input$input)) downloadButton('output', label = 'Uložit soubor')
      
    })
    
    output$chybovatko <- renderUI({ # chybovátko - čudlík se ukáže, pokud existují chyby
      if (jsou_chyby()) downloadButton('chybar', label = 'Sezam chyb')
    })
    
    output$output <- downloadHandler( # ukládátko -  stisknutí uloží soubor do lokálu
      filename = "leaflet.html",
      content = function(file) saveWidget(mapa(), file = file),
      contentType = "html")
    
    
    output$chybar <- downloadHandler( # ukládátko -  stisknutí uloží soubor do lokálu
      filename = "chybar.xlsx",
      content = function(file) write_xlsx(chybar, path = file),
      contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")

}

