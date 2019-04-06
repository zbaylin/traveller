import docopt
import util/parser
import models/graph
import solvers/greedy
import sets

let doc = """
Traveller: a TSP solver.

Usage:
  traveller <input>

Options:
  -h --help     Show this screen
  -v --version  Show the version
"""

# The input is a CSV file with the format:
# Line 1: the vertex range, i.e. 1, 10 (inclusive)
# Line 2+: edges with weights
let args = docopt(doc, version = "Traveller 1.0")

var G : Graph = csvToGraph($args["<input>"])
echo solveGreedy(G)