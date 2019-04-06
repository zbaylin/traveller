import json

var apiKey: string

proc loadConfig*() =
  let json = parseJson(readFile("config.json"))
  apiKey = json["apiKey"].getStr()

proc getApiKey*() : string =
  return apiKey