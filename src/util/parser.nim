import csvtools
import ../models/graph
import ../models/vertex
import ../models/edge
import ../util/permutation
import ../util/config
import sets
import tables
import strutils
import sequtils
import algorithm
import httpclient
import json
import uri

proc csvOfGraph*(input : string) : Graph =
  var V: VertexSet
  var E: EdgeSet
  var G: Graph
  V.init()
  E.init()
  for row in csvRows(input):
    case row[0]
    of "Vertices":
      var lowBound, highBound : int
      lowBound = parseInt(row[1])
      highBound = parseInt(row[2])
      for i in lowBound..highBound:
        V.incl(i)
    of "Edge":
      var e: Edge
      var v: VertexSet
      v.init()
      v.incl(parseInt(row[1]))
      v.incl(parseInt(row[2]))
      e.vertices = v
      e.weight = parseFloat(row[3])
      E.incl(e)
  G.vertices = V
  G.edges = E
  return G

proc csvOfGeography*(input : string) : Graph =
  var V: VertexSet
  var E: EdgeSet
  var G: Graph
  var backMap = initTable[int, tuple[lat: string, long: string]]()
  let client = newHttpClient()
  V.init()
  E.init()
  let arr = toSeq(csvRows(input))
  for i in 0..(arr.len - 1):
    backMap[i] = (lat: arr[i][0], long: arr[i][1])
  let vSeq = toSeq(backMap.keys)
  V = toSet(vSeq)
  var temp: seq[tuple[a: int, b: int, w: float]]
  for comb in combinations(vSeq, 2).items:
    let startCoord = backMap[comb[0]]
    let endCoord = backMap[comb[1]]
    let str = "https://api.openrouteservice.org/v2/directions/driving-car?api_key=" & getApiKey() & "&start=" & startCoord.lat & "," & startCoord.long & "&end=" & endCoord.lat & "," & endCoord.long
    let json = client.getContent(str).parseJson()
    temp.add((a: comb[0], b: comb[1], w: json["features"][0]["properties"]["summary"]["distance"].getFloat()))
  temp.sort do (x, y : tuple[a: int, b: int, w: float]) -> int:
    result = cmp(y.w, x.w)
  let max = temp[0].w
  for item in temp.items:
    var e: Edge
    e.vertices.init()
    e.vertices.incl(item.a)
    e.vertices.incl(item.b)
    e.weight = item.w / max
    E.incl(e)
  G.vertices = V
  G.edges = E
  return G
