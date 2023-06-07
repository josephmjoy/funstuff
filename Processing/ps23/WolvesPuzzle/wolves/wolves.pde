//
//   Wolf Herding: Puzzle involving wolves and sheep.
//


void settings() {
  size(800, 800);
}

void renderBarriers() {
  for (Barrier b : g_barriers) {
    b.render();
    //System.out.println(b.xc);
  }
}

void renderWolves() {
  for (Wolf w : g_wolves) {
    w.render();
    //System.out.println(w.xc);
  }
}

void renderSheep() {
  for (Sheep s : g_sheep) {
    s.render();
    //System.out.println(s.xc);
  }
}

void renderIntersections() {
  for (Sheep s : g_sheep) {
    for (Wolf w : g_wolves) {
      line(s.xc, s.yc, w.xc, w.yc);
      for (Barrier b : g_barriers) {
        //
      }
    }
  }
}

void setup() {
}
void draw() {
  renderBarriers();
  renderWolves();
  renderSheep();
  renderIntersections();
  noLoop();
}
