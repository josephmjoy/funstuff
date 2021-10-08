import processing.svg.*; //<>//

final float SVG_DPI = 96; // this comes from the CSS Specification.
boolean toScreen = true;


PGraphics svg = null;
enum Corner {
  NE, NW, SE, SW
};

void settings() {
  size(1000, 1000);
}

void setup() {

  if (toScreen) {
    svg = createGraphics(800, 800);
  } else {
    svg = createGraphics(800, 800, SVG, "output.svg");
  }
}

void draw() {
  noLoop();
  svg.beginDraw();
  svg.background(255);
  PFont myFont = createFont("Cooper Black", 32);
  svg.textFont(myFont);

  // Units are inch ...
  float xOr, yOr;
  xOr = yOr = 0.5;
  float xSize, ySize;
  xSize = ySize = 2.5;
  float r = 0.125;

  styleCuts(svg);
  //svg.rect(xOr, yOr, xSize, ySize);
  drawSide(svg, xOr, yOr, xOr+xSize, yOr, r); // N
  drawSide(svg, xOr + xSize, yOr, xOr+xSize, yOr + ySize, r); // E
  drawSide(svg, xOr, yOr + ySize, xOr+xSize, yOr + ySize, r); // S
  drawSide(svg, xOr, yOr, xOr, yOr + ySize, r); // W
  drawCorner(svg, xOr + xSize, yOr, r, Corner.NE);
  drawCorner(svg, xOr, yOr, r, Corner.NW);
  drawCorner(svg, xOr + xSize, yOr + ySize, r, Corner.SE);
  drawCorner(svg, xOr, yOr + ySize, r, Corner.SW);

  // Now text:
  styleText(svg);
  drawText(svg, "23", xOr+xSize*0.8, yOr+ySize*0.12);

  svg.endDraw();

  if (toScreen) {
    set(10, 10, svg);
  }
  svg.dispose();
}

void styleText(PGraphics pg) {
  pg.fill(0);
}

void styleCuts(PGraphics pg) {
  pg.noFill();
  pg.stroke(255, 0, 0); // Red == cut
}


/** Convert inches to pix */
float pix(float in) {
  return in * SVG_DPI;
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
  pg.arc(pix(cx), pix(cy), pix(2*r), pix(2*r), start, end);
}

/**
 Draw the side from (x1, y1) to (x2, y2), but have a gap of width {r} at the start and end of the line, to make room for the rounded courners.
 */
void drawSide(PGraphics pg, float x1, float y1, float x2, float y2, float r) {
  float dx = x2 - x1;
  float dy = y2 - y1;
  float len = sqrt(dx*dx + dy*dy);
  float frac = r/len;
  // Note if the radious is > half the side then we don't draw a straight portion.
  if (frac < 0.5) {
    float x1p = lerp(x1, x2, frac);
    float y1p = lerp(y1, y2, frac);
    float x2p = lerp(x2, x1, frac);
    float y2p = lerp(y2, y1, frac);
    pg.line(pix(x1p), pix(y1p), pix(x2p), pix(y2p));
  }
}

void drawText(PGraphics pg, String text, float x, float y) {
  pg.text(text, pix(x), pix(y));
}
