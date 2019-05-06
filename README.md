# stats.NBA-Project
As of 5/5/2019


https://stats.nba.com/ has an incredibly rich amount of stats that cannot be subsitituted by using other means like https://www.basketball-reference.com/. This project aims to scrape the json file that is called for the Javascript tables and purpose them into dataframes in R for analytics.

This is entirely possible to do all within python using pandas, but I prefer working with JSON files and post processing in R. 

To do: Generalize the URL to be able to select the stats you want to request in JSON file.

> /stats/synergyplaytypes?LeagueID=**00**&PerMode=**PerGame**&PlayType=**Transition**&PlayerOrTeam=**T**&SeasonType=**Regular+Season**&SeasonYear=**2018-19**&TypeGrouping=**offensive**

Just from this url, there are many **modifyable** areas that can return new values. See "URL Boundry Condition** for details on how we find all of the boundry conditions. 

## Python Scrape JSON and Parameter Mapping

### Python JSON stats.NBA Scraper Function
```python
def ReadNBAJson(url,save_name):
    #URL is the nba.stats table that you want to scrape. 
    #save_name is the output where you want your files saved. 
    
    #Libraries used for this function
    import requests 
    import json
    
    #Header is found on the inspection of the page. 
    headers = ***See Below***
    response = requests.get(url, headers = headers).json()
    
    #Save the file
    with open(save_name,'w') as outfile:
    json.dump(response,outfile)
```

**Defining Header**: found in "Request Headers" under Inspect->Network->Headers

**Defining URL**: found under inspecting the stats.NBA page of interest and opening up in a seperate browser. Should be in JSON format. 

### URL Boundry Conditions

When one of the parameters within the URL is incorrect, the error that is returned will show the only acceptable parameters. These can be grabbed similarly as we grab the JSON file only we just want the string that is passed back to be parsed later. 

```python
def ParameterError(url):
    import requests
    headers = ***Same As Before***
    page = requests.get(url,headers=headers)
    return(page.content)
```

Example Output if you put incorrect *PerGame* parameter:
> The field PerMode must match the regular expression '^(Totals)|(PerGame)$'.

Using this, we can map most of what the paremeters are so we do not have to fetch the url for the json file form the website. However this doesn't work on everything like "PlayType". 

### Example

```python
import json

PlayType = ["Isolation", "Transition","PRBallHandler","PRRollMan","PostUp","SpotUp","Handoff","Cut","OffScreen","Putbacks","Misc"]
for play in PlayType:
    data = ReadNBAJson("https://stats.nba.com/stats/synergyplaytypes?LeagueID=00&PerMode=PerGame&PlayType="+play+"&PlayerOrTeam=T&SeasonType=Regular+Season&SeasonYear=2018-19&TypeGrouping=offensive")
    with open([Address you want to store to]+play+".json",'w') as outfile:
        json.dump(data,outfile)
```
Example output:

![OutPut](https://imgur.com/seRaZ1A.png)

Note that "Putbacks" doens't have the correct size. On further investigation, `Putbacks` are labeled as `OffRebound`



## R Post Processing

### R Import stats.NBA JSON to Data Frame Function
```r
NBAjsonToDF = function(json_path){
  library(jsonlite)
  data = jsonlite::fromJSON(json_path)
  df = as.data.frame(data$resultSets$rowSet)
  names(df) = unlist(data$resultSets$headers)
  return(df)
}
```

### Visualization Showcase:

![image](https://imgur.com/8ZJZ7gN.png)
Houston and their ISOs (Z score normalized against all teams)

![image2](https://imgur.com/dtTtfgf.png)
Points from the Roll vs. Points from the Pop

![image3](https://github.com/smlederer/stats.NBA-Project/blob/master/images/ppp_over_time.PNG)
Spot Up Points Per Possession over time (Max lookback 2012 season)
