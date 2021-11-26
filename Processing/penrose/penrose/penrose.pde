/*
** Penrose Tiling for ceiling light fixture
 */

// Penrose P3 - Rhombus - Tiling
// See https://en.wikipedia.org/wiki/Penrose_tiling#Rhombus_tiling_(P3)
//
class PenroseP3TileGenerator {
  final int LITTLE_T_ANGLES[] = {36, 144, 36, 144}; // The "thin" rhombus tile
  final int BIG_T_ANGLES[] = {72, 108, 72, 108};    // The "thick" rhombus tile
  final PShape little_t_shape;
  final PShape big_t_shape;
  final float side; // lenght of one side of the rhombus.

  PenroseP3TileGenerator(float _side) {
    this.side = _side;
    this.little_t_shape = make_tile(LITTLE_T_ANGLES);
    this.big_t_shape = make_tile(BIG_T_ANGLES);
  }

  PShape makeLittleTile() {
    return make_tile(LITTLE_T_ANGLES);
  }

  PShape makeBigTile() {
    return make_tile(BIG_T_ANGLES);
  }

  private PShape make_tile(int[] angles) {
    PShape p = createShape();
    p.beginShape();
    float x = 0, y = 0;
    float aprev = 0;
    for (int a : angles) {
      p.vertex(x, y);
      x += side*cos(radians(aprev));
      y += side*sin(radians(aprev));
      aprev += a;
    }
    assert(aprev == 360);
    p.endShape(CLOSE);
    return p;
  }
};

void settings() {
  size(1000, 1000);
}

// These are installed in setup
PenroseP3TileGenerator p3gen = null;
PShape bigTile = null;
PShape littleTile = null;

void setup() {
  p3gen = new PenroseP3TileGenerator(100);
  bigTile = p3gen.makeBigTile();
  littleTile = p3gen.makeLittleTile();
  
  shape(bigTile);
  translate(200, 200);
  shape(littleTile);
  noLoop();
}
