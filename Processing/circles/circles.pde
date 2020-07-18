import processing.pdf.*;

// CIRCLES - a pattern of lihter circles on a dark background.

// These dimensions are all in inches
final float FRAME_H = 16; // Inside height of frame
final float FRAME_W = 24; // Inside width of frame
final float MAT_W = 0.9;  // Width of vertical strips of mat
final float MAT_H = MAT_W; // Height of horizontal strips of mat
final float DIA = 2.4; // Circle dia (circle spacing is calculated)
final int NW = 8;
final int NH = 5;
float XO = 20, YO = 20;// offsets from window corner
final float PPI = 50; // Pixels per inch when rendering image.
final float pic_w = FRAME_W - 2*MAT_W; // width (inches) of visible part of picture (portion inside mat)
final float pic_h = FRAME_H - 2*MAT_H; // height (inches) of visible part of picture
final int pic_wpx = (int) (pic_w*PPI); // width of above in pix
final int pic_hpx  = (int) (pic_h*PPI);// ""

PImage picture; // Contains the visible part of picture.

void setup() {
  size(1400, 850);
  //size(1400, 850, PDF, "output.pdf");
  noLoop();
  PImage mask = circles_mask(); // the circles pattern - just white circles on black background
  PImage painting = random_painting(); // rectangular random painting
  picture = make_picture(painting, mask); // circles painting!
}


void draw() {
  draw_background();
  image(picture, XO+MAT_W*PPI, YO+MAT_H*PPI);
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
  color red = color(255, 100, 100);
  color yellow = color(255, 255, 100);
  color orange = color(255, 165, 0);
  color cream = color(255, 253, 208);
  color[] all = {red, yellow, orange, cream};
  PGraphics pg = createGraphics(pic_wpx, pic_hpx);
  pg.beginDraw();
  pg.fill(cream); // base color
  pg.rect(0, 0, pic_wpx, pic_hpx);

  // Random circles
  for (int i = 0; i < 1000; i++) {
    int c = all[(int) random(all.length)];
    float x = random(pic_wpx);
    float y = random(pic_hpx);
    float r = random(pic_hpx/5);
    boolean outline = random(1)> 0.5;
    if (outline) {
      pg.stroke(1);
    } else {
      pg.noStroke();
    }
    pg.fill(c);
    pg.ellipse(x, y, r, r);
  }

  pg.endDraw();
  PImage painting = new PImage(pg.width, pg.height);
  painting.set(0, 0, pg);
  pg.dispose();
  return painting;
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
  float normal = DIA/2+space;
  float addon = DIA+space;
  draw_circle(pg, DIA/2+space, DIA/2+space);
  for (int i = 1; i<=nh; i++) {
    for (int j = 1; j<=nw; j++) {
      draw_circle(pg, normal + (addon*(j-1)), normal + (addon*(i-1)));
    }
  }
}

// Draw rows of circles arranged on a hexagonal grid
// Initial and last rows are one less.
void hex_circles(PGraphics pg, int nw, int nh) {
  double gap = calc_gap(pic_w, DIA, nw); // space between circles - horizontal
  double dx = DIA + gap;
  double dy = hex_row_dist(dx); // virtical distance is Sin(60) times horizontal for hex(triangle) grid.
  double x0 = DIA/2 + gap; // starting offsets...
  double y0 = DIA/2 + gap;
  for (int j = 0; j < nh; j++) {
    double xOff = 0;
    int nw1 = nw;
    // we offset every other row, and also reduce the count of circles in that row...
    if (j%2 == 1) {
       xOff = dx/2;
       nw1 = nw - 1;
    }   
    draw_row(pg, x0 + xOff, y0, dx, nw1);
    y0 += dy;
  }
}


void draw_background() {
  fill(255, 255, 255);
  rect(XO, XO, FRAME_W*PPI, FRAME_H*PPI); // including mat
  fill(0);
  rect(XO+MAT_W*PPI, YO+MAT_H*PPI, pic_wpx, pic_hpx); // internal black part
}


// Draw circle mask
void draw_circle(PGraphics pg, double x, double y) {
  double px = x*PPI ;//+ XO + MAT_W*PPI;
  double py = y*PPI ;//+ YO + MAT_H*PPI;
  pg.fill(0, 0, 255); // Just blue channel used for mask.
  pg.ellipse((float)px, (float)py, DIA*PPI, DIA*PPI);
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
    draw_circle(pg, xc + dx*i, yc);
  }
  // draw_circle(pg, xc, yc);
}
