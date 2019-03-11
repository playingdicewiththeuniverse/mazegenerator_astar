// Config

// graph dimensions
// 2x2 @ 216px  / 4x4 @ 120px  /  7x7 @ 72px  /  13x13 @ 40px  /  22x22 @ 24px  /  67x67 @ 8px 
final int S = 20;
final int W = 22;
final int H = 22;

// output colors
final color HEAD_CLR  = color(255,0,0);
final color OPEN_CLR  = color(102);
final color FILL_CLR  = color(255);

// cost of moving to a neighbor at the same altitude
final float DISTANCE_COST = -0.2;

// scaling factor for cost of altitude difference
final float HILL_COST     = 1.0;

// randomness factors
final int MAZE_SEED     = 42;
final float NOISE_SCALE = 13.8 / max(W,H);

// pick a starting vertext
final int START         = 0;

// set to true to save out frames
final Boolean RECORD  = false;


// Varaibles
Vertex[] graph      = new Vertex[W * H];
IntList openList    = new IntList();
int currentIndex    = START;
FloatList distances = new FloatList();
float dMin, dMax;

// Vertex class for each square
class Vertex {
  float altitude;
  float distance;
  int x, y, idx, edge;
  IntList neighbors = new IntList(); // list of neighbors

  Vertex( int _x, int _y, float _n ){
    // set position
    x = _x;
    y = _y;
    altitude = _n;
    distance = MAX_FLOAT;
    idx = _y * W + _x;
    edge = -1;

    // find valid neighbors
    if( y > 0 )   neighbors.append((y-1) * W + x); // north
    if( x < W-1 ) neighbors.append(y * W + (x+1)); // east
    if( y < H-1 ) neighbors.append((y+1) * W + x); // south
    if( x > 0 )   neighbors.append(y * W + (x-1)); // west

    // randomize neighbors
    // neighbors.shuffle();
  }


  void show() {
    if( edge > -1 ){
      // determine vertex color
      if( idx == currentIndex ){
        fill( HEAD_CLR ); // highlight the current top of the stack
      }else if( openList.hasValue( idx ) == true ){
        fill( OPEN_CLR );
      }else{
        fill( FILL_CLR );
      }

      int x1 = S + (S * 2 * x);
      int y1 = S + (S * 2 * y);
      rect( x1, y1, S, S );

      int x2 = S + (S * ( x + graph[edge].x ));
      int y2 = S + (S * ( y + graph[edge].y ));
      rect( x2, y2, S, S );

    }else{
      
      fill( 0, altitude * 255, 0 );
      int x1 = S + (S * 2 * x);
      int y1 = S + (S * 2 * y);
      rect( x1, y1, S, S );
      
    }
  }


  IntList getOpenNeighbours() {
    IntList openNeighbors = new IntList();
    for( int n = 0; n < neighbors.size(); n++ ){
      int neighborIndex = neighbors.get(n);
      if( openList.hasValue( neighborIndex ) == true ){
        openNeighbors.appendUnique( neighborIndex );
      }
    }
    return openNeighbors;
  }

}


void settings() {
  // Size based on width, height, and square size
  int wi = S + (2 * S * W);
  int hi = S + (2 * S * H);
  size( wi, hi, P2D );
}


void setup() {
  background(0);
  noStroke();
  noiseSeed(MAZE_SEED);
  randomSeed(MAZE_SEED);
  noiseDetail(16);
  
  // Initialize graph and edge arrays
  for( int x = 0; x < W; x++ ){
    for( int y = 0; y < H; y++ ){
      int v = y*W+x;
      float n = noise(x*NOISE_SCALE, y*NOISE_SCALE);
      n = random(0,1);
      graph[v] = new Vertex(x,y,n);
      openList.append( v );
    }
  }

  // Start with the first point
  graph[currentIndex].edge = currentIndex;
  graph[currentIndex].distance = 0;
}

void update() {
  
  
  // find vertex in open list with shortest distance
  int bestOpenListIndex = -1;
  float bestOpenDistance = MAX_FLOAT;
  for( int i = 0; i < openList.size(); i++ ){
    int thisIndex = openList.get(i);
    if( graph[thisIndex].distance <= bestOpenDistance ){
      bestOpenDistance = graph[thisIndex].distance;
      bestOpenListIndex = i;
    }
  }
  
  // set this vertex to current and remove from the open list
  currentIndex = openList.get(bestOpenListIndex);
  openList.remove(bestOpenListIndex);

  Vertex currentVertex = graph[currentIndex];
  float currentVertexDistance = currentVertex.distance; 

  // add this distance into the final values
  distances.append(currentVertexDistance);
  
  // get all open neighbors of this vertex  
  IntList currentVertexNeighbors = currentVertex.getOpenNeighbours();
  
  for( int i = 0; i < currentVertexNeighbors.size(); i++ ){
    int neighborIndex          = currentVertexNeighbors.get(i);
    Vertex neighborVertex      = graph[ neighborIndex ];
    float  neighborDistanceOld = neighborVertex.distance;
    float  neighborDistanceNew = currentVertexDistance + DISTANCE_COST + ( HILL_COST * abs( currentVertex.altitude - neighborVertex.altitude ) );
    if( neighborDistanceNew < neighborDistanceOld ){
      graph[ neighborIndex ].edge = currentIndex;
      graph[ neighborIndex ].distance = neighborDistanceNew;
    }
  }
}

void draw() {

  // stop if everything is checked
  if( currentIndex == -1 ){
    println("Done");
    noLoop();
  }
  
  // draw the maze
  background(0);
  for( int thisVertex = 0; thisVertex < W * H; thisVertex++ ){
    graph[thisVertex].show();
  }


  // save this frame if recording is set
  if( RECORD ){
    saveFrame("output/frame-####.png");
  }


  // keep running until the stack is empty
  if( openList.size() > 0 ){
    update();
    println( distances.min(), distances.max() );
    dMin = distances.min();
    dMax = distances.max();
  }else{
    currentIndex = -1;
  }

}
