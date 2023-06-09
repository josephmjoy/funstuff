final int g_randomSeed  = 0; // for repeatability


// Display size
final int DISPLAY_WIDTH = 800;
final int DISPLAY_HEIGHT = 800;

// Coordinate bounds
final float MIN_X  = 0.1*DISPLAY_WIDTH;
final float MAX_X = 0.9*DISPLAY_WIDTH;
final float MIN_Y = 0.1*DISPLAY_HEIGHT;
final float MAX_Y = 0.9*DISPLAY_HEIGHT;

// Barriers
final float MIN_ANGLE = -PI/2;
final float MAX_ANGLE = PI/2;
final float MIN_BORDER_LEN = 70;
final float MAX_BORDER_LEN = 70;

// SHEEP location: how close to barriers
final float SHEEP_BORDER_DISTANCE_FACTOR = 0.75;

Barrier[] g_barriers = {
  new Barrier(300, 300),
  new Barrier(400, 400, 150.0, PI/4, 2.0),
  new Barrier(500, 500)
};


Wolf[] g_wolves = {
  new Wolf(100, 600),
  new Wolf(200, 650),
  new Wolf(300, 700)
};


Sheep[] g_sheep10 = {
  new Sheep('A', 30, 30),
  new Sheep('B', 300, 100),
  new Sheep('C', 600, 200)
};


Sheep[] g_sheep0 = {
  new Sheep('X', 142, 37),
  new Sheep('X', 215, 41),
  new Sheep('X', 373, 50),
  new Sheep('X', 510, 130),
  new Sheep('X', 722, 355),
  new Sheep('X', 435, 230),
  new Sheep('X', 181, 297),
  new Sheep('X', 320, 349),
  new Sheep('X', 655, 593),
  new Sheep('X', 621, 449),
  new Sheep('X', 288, 480),
  new Sheep('X', 149, 385),
  new Sheep('X', 37, 377),
  new Sheep('X', 42, 530),
  new Sheep('X', 543, 758),
  new Sheep('X', 730, 761),
  new Sheep('X', 704, 636),
  new Sheep('X', 536, 622),
  new Sheep('X', 262, 417),
};

Sheep[] g_sheep = g_sheep0;
