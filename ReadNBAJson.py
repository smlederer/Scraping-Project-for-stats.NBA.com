def ReadNBAJson(url):
    import requests
    import json

    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36'}
    response = requests.get(url, headers = headers).json()
    return response
