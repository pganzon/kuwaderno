install.packages(
c("dplyr","ggplot2","plotly","stringr","lubridate","reshape2","gmodels","httr","BoomSpikeSlab","dygraphs","shiny","RJDBC","markdown", "knitr","rmarkdown","devtools","data.table"), repos='https://cran.rstudio.com/')

library(devtools)
library(httr)

set_config( config( ssl_verifypeer = 0L ) )
devtools::install_github("google/CausalImpact",host = "http://api.github.com")



