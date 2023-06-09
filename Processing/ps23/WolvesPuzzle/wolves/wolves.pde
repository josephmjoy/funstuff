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
boolean g_solutionFound = true;

// Request to stop re-rendering
boolean g_stopRendering = false;

void setup() {
  //randomSeed(g_randomSeed);
  //frameRate(1);
  //g_gameState.randomize();
  g_gameState.sheep = g_savedSheep;
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
      int safe_count = calculateSafeCount(g_gameState, g_renderAnswer);
      if (safe_count == 5) {
        g_solutionFound = true;
        break;
      }
    }
  }
}

void mousePressed() {
  System.out.println(String.format("new Sheep('X', %d, %d),", mouseX, mouseY));
}

// p: render puzzle.
// a: Render answer
// s: save screen
// r: Re-solve puzzle
void keyPressed() {
  boolean oldVal = g_stopRendering;
  g_stopRendering = false;
  switch(key) {

  case 'b':
    println("b: Randomize borders.");
    g_gameState.randomizeBorders();
    break;

  case 'w':
    println("w: Randomize wolves.");
    g_gameState.randomizeWolves();
    break;

  case 'p':
    println("p: Render only puzzle.");
    g_renderAnswer = false;
    break;

  case 'a':
    println("a: Render puzzle and answer.");
    g_renderAnswer = true;
    break;

  case 'r':
    println("r: Resolve puzzle.");
    g_solutionFound = false;
    break;

  case 's':
    String imageFile = g_renderAnswer ? "puzzle-answer.png" : "puzzle.png";
    println("s: Save screen to file " + imageFile);
    save(imageFile);
    g_stopRendering = oldVal;
    break;

  case 'F':
    String dataFile = "saved_state_NEW.pde";
    println("s: Save date to file " + dataFile);
    g_stopRendering = oldVal;
    saveState(g_gameState, dataFile);
    break;

  default:
    g_stopRendering= oldVal;
    break;
  }
}
