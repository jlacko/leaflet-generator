library(shiny)
library(leaflet)

# Define UI 
ui <- fluidPage(
    
    # sexy titulek :)
    titlePanel('Leaflet generátor'),
    
    # vlevo ovladání, vpravo mapa
    sidebarLayout(
        # ovládací panel
        sidebarPanel(   
            fileInput('input', label = 'Nahrát excel',
                      accept = c('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', '.xlsx')),
#            textOutput('kontrola'),
            p(),
            uiOutput('stahovatko'),
        width = 2),
        
        # vlastní mapa - na prrravo!
        mainPanel(
            leafletOutput('map')
        )
    )
)

