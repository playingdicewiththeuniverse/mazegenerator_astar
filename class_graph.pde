// Graph class contains a set of vertices
class Graph {
  int size, stackTopIndex;
  Vertex[] nodes;
  IntList stack;
  float dMin, dMax;
  FloatList distances;
  

  Graph( int _size ) {
    this.size = _size;
    this.nodes = new Vertex[ _size ];
    this.stack = new IntList();
    this.dMin = 0;
    this.dMax = 0;
    this.distances = new FloatList();
  }


  IntList getOpenNeighbors( int thisNodeIndex ){
    IntList openNeighbors = new IntList();
    for( int n = 0; n < this.nodes[ thisNodeIndex ].neighbors.size(); n++ ){
      int neighborNodeIndex = this.nodes[ thisNodeIndex ].neighbors.get(n);
      if( this.stack.hasValue( neighborNodeIndex ) == true ){
        // a neighbor is only open if it is still in the open list
        openNeighbors.appendUnique( neighborNodeIndex );
      }
    }
    return openNeighbors;
  }
    

  void update() {

    // find vertex in open list with shortest distance
    int bestOpenIndex = -1;
    float bestOpenDistance = MAX_FLOAT;
    
    for( int i = 0; i < this.stack.size(); i++ ){
      int thisIndex = this.stack.get(i);
      if( this.nodes[thisIndex].distance <= bestOpenDistance ){
        bestOpenDistance = this.nodes[thisIndex].distance;
        bestOpenIndex = i;
      }
    }
    
    // set this vertex to current and remove from the open list
    this.stackTopIndex = this.stack.get(bestOpenIndex);
    this.stack.remove(bestOpenIndex);

    Vertex currentVertex = this.nodes[this.stackTopIndex];
    float currentVertexDistance = currentVertex.distance; 

    // add this distance into the final values
    this.distances.append(currentVertexDistance);
    
    // get all open neighbors of this vertex  
    IntList currentVertexNeighbors = this.getOpenNeighbors( this.stackTopIndex );
    
    for( int i = 0; i < currentVertexNeighbors.size(); i++ ){
      int neighborIndex          = currentVertexNeighbors.get(i);
      Vertex neighborVertex      = this.nodes[ neighborIndex ];
      float  neighborDistanceOld = neighborVertex.distance;
      float  neighborDistanceNew = currentVertexDistance + DISTANCE_COST + ( HILL_COST * abs( currentVertex.altitude - neighborVertex.altitude ) );
      if( neighborDistanceNew < neighborDistanceOld ){
        this.nodes[ neighborIndex ].edgeIndex = this.stackTopIndex;
        this.nodes[ neighborIndex ].distance = neighborDistanceNew;
      }
    }

    this.dMin = this.distances.min();
    this.dMax = this.distances.max();

  }
  

  void render( int renderMode ) {

    noStroke();
    background(0);

    for( int i = 0; i < this.size; i++ ){
      Vertex node = this.nodes[i];

      if( node.edgeIndex > -1 ){
        if( this.stackTopIndex == i && this.stack.size() > 0 ){
          fill( HEAD_CLR );  // this node is the top of the stack
        }else if( this.stack.hasValue( i ) ){
          fill( OPEN_CLR ); // this node is still in the stack
        }else if( renderMode == 1 ){
          int val = (int)map( node.distance, dMax, dMin, 0, 715 ) + 50;
          int r = constrain( val, 0, 255 );
          int g = constrain( val-255, 0, 255 );
          int b = constrain( val-510, 0, 255 );
          fill( r, g, b );
        }else if( renderMode == 2 ){
          int val = (int)map( node.distance, dMax, dMin, 715, 0 ) + 50;
          int r = constrain( val, 0, 255 );
          int g = constrain( val-255, 0, 255 );
          int b = constrain( val-510, 0, 255 );
          fill( r, g, b );
        }else{
          fill( FILL_CLR ); // this node's path has been determined
        }

        // draw vertex
        int x1 = S + (S * 2 * node.x);
        int y1 = S + (S * 2 * node.y);
        rect( x1, y1, S, S );

        // draw edge
        int x2 = S + (S * ( node.x + this.nodes[ node.edgeIndex ].x ));
        int y2 = S + (S * ( node.y + this.nodes[ node.edgeIndex ].y ));
        rect( x2, y2, S, S );

      }else{
        fill( 0, node.altitude * 255, 0 );
        int x1 = S + (S * 2 * node.x);
        int y1 = S + (S * 2 * node.y);
        rect( x1, y1, S, S );
      }
    }
  }

}