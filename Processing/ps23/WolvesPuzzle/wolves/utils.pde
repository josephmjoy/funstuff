


float denom(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  return (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
}

float t_param(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float denom) {
  float t_num =  (x1 - x3) * (y3 - y4)  - (y1 - y3) * (x3 - x4);
  return t_num/denom;
}

float u_param(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float denom) {
  float u_num =  (x1 - x3) * (y1 - y2)  - (y1 - y3) * (x1 - x2);
  return u_num/denom;
}

/// Returns true iff barrier {b} blocks line of sight between {w} and {s}
boolean blocks(Barrier b, Wolf w, Sheep s) {
  float dx = b.len/2 * cos(b.angle);
  float dy = b.len/2 * sin(b.angle);

  // Barier line segment coordinates
  float x1 = b.xc - dx;
  float y1 = b.yc - dy;
  float x2 = b.xc + dx;
  float y2 = b.yc + dy;

  // Sheep to wolf segment
  float x3 = s.xc;
  float y3 = s.yc;
  float x4 = w.xc;
  float y4 = w.yc;

  // https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
  float denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

  // If denom is too close to zero it means the lines are almost parallel.
  // We treat this as non-blocking.
  if (Math.abs(denom) < 1.0E-5) {
    System.out.println("parallel lines");
    return false; // ************************************ EARLY RETURN ****************
  }

  float t = ((x1 - x3) * (y3 - y4)  - (y1 - y3) * (x3 - x4))/denom;
  float u = ((x1 - x3) * (y1 - y2)  - (y1 - y3) * (x1 - x2))/denom;
  boolean intersects = t >= 0.0 && t <= 1.0 && u >= 0.0 && u <= 1.0;
  return intersects;
}



void renderGameState(GameState state) {
  for (Barrier b : state.barriers) {
    b.render();
    //System.out.println(b.xc);
  }

  for (Wolf w : state.wolves) {
    w.render();
    //System.out.println(w.xc);
  }

  for (Sheep s : state.sheep) {
    s.render();
    //System.out.println(s.xc);
  }
  
  if (false) {
    renderBarrierIDs(state);
  }
}

void renderInteraction(GameState state, Sheep s) {
  int visibleWolves = calculateVisibleWolves(state, s, true);
  if (visibleWolves == 0) {
    s.render(true);
  }
}

// Renders the interactions between sheep and wolves
// and colors safe sheep
void renderInteractions(GameState state) {
  for (Sheep s : state.sheep) {
    renderInteraction(state, s);
  }
}




// Returns the count of wolves that can see this sheep
// if {render} is true it will render a visualization of sight paths
int calculateVisibleWolves(GameState state, Sheep s, boolean render) {
  int visible_count = 0; // Wolves that can see this sheep
  for (Wolf w : state.wolves) {
    boolean visible = true;
    for (Barrier b : state.barriers) {
      if (blocks(b, w, s)) {
        visible = false;
        break;
      }
    }

    if (render) {
      color c = visible? color(255, 0, 0) : color(0, 255, 0);
      stroke(c);
      strokeWeight(1);
      line(s.xc, s.yc, w.xc, w.yc);
    }

    if (visible) {
      visible_count++;  // OUCH - this wolf can see this sheep
    }
  }
  return visible_count;
}

// Saves the state to the specified file under the current directory
void saveState(GameState state, String fileName) {
  try {
    PrintWriter writer = new PrintWriter(sketchPath() + File.separator + fileName, "UTF-8");

    writer.println("// State saved on " + java.time.LocalDateTime.now());


    // Write out code to initialize barriers
    writer.println("Barrier[] g_savedBarriers = {");
    for (Barrier b : state.barriers) {
      //   new Barrier(400, 400, 150.0, PI/4, 2.0),
      writer.format("    new Barrier(%f, %f, %f, %f, %f),\n", b.xc, b.yc, b.len, b.angle, b.thickness);
    }
    writer.println("};");

    // Write out code to initialize sheep
    writer.println("\n\nSheep[] g_savedSheep = {");
    for (Sheep s : state.sheep) {
      //   new Sheep('A', 30, 30),
      writer.format("   new Sheep('%c', %f, %f),\n", s.c, s.xc, s.yc);
    }
    writer.println("};");

    // Write out code to initialize wolves
    writer.println("\n\nWolf[] g_savedWolves = {");
    for (Wolf w : state.wolves) {
      //  new Wolf(100, 600),
      writer.format("   new Wolf(%f, %f),\n", w.xc, w.yc);
    }
    writer.println("};");

    writer.close();
  }
  catch (IOException e) {
    println("Error attemptiong to write to file " + fileName);
  }
}


// Try to reposition the specied sheep so that exactly {visibleWolfCount} can see it.
// Return true if successful
boolean repositionSheep(GameState state, Sheep s, int visibleWolfCount, int nTries) {
  for (int i = 0; i < nTries; i++) {
    state.randomizeSheep(s);
    if (calculateVisibleWolves(state, s, false) == visibleWolfCount) return true; // *********** EARLY RETURN ************
  }
  return false;
}


// Renders IDs next to wolves and barriers so we can identify them during puzzle tweaking
void renderBarrierIDs(GameState state) {
  fill(0);
  for (int i = 0; i < state.barriers.length; i++) {
    Barrier b = state.barriers[i];
    text(""+i, b.xc - 15, b.yc - 20);
  }
}
