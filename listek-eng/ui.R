library(shiny)
library(leaflet)

# Define UI 
ui <- fluidPage(
    fluidRow(
        column(width = 5,
               fileInput('input', label = 'Upload excel',
                      accept = c('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', '.xlsx'))
        ),

        column(width = 1,
               offset = 4,
               p(),
               uiOutput('stahovatko'),
               uiOutput('chybovatko'),
               align = 'right'
        )),
        
        # vlastní mapa - na prrravo!
            leafletOutput('map')
    )


