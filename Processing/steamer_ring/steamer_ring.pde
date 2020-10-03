// Makes a ring template for the steamer project.
// Directions: print, verify dimensions, and stick onto thin gage galvanized steel..
//
import processing.pdf.*;
final int PPI = 72; // PDFs are saved at 72DPI
final String FILENAME = "steamer_ring.PDF";
final boolean TO_SCREEN = false; // just display to the screen, not generate PDF file.

void settings() {
  if (TO_SCREEN) { 
    size((int)(PPI*10.5), PPI*8);
  } else {
    size((int)(PPI*10.5), PPI*8, PDF, FILENAME);
  }
}

void setup() {
  noLoop();
  background(255);
  drawRing();
  println("Done.Key saved to " + FILENAME);
  if (!TO_SCREEN) {
    exit();
  }
}


void drawRing() {
  final float CYLINDER_CIRC = 19; // INCH
  final float EXTRA_DIA = 0.1; // Expand just a bit.
  final float RING_WIDTH = 1.5; // INCH
  float id = PPI*(EXTRA_DIA + CYLINDER_CIRC/PI);
  float od = id+ 2*RING_WIDTH*PPI;
  float cx = width/2;
  float cy = height/2;
  fill(220);
  ellipse(cx, cy, od, od);
  fill(255);
  ellipse(cx, cy, id, id);
  crossHairs(cx, cy);
  fill(0);
  String label = String.format("ID=%.2fin OD=%.2fin C=%.2fin", id/PPI, od/PPI, id*PI/PPI);
  text(label, cx+10, cy-10);
}

void crossHairs(float cx, float cy) {
  line(0, cy, width, cy);
  line(cx, 0, cx, height);
}
