import processing.svg.*; //<>//

final float SVG_DPI = 96; // this comes from the CSS Specification.
final float FONT_SIZE = 32;
// These are in inches...
final float TILE_SIZE = 2.5;
final float TILE_CORNER_RADIUS = 0.125;
final float EDGE_OFFSET = 0.125; // from edge to closest cut

final int NUM_ROWS = 5;
final int NUM_COLS = 7;

final boolean TO_SCREEN =false; // true == just display to screen; false == just save to SVG file "output.svg"
final boolean DRAW_TEXT = true;

// These are in pixels ...
final int CANVAS_WIDTH = (int) (SVG_DPI * (2*EDGE_OFFSET + TILE_SIZE * NUM_COLS));
final int CANVAS_HEIGHT = (int) (SVG_DPI * (2*EDGE_OFFSET + TILE_SIZE * NUM_ROWS));

final int TEXT_COLOR = color(0, 0, 255); // blue
final int CUTS_COLOR = color(255, 0, 0); // red


PGraphics svg = null;
enum Corner {
  NE, NW, SE, SW
};

void settings() {
  size(CANVAS_WIDTH, CANVAS_HEIGHT);
}

void setup() {

  if (TO_SCREEN) {
    svg = createGraphics(CANVAS_WIDTH, CANVAS_HEIGHT);

  } else {
    String txt = DRAW_TEXT ? "" : "-NT";
    String fn = String.format("tiles-%dx%d%s.svg", NUM_COLS, NUM_ROWS, txt);
    println("Output file: " + fn);
    svg = createGraphics(CANVAS_WIDTH, CANVAS_HEIGHT, SVG, fn);
  }
}

void draw() {
  noLoop();
  svg.beginDraw();
  PFont myFont = createFont("Cooper Black", FONT_SIZE);
  svg.textFont(myFont);
  svg.textAlign(RIGHT);

  // Units are inch ...
  float xOr, yOr;
  xOr = yOr = EDGE_OFFSET;

  int tileNo = 1;
  final int TILE_COUNT = NUM_ROWS * NUM_COLS;
  for (int row = 0; row <NUM_ROWS; row++) {
    for (int col = 0; col < NUM_COLS; col++) {
      boolean topmost = row==0;
      boolean leftmost = col==0;
      float xOff = col * TILE_SIZE;
      float yOff = row * TILE_SIZE;
      String label = (tileNo == TILE_COUNT) ? "" : tileNo + "";
      drawTile(svg, xOr + xOff, yOr + yOff, leftmost, topmost, label); // leftmost, topmost
      tileNo++;
    }
  }


  svg.endDraw();

  if (TO_SCREEN) {
    set(0, 0, svg);
  }
  svg.dispose();
}

void styleText(PGraphics pg) {
  pg.fill(TEXT_COLOR);
}

void styleCuts(PGraphics pg) {
  pg.noFill();
  pg.stroke(CUTS_COLOR); // Red == cut
  pg.strokeWeight(1);
}


/** Convert inches to pix */
float pix(float in) {
  return in * SVG_DPI;
}

void drawTile(PGraphics pg, float xOr, float yOr, boolean leftmost, boolean topmost, String label) {
  drawTile(pg, xOr, yOr, TILE_SIZE, TILE_SIZE, TILE_CORNER_RADIUS, leftmost, topmost, label);
}

void drawTile(PGraphics svg, float xOr, float yOr, float xSize, float ySize, float r, boolean leftmost, boolean topmost, String label )
{

  styleCuts(svg);
  //svg.rect(xOr, yOr, xSize, ySize);
  if (topmost) {
    drawSide(svg, xOr, yOr, xOr+xSize, yOr, r); // N
  }
  if (leftmost) {
    drawSide(svg, xOr, yOr, xOr, yOr + ySize, r); // W
  }

  drawSide(svg, xOr + xSize, yOr, xOr+xSize, yOr + ySize, r); // E
  drawSide(svg, xOr, yOr + ySize, xOr+xSize, yOr + ySize, r); // S

  drawCorner(svg, xOr + xSize, yOr, r, Corner.NE);
  drawCorner(svg, xOr, yOr, r, Corner.NW);
  drawCorner(svg, xOr + xSize, yOr + ySize, r, Corner.SE);
  drawCorner(svg, xOr, yOr + ySize, r, Corner.SW);

  // Now text:
  if (DRAW_TEXT) {
    styleText(svg);
    float textFrac = FONT_SIZE/SVG_DPI;
    drawText(svg, label, xOr+xSize - 0.25*textFrac, yOr + textFrac);
  }
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
