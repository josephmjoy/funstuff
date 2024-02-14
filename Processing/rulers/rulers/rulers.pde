// Rulers for printing and then sticking on machinery //<>//
// Rulers are printed horizontally for maximum accuracy when printing
// This means print in portrait mode on most printers.
// History:
//  Jan 13, 2024 - JMJ - created
//
import processing.svg.*;


final float SVG_DPI = 96; // this comes from the CSS Specification.
final float FONT_SIZE = 32;
// These are in inches...
final float MAX_RULER_LENGTH = 8;
final float MAX_RULER_WIDTH = 1;
final float EDGE_OFFSET = 0.25; // from edge to start of RULER

final boolean TO_SCREEN =true; // true == just display to screen; false == just save to SVG file "output.svg"
final boolean DRAW_TEXT = true;

// These are in pixels ...
final int CANVAS_WIDTH = (int) (SVG_DPI * (EDGE_OFFSET + MAX_RULER_LENGTH));
final int CANVAS_HEIGHT = (int) (SVG_DPI * (EDGE_OFFSET + MAX_RULER_WIDTH));

final int TEXT_COLOR = color(0, 0, 0); // black
final int CUTS_COLOR = color(0, 0, 0); // black
enum Direction {FORWARD, REVERSE};

PGraphics svg = null;

void settings() {
  size(CANVAS_WIDTH, CANVAS_HEIGHT);
}

void setup() {

  if (TO_SCREEN) {
    svg = createGraphics(CANVAS_WIDTH, CANVAS_HEIGHT);

  } else {
    String txt = DRAW_TEXT ? "" : "-NT";
    String fn = String.format("ruler-%s.svg",  txt);
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
  float len = 5.0;
  int start_number = 1;
  // -|-|=
  drawRuler(svg, xOr, yOr, len, start_number, Direction.FORWARD);



  svg.endDraw();

  if (TO_SCREEN) {
    set(0, 0, svg);
  }
  svg.dispose();
}

void drawRuler(PGraphics pg, float xOr, float yOr, float len, int start_number, Direction dir) {
  styleText(pg);
  styleLines(pg);
  
  // In inches
  float tick_heights[] = {0.75, 0.6, 0.3, 0.2};
  float tick_gaps[] = {1.0, 0.5, 0.25, 0.125};
  
  // Horizontal line
  pg.line(pix(xOr), pix(yOr), pix(xOr+len), pix(yOr));
  
  // Vertical ticks
  for (int i=0; i < tick_heights.length; i++) {
    draw_ticks(pg, xOr, yOr, len, tick_heights[i], tick_gap[i]);
  }
}

void drawTicks(PGraphics pg, float xOr, float yOr, float len, float height, float gap) {
  float xOff = xOr;
  float xMax = xOr + len;
  float yOff = yOr;
  while (xOff <= xMax) {
    pg.line(pix(xOff), pix(yOff), pix(xOff), pix(yOff + height));
    xOff += gap;
  }
}
  
void styleText(PGraphics pg) {
  pg.fill(TEXT_COLOR);
}

void styleLines(PGraphics pg) {
  pg.noFill();
  pg.stroke(CUTS_COLOR); // Red == cut
  pg.strokeWeight(1);
}


/** Convert inches to pix */
float pix(float in) {
  return in * SVG_DPI;
}


void drawText(PGraphics pg, String text, float x, float y) {
  pg.text(text, pix(x), pix(y));
}
