import processing.svg.*; //<>//
PGraphics svg = null;
enum Corner {
  NE, NW, SE, SW
};

void settings() {
  size(1000, 1000);
}

void setup() {
  //svg = createGraphics(300, 300, SVG, "output.svg");
  svg = createGraphics(800, 800);
}

void draw() {
  noLoop();
  svg.beginDraw();
  svg.background(255);
  svg.noFill();
  svg.line(50, 50, 250, 250);
  //svg.arc(100, 100, 50, 50, 0, PI);
  float xOr = 50, yOr = 50;
  float xSize = 500, ySize = 500;
  float r = 20;
  svg.rect(xOr, yOr, xSize, ySize);
  drawCorner(svg, xOr + xSize, yOr, r, Corner.NE);
  svg.endDraw();
  set(10, 10, svg);
  svg.dispose();
}

/**
 @param x, y - corner of the rectangle that is being rounded
 @param r - radius
 @param Corner - which corner
 NOTE: Assumes ellipseMode() is set to the default (CENTER).
 */
void drawCorner(PGraphics pg, float x, float y, float r, Corner c) {
  float start=0, end;
  float cx = x, cy=y;
  switch (c) {
  case NE:
    start = PI*3/2;
    cx -= r;
    cy += r;
    break;
  case NW:
    start = PI;
    break;
  case SE:
    start = PI/2;
    break;
  case SW:
    start = 0;
    break;
  }
  end = start + PI/2;
  pg.arc(cx, cy, 2*r, 2*r, start, end);
}
