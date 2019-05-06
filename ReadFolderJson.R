library(jsonlite)
library(tidyverse)

NBAjsonToDF = function(json_path){
  library(jsonlite)
  data = jsonlite::fromJSON(json_path)
  df = as.data.frame(data$resultSets$rowSet)
  names(df) = unlist(data$resultSets$headers)
  return(df)
}


dir = "C:/Users/Sam/Desktop/NBA Data/"

for (name in list.files(dir)){
  assign(name,NBAjsonToDF(paste(dir,name, sep = "")))
}
