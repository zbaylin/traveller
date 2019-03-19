import csvtools
import ../models/graph
import ../models/vertex
import ../models/edge
import sets
import strutils

proc csvToGraph*(input : string) : Graph =
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
      