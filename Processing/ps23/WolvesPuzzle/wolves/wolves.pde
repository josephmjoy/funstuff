//
//   Wolf Herding: Puzzle involving wolves and sheep.
//


void settings() {
  size(DISPLAY_WIDTH, DISPLAY_HEIGHT);
}

GameState g_gameState = new GameState(10, "ABCDEFGHIJKLMN", 4);
// Wether to render the puzzle+answer or just the puzzle
boolean g_renderAnswer = true;

// Tracks if a solution has been found
boolean g_solutionFound = false;

// Request to stop re-rendering
boolean g_stopRendering = false;

void setup() {
  //randomSeed(g_randomSeed);
  //frameRate(1);
  //g_gameState.randomize();
  g_gameState.barriers = g_savedBarriers;
  g_gameState.wolves = g_savedWolves;
}


void draw() {

  if (g_stopRendering) {
    return; // ***************************** EARLY RETURN *****************************
  }


  background(255);
  renderGameState(g_gameState);

  if (g_renderAnswer) {
    calculateSafeCount(g_gameState, true);
  }

  if (g_solutionFound) {
    g_stopRendering = true;
    println("Rendering STOPPED");
  } else {
    // We'll keep trying to find a solution
    int MAX_TRIES = 1;
    for (int i = 0; i < MAX_TRIES; i++) {
      g_gameState.randomizeSheep();
      //g_gameState.randomizeWolves();
      //g_gameState.randomizeBorders();
      int safe_count = calculateSafeCount(g_gameState, g_renderAnswer);
      if (safe_count == 5) {
        g_solutionFound = true;
        break;
        //saveState(g_gameState, "saved_state.pde");
      }
    }
  }
}

void mousePressed() {
  System.out.println(String.format("new Sheep('X', %d, %d),", mouseX, mouseY));
}

// P: render puzzle.
// A: Render answer
// S: save screen
// R: Re-solve puzzle
void keyPressed() {
  switch(key) {
  case 'p':
    println("Render only puzzle.");
    g_renderAnswer = false;
    g_stopRendering = false;
    break;
  case 'a':
    println("A: Render puzzle and answer.");
    g_renderAnswer = true;
    g_stopRendering = false;
    break;
  case 'r':
    println("R: Resolve puzzle.");
    g_solutionFound = false;
    g_stopRendering = false;
    break;
  default:
    break;
  }
}
