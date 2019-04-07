import docopt
import util/parser
import models/graph
import models/vertex
import solvers/greedy
import util/config
import sets
import tables
import json
import sequtils

let doc = """
Traveller: a TSP solver.

Usage:
  traveller <input> --type <type>

Options:
  -h --help     Show this screen
  -v --version  Show the version
  --type        Type of input (graph or georgraphy)
"""

# The input is a CSV file with the format:
# Line 1: the vertex range, i.e. 1, 10 (inclusive)
# Line 2+: edges with weights
let args = docopt(doc, version = "Traveller 1.0")

loadConfig()

var G: Graph
var backMap: Table[int, tuple[lat: string, long: string, name: string]]

case ($args["<type>"])
of "graph":
  G = csvOfGraph($args["<input>"])
  var results = solveGreedy(G)
  echo "Shortest path:"
  for result in results:
    echo "\t" & $result
of "geography":
  (G, backMap) = csvOfGeography($args["<input>"])
  var results = map(solveGreedy(G), proc(x: int): tuple[lat: string, long: string, name: string] = (lat: backMap[x].lat, long: backMap[x].long, name: backMap[x].name))
  echo "Shortest path:"
  for result in results:
    echo "\t" & result.name & ": " & result.lat & "," & result.long
else:
  echo "1"
  var e: ref ValueError
  new(e)
  e.msg = "Invalid CSV type"

