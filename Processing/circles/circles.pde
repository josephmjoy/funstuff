import processing.pdf.*;

// CIRCLES - a pattern of lihter circles on a dark background.

// These dimensions are all in inches

final float FRAME_H = 16; //14;//24;//16; // Inside height of frame
final float FRAME_W = 27; // 26;//16;//24; // Inside width of frame
final float FRAME_THICK = 1; // Thickness of frame
final float MAT_W = 1;  // Width of vertical strips of mat
final float MAT_H = MAT_W; // Height of horizontal strips of mat
final float DIA = 2.5; // Circle dia (circle spacing is calculated)
final float EXTRA_SPACE_W = 0.6; // extra space around borders of patterns

// For hex: NW = 5; NH = 9;
final int NW = 9;// 8; //5;//8;
final int NH = 5; //9;//5;
final float PPI = 70; // Pixels per inch when rendering image.
final float pic_w = FRAME_W - 2*MAT_W; // width (inches) of visible part of picture (portion inside mat)
final float pic_h = FRAME_H - 2*MAT_H; // height (inches) of visible part of picture
final int pic_wpx = (int) (pic_w*PPI); // width of above in pix
final int pic_hpx  = (int) (pic_h*PPI);// ""

// Colors
// Some from https://rgbcolorcode.com/
final color MAPLE = color(231, 185, 131);


color RED = color(255, 100, 100);
color YELLOW = color(255, 255, 100);
color ORANGE = color(255, 165, 0);
color CREAM = color(255, 253, 208);
color DARK_OLIVE = color(85, 107, 47);
color CHOCOLATE = color(128, 42, 0);
color OXFORD_BLUE = color(0, 33, 71);
color BLACK = color(0);
color WHITE = color(255);

final color WALL_COLOR = CREAM;
final color FRAME_COLOR = MAPLE;
final color MAT_COLOR = WHITE;
final color BACKDROP_COLOR = OXFORD_BLUE;


PImage picture; // Contains the visible part of picture.
float XO, YO; // offsets from window corner

void setup() {
  //size(2000, 1000);
  fullScreen();
  //size(850, 1400);
  //size(1400, 850, PDF, "output.pdf");
  XO = (width - (FRAME_W + 2*FRAME_THICK)*PPI)/2;
  YO = (height - (FRAME_H + 2*FRAME_THICK)*PPI)/2;
  noLoop();
  randomSeed(0); // so we generate the same random painting each time.
  PImage mask = circles_mask(); // the circles pattern - just white circles on black background
  PImage painting = random_painting(); // rectangular random painting
  picture = make_picture(painting, mask); // circles painting!
}


void draw() {
  draw_background();
  image(picture, XO + (FRAME_THICK + MAT_W)*PPI, YO+ (FRAME_THICK + MAT_H)*PPI);
  save("output.JPEG");
  //exit();
}

// Mask image - multiple disks on black background.
// (Blue channel interpreted as alpha channel.)
PImage circles_mask() {
  PGraphics pg = createGraphics(pic_wpx, pic_hpx);
  pg.beginDraw();
  pg.fill(0, 0, 255);
  //rect_grid(pg, NW, NH, 0.3);
  hex_circles(pg, NW, NH);
  pg.endDraw();
  PImage mask = new PImage(pg.width, pg.height);
  mask.set(0, 0, pg);
  pg.dispose();
  return mask;
}

// A random rectangular painting, composed of 
// parts of circles of different colors.
PImage random_painting() {
  color[] all_primary = {RED, YELLOW, ORANGE, CREAM};
  color[] all_accents = {DARK_OLIVE, CHOCOLATE, BLACK};
  PGraphics pg = createGraphics(pic_wpx, pic_hpx);
  pg.beginDraw();
  pg.fill(CREAM); // base color
  pg.rect(0, 0, pic_wpx, pic_hpx);

  // Primary colors random shapes with larger dia
  random_paint(pg, 1000, pic_hpx/5, all_primary);

  // Accents -  smaller, from accents palette.
  random_paint(pg, 100, pic_hpx/40, all_accents);

  pg.endDraw();
  PImage painting = new PImage(pg.width, pg.height);
  painting.set(0, 0, pg);
  pg.dispose();
  return painting;
}


// Draw {n} random circles, max radius {r}, randomly picking from {colors}.
void random_paint(PGraphics pg, int n, double rMax, color[] colors) {
  for (int i = 0; i < n; i++) {
    int c = colors[(int) random(colors.length)];
    float x = random(pic_wpx);
    float y = random(pic_hpx);
    float r = random((float)rMax);
    boolean outline = random(1)> 0.5;
    boolean rect = random(1) > 0.5;
    if (outline) {
      pg.stroke(1);
    } else {
      pg.noStroke();
    }
    pg.fill(c);
    if (rect) {
      pg.rect(x, y, r, r);
    } else {
      pg.ellipse(x, y, r, r);
    }
  }
}

// Composes the rectangular painting and the mask,
// generating a set of circular pictures.
PImage make_picture(PImage painting, PImage mask) {
  PImage pic = new PImage(painting.width, painting.height); 
  pic.set(0, 0, painting);
  pic.mask(mask); // Only circles are painted.
  return pic;
}


// Draw a rectangular grid of circles
void rect_grid(PGraphics pg, int nw, int nh, float space) {
  double gap = calc_gap(pic_w, DIA, nw); // space between circles - horizontal
  double dx = DIA + gap;
  double dy = dx;
  double x0 = DIA/2 + gap; // starting offsets...
  double start_y_gap = (pic_h - (dy*(nh-1) + DIA))/2;
  double y0 = DIA/2 + start_y_gap;
  
  double normal = x0; // DIA/2+space;
  double normaly = y0;
  double addon = dx; //DIA+space;
  draw_circle(pg, DIA/2+space, DIA/2+space);
  for (int i = 1; i<=nh; i++) {
    for (int j = 1; j<=nw; j++) {
      draw_circle(pg, normal + (addon*(j-1)), normaly + (addon*(i-1)));
    }
  }
}
// Draw rows of circles arranged on a hexagonal grid
// Initial and last rows are one less.
void hex_circles(PGraphics pg, int nw, int nh) {
  double gap = calc_gap(pic_w- 2*EXTRA_SPACE_W, DIA, nw); // space between circles - horizontal
  double dx = DIA + gap;
  double dy = hex_row_dist(dx); // virtical distance is Sin(60) times horizontal for hex(triangle) grid.
  double x0 = EXTRA_SPACE_W + DIA/2 + gap; // starting offsets...
  double start_y_gap = (pic_h - (dy*(nh-1) + DIA))/2;
  double y0 = DIA/2 + start_y_gap;
  for (int j = 0; j < nh; j++) {
    double xOff = 0;
    int nw1 = nw;
    // we offset every other row, and also reduce the count of circles in that row...
    if (j%2 == 0) {
      xOff = dx/2;
      nw1 = nw - 1;
    }   
    draw_row(pg, x0 + xOff, y0, dx, nw1);
    y0 += dy;
  }
}


void draw_background() {
  // Render "wall"
  background(WALL_COLOR);

  float xOff = XO;
  float yOff = YO;

  // Render frame (actually the whole rectangle)
  fill(FRAME_COLOR);
  rect(xOff, yOff, (FRAME_W + 2*FRAME_THICK)*PPI, (FRAME_H + 2*FRAME_THICK)*PPI);

  // Render the mat (whole rectangle)
  xOff += FRAME_THICK*PPI;
  yOff += FRAME_THICK*PPI;

  fill(MAT_COLOR);
  rect(xOff, yOff, FRAME_W*PPI, FRAME_H*PPI); // including mat

  // Render the background for the circles
  fill(BACKDROP_COLOR);
  xOff += MAT_W*PPI;
  yOff += MAT_H*PPI;
  rect(xOff, yOff, pic_wpx, pic_hpx); // internal black part
}


// Draw circle mask
void draw_circle(PGraphics pg, double x, double y) {
  double px = x*PPI ;//+ XO + MAT_W*PPI;
  double py = y*PPI ;//+ YO + MAT_H*PPI;
  pg.fill(0, 0, 255); // Just blue channel used for mask.
  pg.ellipse((float)px, (float)py, DIA*PPI, DIA*PPI);
}

// Draw hexagonal mask
void draw_hexagon(PGraphics pg, double x, double y) {
  double px = x*PPI ;//+ XO + MAT_W*PPI;
  double py = y*PPI ;//+ YO + MAT_H*PPI;
  pg.fill(0, 0, 255); // Just blue channel used for mask.
  polygon(pg, (float)px, (float)py, DIA*PPI/2*1.1, 6); // 1.1 (trial-and-error) to make it comparable with circle
}

// Gap between {n} circles of diameter {dia}
// evenly spaced across width {span} - with space on
// both ends.
double calc_gap(double span, double dia, int n) {
  return (span - n*dia) / (n + 1);
}

// Vertical distance between centers of rows given horizontal distance between
// circle centers in hexagonal grid.
double hex_row_dist(double center_dist) {
  return center_dist * Math.sqrt(3.0)/2; // center_dist * sin(60)
}

// Draw {n} circles, centers starting at {(dx, yc)} and proceeding horizontally by {dx}.
void draw_row(PGraphics pg, double xc, double yc, double dx, int n) {
  for (int i = 0; i<n; i++) {
    if (random(1) < 0.5) {
      draw_circle(pg, xc + dx*i, yc);
    } else {
      draw_hexagon(pg, xc + dx*i, yc);
    }
  }
  // draw_circle(pg, xc, yc);
}

// (from processing example https://processing.org/examples/regularpolygon.html)
void polygon(PGraphics pg, float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  float offset = PI/6;
  pg.beginShape();
  for (float a = offset; a < TWO_PI+offset; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    pg.vertex(sx, sy);
  }
  pg.endShape(CLOSE);
}
