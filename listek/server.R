library(shiny)
library(leaflet)
library(RCzechia)
library(readxl)
library(sf)

dataset <- NULL



digest <- function(cesta) { # načíst a zkontrolovat soubor; pokud cajk tak uložit a vrátit true
    
#    browser()
    
    # je něco zadaného?
    if(is.null(cesta)) 
        return(FALSE)
    
    # pokud je něco zadaného, a ještě jsem nic nezpracoval = načíst
    if(is.null(dataset)) {
        dataset_wrk <- read_excel(cesta$datapath)
        
        # kontrola správnosti načteného souboru
        if(all.equal(names(dataset_wrk), c("id", "lon", "lat", "kategorie", "popisek"))) {
            
            dataset <<- dataset_wrk # je to cajk, můžu dál
            
            # překreslím leaflet
            paleta <- leaflet::colorFactor("viridis", 
                                           domain = dataset$kategorie)
            
            leafletProxy("map", data = dataset) %>% 
                clearShapes() %>% 
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
            return(FALSE) # necajk, ještě jednou a pořádně...
        } # / správnost
    } # / prázdný dataset
    
    TRUE
} # / fce


# Define server logic       
server <- function(input, output) {
    
    observe(output$map <- renderLeaflet({
        
            leaflet() %>% 
                addProviderTiles('Stamen.Toner') %>% 
                addPolygons(data = republika('low'),
                            color = 'grey')

    }))
    
    
    output$kontrola <- renderText({
        if (!digest(input$input)) return('soubor nenahrán :(')
        'soubor zpracován:)'
        })
    
    output$stahovatko <- renderUI({
        if (digest(input$input)) downloadButton('output', label = 'Uložit výsledek')
    })
    
}

