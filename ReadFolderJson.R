library(jsonlite)
library(tidyverse)

dir = "C:/Users/Sam/Desktop/NBA Data/"

for (name in list.files(dir)){
  assign(name,NBAjsonToDF(paste(dir,name, sep = "")))
}
