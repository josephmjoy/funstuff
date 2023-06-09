//
//   Wolf Herding: Puzzle involving wolves and sheep.
//


void settings() {
  size(DISPLAY_WIDTH, DISPLAY_HEIGHT);
}
GameState g_gameState = new GameState(10, "ABCDEFGHIJKLMN", 4);

void setup() {
  //randomSeed(g_randomSeed);
  //frameRate(1);
  g_gameState.randomize();
  saveState(g_gameState, "saved_state.pde");
}


void draw() {
  background(255);
  renderGameState(g_gameState);
  int safe_count = renderIntersections(g_gameState);
  noLoop();
  if (safe_count == 5) {
    noLoop();
  } else {
    g_gameState.randomize();
  }
}

void mousePressed() {
  System.out.println(String.format("new Sheep('X', %d, %d),", mouseX, mouseY));
}
