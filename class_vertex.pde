class Vertex {
  int x, y, edgeIndex;
  float altitude, distance;
  IntList neighbors;

  Vertex( int _x, int _y, float _n ){
    this.x = _x;
    this.y = _y;
    this.altitude = _n;
    this.distance = MAX_FLOAT;
    this.edgeIndex = -1;
    this.neighbors = new IntList();
  }

  void addNeighbor( int i ){
    neighbors.appendUnique( i );
  }
  
}