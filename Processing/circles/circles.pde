// CIRCLES - a pattern of lihter circles on a dark background.


final  int pic_w = 1700;
final int pic_h = pic_w/2;
float mat_w  = 50;
int xo = 20, yo = 20;

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
  pg.ellipse(pic_w/2, pic_h/2, 300, 300);
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

// Render the dark background and mat
void draw_background() {
  fill(255,255,255);
  rect(xo, yo, pic_w+2*mat_w, pic_h+2*mat_w);
  fill(0);
  rect(xo+mat_w, yo+mat_w, pic_w, pic_h);
}
