Graph g;

void settings() {
  // Size based on width, height, and square size
  int wi = S + (2 * S * W);
  int hi = S + (2 * S * H);
  size( wi, hi, P2D );
}

void setup() {
  randomSeed(MAZE_SEED);
  g = new Graph( W*H );
  g.stackTopIndex = START;
  
  // Initialize graph and edge arrays
  for( int x = 0; x < W; x++ ){
    for( int y = 0; y < H; y++ ){
      int nodeIndex = y*W+x;
      float altitude = random(0,1);
      g.nodes[nodeIndex] = new Vertex(x,y,altitude);
      if( y > 0 )   g.nodes[nodeIndex].addNeighbor((y-1) * W + x); // north
      if( x < W-1 ) g.nodes[nodeIndex].addNeighbor(y * W + (x+1)); // east
      if( y < H-1 ) g.nodes[nodeIndex].addNeighbor((y+1) * W + x); // south
      if( x > 0 )   g.nodes[nodeIndex].addNeighbor(y * W + (x-1)); // west
      g.stack.append(nodeIndex);
    }
  }

  // Start with the first point
  g.nodes[g.stackTopIndex].edgeIndex = g.stackTopIndex;
  g.nodes[g.stackTopIndex].distance  = 0;

  background(0);
}


void draw() {
  g.update();
  g.render(1);

  // save this frame if recording is set
  if( RECORD ) saveFrame("output/frame-####.png");
  
  // stop if everything is checked
  if( g.stack.size() == 0 ) noLoop();
}