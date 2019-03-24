// Configurables

// graph and sketch size
// 1080x1080: 2x2 @ 216px, 4x4 @ 120px, 7x7 @ 72px, 13x13 @ 40px, 22x22 @ 24px, 67x67 @ 8px
final int S = 8;
final int W = 67;
final int H = 67;

// output colors
final color HEAD_CLR  = color(255,0,0);
final color OPEN_CLR  = color(102);
final color FILL_CLR  = color(255);

// output flag, set to true to save out frames
final Boolean RECORD = false;

// starting node index
final int START = W * floor(H/2.0) + floor(W/2.0);

// tweakable values
final int   MAZE_SEED     = 42;    // seed for random functions
final float DISTANCE_COST = 0.2;   // cost of moving to a neighbor at the same altitude
final float HILL_COST     = 10.0;  // scaling factor for cost of altitude difference
