import vertex
import sets
import hashes

# This is a generic edge type
# It includes a set of vertices and a weight
# We use a set so we don't end up with duplicate edges ((a,b) =/> (b,a))
type
  Edge* = object
    vertices*: VertexSet
    weight*: float

proc hash*(e: Edge): Hash =
  var h: Hash = 0
  h = h !& hash(e.vertices)
  h = h !& hash(e.weight)
  result = !$h

# This is just a predefined type of a hashset of edges
type
  EdgeSet* = HashSet[Edge]