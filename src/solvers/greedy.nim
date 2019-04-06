import ../models/graph
import ../models/vertex
import ../models/edge
import lists
import algorithm
import sets
import sequtils

proc solveGreedy*(graph : Graph) : seq[Vertex] =
  var path: seq[Vertex]
  var vertices: VertexSet
  var edges: EdgeSet
  edges.init()
  deepCopy(vertices, graph.vertices)
  deepCopy(edges, graph.edges)
  var v: Vertex
  v = toSeq(vertices.items)[0]
  path.add(v)
  while vertices.len != path.len:
    var temp: seq[Edge]
    for edge in edges.items:
      if v in edge.vertices:
        edges.excl(edge)
        temp.add(edge)
    if temp.len == 0:
      var e: ref ValueError
      new(e)
      e.msg = "Graph is not Hamiltonian"
      raise e
    temp.sort do (x, y: Edge) -> int:
      result = cmp(x.weight, y.weight)
    let vs = toSeq(temp[0].vertices.items)
    if vs[0] == v:
      v = vs[1]
    else:
      v = vs[0]
    path.add(v)
  path 