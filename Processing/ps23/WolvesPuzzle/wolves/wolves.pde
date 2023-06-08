//
//   Wolf Herding: Puzzle involving wolves and sheep.
//


void settings() {
  size(DISPLAY_WIDTH, DISPLAY_HEIGHT);
}
GameState g_gameState = new GameState(1, 1, 1);

void setup() {
  //randomSeed(g_randomSeed);
  g_gameState.randomize();
}


void draw() {
  renderGameState(g_gameState);
  renderIntersections(g_gameState);
  noLoop();
}

void mousePressed() {
  System.out.println(String.format("new Sheep('X', %d, %d),", mouseX, mouseY));
  
}
