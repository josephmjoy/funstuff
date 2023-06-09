//
//   Wolf Herding: Puzzle involving wolves and sheep.
//


void settings() {
  size(DISPLAY_WIDTH, DISPLAY_HEIGHT);
}

GameState g_gameState = new GameState(12, "ANSWERETTAAINSRH", 5);
// Wether to render the puzzle+answer or just the puzzle
boolean g_renderAnswer = true;

// Tracks if a solution has been found
boolean g_solutionFound = true;

// Request to stop re-rendering
boolean g_stopRendering = false;

// Number of safe sheep desired
int g_safeSheepNeeded = 6;

// Current safe sheep found
int g_curSafeSheepCount = 0;

// Current sheep index we are repositioning
int g_curSheepIndex = 0;

void setup() {
  randomSeed(g_randomSeed);
  //frameRate(1);
  boolean restore = true;
  if (restore) {
    g_gameState.sheep = g_savedSheep;
    g_gameState.barriers = g_savedBarriers;
    g_gameState.wolves = g_savedWolves;
  } else {
    g_gameState.randomizeBorders();
    g_gameState.randomizeWolves();
    g_gameState.randomizeSheep();
  }
}


void draw() {

  if (g_stopRendering) {
    return; // ***************************** EARLY RETURN *****************************
  }


  if (g_solutionFound) {
    g_stopRendering = true;
    println("Rendering STOPPED");
    background(255);
    renderGameState(g_gameState);
    if (g_renderAnswer) {
      renderInteractions(g_gameState);
    }
  } else {
    // We'll keep trying to find a solution

    //int g_safeSheepNeeded = 1;
    //int g_curSafeSheepCount = 0;
    int MAX_TRIES = 1000;
    int MIN_VISIBLE_COUNT_FOR_UNSAFE_SHEEP = 1;
    if (g_curSheepIndex < g_gameState.sheep.length) {
      Sheep s = g_gameState.sheep[g_curSheepIndex];
      boolean findMoreSafeSheep = g_curSafeSheepCount < g_safeSheepNeeded;
      int desiredVisibleWolfCount =  0;
      if (!findMoreSafeSheep) {
        // We've already found all the safe sheep. Now on to the unsafe sheep
        desiredVisibleWolfCount = MIN_VISIBLE_COUNT_FOR_UNSAFE_SHEEP;
      }
      boolean success = repositionSheep(g_gameState, s, desiredVisibleWolfCount, MAX_TRIES);
      if (success) {
        renderInteraction(g_gameState, s);
        if (findMoreSafeSheep) {
          g_curSafeSheepCount++;
        }
        g_curSheepIndex++; // move on to the next sheep
        if (g_curSheepIndex >= g_gameState.sheep.length) {
          g_solutionFound = true;  // We've positioned all the sheep successfully
        }
      }
    }


    /*
    int MAX_TRIES = 1;
     for (int i = 0; i < MAX_TRIES; i++) {
     g_gameState.randomizeSheep();
     int safe_count = calculateSafeCount(g_gameState, g_renderAnswer);
     if (safe_count == 5) {
     g_solutionFound = true;
     break;
     }
     }
     */
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
  boolean reRender = true;
  boolean restart = false;

  switch(key) {

  case 'b':
    println("b: Randomize borders.");
    g_gameState.randomizeBorders();
    restart = true;
    break;

  case 'w':
    println("w: Randomize wolves.");
    g_gameState.randomizeWolves();
    restart = true;
    break;

  case 'p':
    println("p: Render only puzzle.");
    g_renderAnswer = false;
    reRender = true;
    break;

  case 'a':
    println("a: Render puzzle and answer.");
    g_renderAnswer = true;
    reRender = true;
    break;

  case 'r':
    println("r: Re-solve puzzle.");
    g_solutionFound = false;
    restart = true;
    break;

  case 's':
    String imageFile = g_renderAnswer ? "puzzle-answer.png" : "puzzle.png";
    println("s: Save screen to file " + imageFile);
    save(imageFile);
    reRender = false;
    break;

  case 'F':
    String dataFile = "saved_state.pde";
    println("s: Save date to file " + dataFile);
    reRender = false;
    saveState(g_gameState, dataFile);
    break;

  default:
    reRender = false;
    break;
  }

  if (restart) {
    restart();
  }

  if (reRender) {
    g_stopRendering = false;
  }
}

// Puzzle has changed, so re-do sheep positioning
void restart() {
  // Tracks if a solution has been found
  g_solutionFound = false;
  g_stopRendering = false;
  g_curSafeSheepCount = 0;
  g_curSheepIndex = 0;

  background(255);
  renderGameState(g_gameState);
}
