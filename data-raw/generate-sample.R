# vytvoří vzorový excel

library(tidyverse)
library(writexl)

input <- data.frame(id = c("Kramářova vila", "Pražský hrad", "Strakova akademie", "Sněmovna", "Senát"),
                    lat = c(14.4104392, 14.3990089, 14.4117831, 14.4039458, 14.4053489),
                    lon = c(50.0933681, 50.0895897, 50.0920997, 50.0891494, 50.0900269),
                    kategorie = c("výkonná", "výkonná", "výkonná", "legislativa", "legislativa"),
                    popisek = c("rezidence premiéra", "rezidence prezidenta", "sídlo vlády", "dolní komora", "horní komora"))

write_xlsx(list("vstup" = input), "./data-raw/vzorek.xlsx")