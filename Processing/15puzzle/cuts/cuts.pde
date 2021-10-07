import processing.svg.*; //<>//
PGraphics svg = null;
enum Corner {
  NE, NW, SE, SW
};

void settings() {
  size(1000, 1000);
}

void setup() {
  svg = createGraphics(800, 800, SVG, "output.svg");
  //svg = createGraphics(800, 800);
}

void draw() {
  noLoop();
  svg.beginDraw();
  svg.background(255);

  float xOr = 50, yOr = 50;
  float xSize = 500, ySize = 500;
  float r = 20;
  
  svg.noFill();
  svg.stroke(255, 0, 0); // Red == cut
  svg.rect(xOr, yOr, xSize, ySize);
  drawCorner(svg, xOr + xSize, yOr, r, Corner.NE);
  drawCorner(svg, xOr, yOr, r, Corner.NW);
  drawCorner(svg, xOr + xSize, yOr + ySize, r, Corner.SE);
  drawCorner(svg, xOr, yOr + ySize, r, Corner.SW);
  
  // Now text:
  PFont myFont = createFont("Cooper Black", 32);
  svg.textFont(myFont);
  svg.fill(0);
  svg.text("23", xOr+xSize/2, yOr+ySize/2+2);
  
  svg.endDraw();
  
  //set(10, 10, svg);
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
    cx += r;
    cy += r;
    break;
  case SE:
    start = 0;
    cx -= r;
    cy -= r;
    break;
  case SW:
    start = PI/2;
    cx += r;
    cy -= r;
    break;
  }
  end = start + PI/2;
  pg.arc(cx, cy, 2*r, 2*r, start, end);
}
