// Makes a key of artists for the circles
// project.
// Directions: fill in the 2D array with names of people
// on the grid.
//
import processing.pdf.*;
final int PPI = 72; // PDFs are saved at 72DPI
final float BORDER_FRAC = 0.05; // Border thickness as a fraction of width.
final float   ELLIPSE_SHRINK = 0.9; // How much to shrink each ellipse.
final String FILENAME = "circles_key.PDF";

void settings() {
  size(PPI*11, PPI*7, PDF, FILENAME);
}

void setup() {
  noLoop();
  background(255);
  drawKey();
  println("Done.Key saved to " + FILENAME);
  exit();
}


void drawKey() {
  String [][] names = {
    //*** PUT 2D ARRAY OF NAMES HERE ***
  };
  // Find max number of columns
  int ncols = 0;
  for (String[] row : names) {
    ncols = max(ncols, row.length);
  }
  int nrows = names.length;
  final float xoff = width*BORDER_FRAC;
  final float yoff = height*BORDER_FRAC;
  final float dx = (width-2*xoff)/ncols;
  final float dy = dx; // For space-filling ellipse use: (height-2*yoff)/nrows;

  textSize(14);
  textAlign(CENTER, CENTER);
  strokeWeight(2);

  for (int i = 0; i < nrows; i++) {
    String[] row = names[i];
    for (int j = 0; j < row.length; j++) {
      float x = xoff + dx/2 + j*dx;
      float y = yoff + dy/2 + i*dy;
      fill(255);
      ellipse(x, y, dx*ELLIPSE_SHRINK, dy*ELLIPSE_SHRINK);
      fill(0);
      text(row[j], x, y);
    }
  }
}
