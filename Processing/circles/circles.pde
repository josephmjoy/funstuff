// CIRCLES - a pattern of lihter circles on a dark background.
final float PPI = 50;
final float frame_h = 16; // 16 inches
final float frame_w = 24;
final float mat_w = 1.0;
final float mat_h = mat_w;
final float back_w = frame_w - 2*mat_w;
final float back_h = frame_h - 2*mat_h;
float xo = 10;// pix
float yo = 10;// pix
float d = 2.4;


final  int pic_w = 1700;
final int pic_h = pic_w/2;

PImage picture;

void setup() {
  size(2000, 1000);
  noLoop();
  PImage mask = circles_mask(); // the circles pattern - just white circles on black background
  PImage painting = random_painting(); // rectangular random painting
  picture = make_picture(painting, mask); // circles painting!
}


void draw() {
  draw_background();
  image(picture, xo+mat_w, yo+mat_w);
}

// Mask image - multiple disks on black background.
// (Blue channel interpreted as alpha channel.)
PImage circles_mask() {
  PGraphics pg = createGraphics(pic_w, pic_h);
  pg.beginDraw();
  pg.fill(0, 0, 255);
  // For now, just a single disk!
  //pg.ellipse(pic_w/2, pic_h/2, 300, 300);
  rect_grid(pg, 8, 5, 0.3);
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
  PGraphics pg = createGraphics(pic_w, pic_h);
  pg.beginDraw();
  pg.fill(cream); // base color
  pg.rect(0, 0, pic_w, pic_h);
  
  // Random circles
  for (int i = 0; i < 1000; i++) {
    int c = all[(int) random(all.length)];
    float x = random(pic_w);
    float y = random(pic_h);
    float r = random(pic_h/5);
    boolean outline = random(1)> 0.5;
    if(outline) {
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
   float normal = d/2+space;
   float addon = d+space;
  draw_circle(pg, d/2+space, d/2+space);
  for(int i = 1; i<=nh; i++){
    for(int j = 1; j<=nw; j++){
      draw_circle(pg, normal + (addon*(j-1)), normal + (addon*(i-1)));
    }
  }
}


void draw_background() {

  fill(255, 255, 255);
  rect(xo, xo, frame_w*PPI, frame_h*PPI); // including mat
  fill(0);
  rect(xo+mat_w*PPI, yo+mat_h*PPI, back_w*PPI, back_h*PPI); // internal black part
}


// Draw circle mask
void draw_circle(PGraphics pg, float x, float y) {
  float px = x*PPI + xo + mat_w*PPI;
  float py = y*PPI + yo + mat_h*PPI;
  //pg.fill(255, 255*(float)Math.random(), 255*(float)Math.random());
  pg.fill(0, 0, 255); // Just blue channel used for mask.
  pg.ellipse(px, py, d*PPI, d*PPI);
}
