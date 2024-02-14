// Rulers for printing and then sticking on machinery //<>//
// Rulers are printed horizontally for maximum accuracy when printing
// This means print in portrait mode on most printers.
// History:
//  Jan 13, 2024 - JMJ - created
//
import processing.svg.*;


final float SVG_DPI = 96; // this comes from the CSS Specification.
final float FONT_SIZE = 16;
// These are in inches...
final float PAGE_WIDTH = 8.5;
final float PAGE_HEIGHT = 11.0;
final float EDGE_OFFSET = 0.25; // from edge to start of RULER
final float RULER_WIDTH = 1.0;
final boolean TO_SCREEN =true; // true == just display to screen; false == just save to SVG file "output.svg"
final boolean DRAW_TEXT = true;

// These are in pixels ...
final int CANVAS_WIDTH = (int) (SVG_DPI * PAGE_WIDTH);
final int CANVAS_HEIGHT = (int) (SVG_DPI * PAGE_HEIGHT);

final int TEXT_COLOR = color(0, 0, 0); // black
final int CUTS_COLOR = color(0, 0, 0); // black


PGraphics svg = null;

void settings() {
  size(CANVAS_WIDTH, CANVAS_HEIGHT);
}

void setup() {

  if (TO_SCREEN) {
    svg = createGraphics(CANVAS_WIDTH, CANVAS_HEIGHT);
  } else {
    String fn = String.format("rulers.svg");
    println("Output file: " + fn);
    svg = createGraphics(CANVAS_WIDTH, CANVAS_HEIGHT, SVG, fn);
  }
}

void draw() {
  noLoop();
  svg.beginDraw();
  PFont myFont = createFont("Helvetica", FONT_SIZE);
  svg.textFont(myFont);
  svg.textAlign(LEFT, TOP);

  // Units are inch ...
  float xOr, yOr;
  xOr = EDGE_OFFSET;
  yOr = EDGE_OFFSET + RULER_WIDTH/2;
  float len = 7.49;
  // Two rulers, counting up
  drawRuler(svg, xOr, yOr, len, 0, 1);
  drawRuler(svg, xOr, yOr + 2.0, len, 0, 1);
  
  // Two rulers, counting down
  drawRuler(svg, xOr, yOr+4.0, len, 8, -1);
  drawRuler(svg, xOr, yOr+6.0, len, 8, -1);

  svg.endDraw();

  if (TO_SCREEN) {
    set(0, 0, svg);
  }
  svg.dispose();
}

void drawRuler(PGraphics pg, float xOr, float yOr, float len, int digit_start, int digit_step) {
  styleText(pg);
  styleLines(pg);

  // In inches
  float max_tick_height = 0.75;
  float tick_heights[] = {max_tick_height, 0.6, 0.35, 0.18};
  float tick_gaps[] = {1.0, 0.5, 0.25, 0.125};

  // We extend the horizontal lines left and right by 0.25 inch in each direction
  // This is to help with alignment - we can crop a vertical strip of paper on each end and have these lines
  // extend to the edge
  float extra_x = 0.25; 
  // Horizontal line through the center
  pg.line(pix(xOr - extra_x), pix(yOr), pix(xOr + len + extra_x), pix(yOr));
  
  // Top and bottom alighment lines
  float alighment_y_offset = max_tick_height * 0.55;
  float yOr1 = yOr - alighment_y_offset;
  float yOr2 = yOr + alighment_y_offset;
  pg.line(pix(xOr - extra_x), pix(yOr1), pix(xOr + len + extra_x), pix(yOr1));
  pg.line(pix(xOr - extra_x), pix(yOr2), pix(xOr + len + extra_x), pix(yOr2));

  // Draw the vertical ticks
  for (int i=0; i < tick_heights.length; i++) {
    drawTicks(pg, xOr, yOr, len, tick_heights[i], tick_gaps[i]);
  }

  // Draw the labels
  drawDigits(pg, xOr, yOr, len, max_tick_height * 0.9, tick_gaps[0], digit_start, digit_step);
}

void drawTicks(PGraphics pg, float xOr, float yOr, float len, float height, float gap) {
  float xOff = xOr;
  float xMax = xOr + len;
  float yOff = yOr - height/2;
  while (xOff <= xMax) {
    pg.line(pix(xOff), pix(yOff), pix(xOff), pix(yOff + height));
    xOff += gap;
  }
}

void drawDigits(PGraphics pg, float xOr, float yOr, float len, float height, float gap, int digit_start, int digit_step) {
  float xOff = xOr;
  float xMax = xOr + len;
  float yOff = yOr - height/2;
  int n = digit_start;
  while (xOff <= xMax) {
    String label = " " + n;
    if (n == digit_start) {
      label += " in";
    }
    drawText(pg, label, xOff, yOff);
    xOff += gap;
    n += digit_step; // can be -ve
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
