import processing.pdf.*;

// CIRCLES - a pattern of lihter circles on a dark background.

// These dimensions are all in inches

final float FRAME_H = 16; //16; //14;//24;//16; // Inside height of frame
final float FRAME_W = 24; //27; // 26;//16;//24; // Inside width of frame
final float FRAME_THICK = 1; // Thickness of frame
final float MAT_W = 0;  // Width of vertical strips of mat
final float MAT_H = MAT_W; // Height of horizontal strips of mat
final float DIA = 2.5; // Circle dia (circle spacing is calculated)
final float OUTSIDE_SPACE_W = 1; // space around borders of patterns, but inside the mat. If -ve, it is same as inside gap
final float VGAP_SCALE = 1.1; // Gap aspect ratio. 2.0 == vertical gap is twice horizontal gap.
final boolean HEX_GRID = false; // If false: rectangular grid; If true: hexagonal grid
final boolean MAKE_TEMPLATE = true; // Make a multipage PDF template doc.

final int HEX_NW = 9;
final int HEX_NH = 5;
final int RECT_NW = 8;
final int RECT_NH = 5;
final int NW = HEX_GRID ? HEX_NW : RECT_NW;
final int NH = HEX_GRID ? HEX_NH : RECT_NH;
final float PPI = 72; // Pixels per inch when rendering image.
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
final color BACKDROP_COLOR = BLACK;


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

  if (MAKE_TEMPLATE) {
    PImage template = make_template();
    multipage_write_image(template);
  }
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
  pg.fill(0, 0, 255); // Just blue channel used for mask.
  if (HEX_GRID) {
    hex_circles(pg, NW, NH);
  } else {
    rect_grid(pg, NW, NH);
  }

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


// Draw a rectangular grid of circles.
// Does NOT set fill and stroke colors or weights.
void rect_grid(PGraphics pg, int nw, int nh) {
  boolean auto_outside_space = OUTSIDE_SPACE_W < 0;
  double gap, start_gap;
  if (auto_outside_space) {
    gap = calc_gap(pic_w, DIA, nw, true); // space between circles - horizontal
    start_gap = gap;
  } else {
    gap = calc_gap(pic_w - 2*OUTSIDE_SPACE_W, DIA, nw, false); // space between circles - horizontal
    start_gap = OUTSIDE_SPACE_W;
  }

  double dx = DIA + gap;
  double x0 = DIA/2 + start_gap; // starting offsets...

  double dy = DIA + gap*VGAP_SCALE;
  double start_y_gap = (pic_h - (dy*(nh-1) + DIA))/2;
  double y0 = DIA/2 + start_y_gap;

  // Compute the percentage difference betwwen horizontal and vertical
  // outside (start) gaps, and the same with inside gaps.
  String pout = "";
  String pin = "";
  //Note: the checks avoid printing uselessly large percentages and div by zero
  if (Math.abs(start_gap) > 0.01) {
    pout = " (" + (int) (100*Math.abs((start_y_gap - start_gap)/start_gap)) + "%)";
  }
  if (Math.abs(gap) > 0.01) { 
    pin = " (" + (int) (100*Math.abs((gap - gap*VGAP_SCALE) / gap)) + "%)";
  }

  println(String.format("Outside gaps (x, y): %.2fin, %.2fin%s", start_gap, start_y_gap, pout));
  println(String.format(" Inside gaps (x, y): %.2fin, %.2fin%s", gap, gap*VGAP_SCALE, pin));


  //double normal = x0;
  //double normaly = y0;
  for (int i = 1; i<=nh; i++) { 
    for (int j = 1; j<=nw; j++) {
      draw_circle(pg, x0 + (dx*(j-1)), y0 + (dy*(i-1)));
    }
  }
}


// Draw rows of circles arranged on a hexagonal grid
// Initial and last rows are one less.
void hex_circles(PGraphics pg, int nw, int nh) {
  boolean auto_outside_space = OUTSIDE_SPACE_W < 0;
  double gap, start_gap;
  if (auto_outside_space) {
    gap = calc_gap(pic_w, DIA, nw, true); // space between circles - horizontal
    start_gap = gap;
  } else {
    gap = calc_gap(pic_w - 2*OUTSIDE_SPACE_W, DIA, nw, false); // space between circles - horizontal
    start_gap = OUTSIDE_SPACE_W;
  }
  double dx = DIA + gap;
  double dy = hex_row_dist(dx); // virtical distance is Sin(60) times horizontal for hex(triangle) grid.
  double x0 = DIA/2 + start_gap; // starting offsets...
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
  pg.ellipse((float)px, (float)py, DIA*PPI, DIA*PPI);
}

// Draw hexagonal mask
void draw_hexagon(PGraphics pg, double x, double y) {
  double px = x*PPI ;//+ XO + MAT_W*PPI;
  double py = y*PPI ;//+ YO + MAT_H*PPI;
  polygon(pg, (float)px, (float)py, DIA*PPI/2*1.1, 6); // 1.1 (trial-and-error) to make it comparable with circle
}

// Gap between {n} circles of diameter {dia}
// evenly spaced across width {span}.
// {outsideSpace} if true: include space on
// both ends.
double calc_gap(double span, double dia, int n, boolean outsideSpace) {
  int delta = outsideSpace ? 1 : -1;
  return (span - n*dia) / (n + delta);
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


// Make a positioning template.
PImage make_template() {
  PGraphics pg = createGraphics(pic_wpx, pic_hpx);
  pg.beginDraw();
  pg.background(255);
  if (HEX_GRID) {
    hex_circles(pg, NW, NH);
  } else {
    rect_grid(pg, NW, NH);
  }

  pg.endDraw();
  PImage img = new PImage(pg.width, pg.height);
  img.set(0, 0, pg);
  pg.dispose();
  return img;
}


// Tiles the image over multiple 81/2x11 pages, saved
// as a multi-page PDF doc that should be printed without scaling.
// They should be assembled by placing pages side-by-side- with zero
// overlap. There will be some printing lost because it's close to the 
// edge of the paper. Not a big deal. This way we do not need to try
// to carefully overlap pages.
// Output file is 'multipage.pdf'.
// Assumes PDF write ppi is 72.
void multipage_write_image(PImage source) {
  final float OUTPUT_PPI = 72;
  assert(abs(PPI-OUTPUT_PPI)<0.1); // they should be the same; we don't scale. IF we need to we can re-scale.
  PImage scaled_source = source; // scaled_source has a PPI of exactly OUTPUT_PPI, the PPI at which the PDF file is written.
  float page_width_in = 8.5;
  float page_height_in = 11;
  int page_width_pix = (int) (page_width_in * OUTPUT_PPI);
  int page_height_pix = (int) (page_height_in * OUTPUT_PPI);

  // Find out number of tiles needed. Note that the part for the last column (row)
  // will likely only fill a fraction of the page width (height)

  /*
  int nx = (int) (scaled_source.width / page_width_pix + 0.99);
   int ny = (int) (scaled_source.height / page_height_pix + 0.99);
   */

  PGraphicsPDF pdf = (PGraphicsPDF) createGraphics((int)page_width_pix, (int)page_height_pix, PDF, "multipage.pdf");
  pdf.beginDraw();
  pdf.textSize(32);
  int y_pixels_left = scaled_source.height;

  for (int row = 0; y_pixels_left > 0; row++, y_pixels_left -= page_height_pix) {   
    int x_pixels_left = scaled_source.width;
    int dy = min(y_pixels_left, page_height_pix);
    for (int col = 0; x_pixels_left > 0; col++, x_pixels_left -= page_width_pix) {
      if (row > 0 || col > 0) {
        pdf.nextPage();
      }
      assert(row * col < 10); // Don't want too many pages!
      int x = col * page_width_pix;
      int y = row * page_height_pix;
      int dx = min(x_pixels_left, page_width_pix);

      // Pick up part of the source image that goes on this PDF page
      PImage part = source.get(x, y, dx, dy);
      pdf.image(part, 0, 0);

      // Add the page label
      String pageCaption = String.format("(%d, %d)", row+1, col+1);
      pdf.fill(0);
      pdf.text(pageCaption, 0.5*OUTPUT_PPI, 1.0*OUTPUT_PPI);
    }
  }
  pdf.dispose();
  pdf.endDraw();
}
