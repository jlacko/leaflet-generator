# vytvoří vzorový excel

library(tidyverse)
library(writexl)

input <- data.frame(id = c("Kramářova vila", "Pražský hrad", "Strakova akademie", "Sněmovna", "Senát"),
                    lng = c(14.4104392, 14.3990089, 14.4117831, 14.4039458, 14.4053489),
                    lat = c(50.0933681, 50.0895897, 50.0920997, 50.0891494, 50.0900269),
                    kategorie = c("moc výkonná", "moc výkonná", "moc výkonná", "moc legislativní", "moc legislativní"),
                    popisek = c('hnízdiště <i><a href = "https://cs.wikipedia.org/wiki/%C4%8C%C3%A1p_b%C3%ADl%C3%BD">Ciconia ciconia L.</a></i>', "prezidence rezidenta", 'zimoviště <i><a href="https://cs.wikipedia.org/wiki/Straka_obecn%C3%A1">Pica pica L.</a></i>', "dolní komora", "horní komora"))

write_xlsx(list("vstup" = input), "./data-raw/vzorek.xlsx")