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
  //g_gameState.randomize();
  g_gameState.barriers = g_savedBarriers;
  g_gameState.sheep = g_savedSheep;
  g_gameState.wolves = g_savedWolves;
}


void draw() {
  background(255);
  renderGameState(g_gameState);
  int safe_count = renderIntersections(g_gameState);
  noLoop();
  if (safe_count == 5) {
    //saveState(g_gameState, "saved_state.pde");
    noLoop();
  } else {
    g_gameState.randomize();
  }
}

void mousePressed() {
  System.out.println(String.format("new Sheep('X', %d, %d),", mouseX, mouseY));
}
