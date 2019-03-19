import edge
import vertex

type
  Graph* = object
    vertices*: VertexSet
    edges*: EdgeSet