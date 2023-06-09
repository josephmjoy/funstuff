class Barrier {
  float xc;
  float yc; // center of barrier
  float len;
  float angle; // angle in radians
  float thickness;


  Barrier(float xc, float yc) {
    this(xc, yc, 100.0, 0.0, 2.0);
  }


  Barrier(float xc, float yc, float len, float angle, float thickness) {
    this.xc = xc;
    this.yc = yc;
    this.len = len;
    this.angle = angle;
    this.thickness = thickness;
  }

  void render() {
    float dx = this.len/2 * cos(this.angle);
    float dy = this.len/2 * sin(this.angle);
    float x1 = this.xc - dx;
    float y1 = this.yc - dy;
    float x2 = this.xc + dx;
    float y2 = this.yc + dy;
    stroke(0);
    strokeWeight(this.thickness);
    line(x1, y1, x2, y2);
  }
}


class Wolf {
  float xc;
  float yc; // center
  float dia;

  Wolf(float xc, float yc) {
    this(xc, yc, 10.0);
  }


  Wolf (float xc, float yc, float dia) {
    this.xc = xc;
    this.yc = yc;
    this.dia = dia;
  }

  void render() {
    fill(0);
    ellipse(xc, yc, dia, dia);
  }
}

class Sheep {
  char c; // letter associated with this sheep
  float xc;
  float yc; // center
  float dia;

  Sheep(char c, float xc, float yc) {
    this(c, xc, yc, 10.0);
  }


  Sheep (char c, float xc, float yc, float dia) {
    this.c = c;
    this.xc = xc;
    this.yc = yc;
    this.dia = dia;
  }

  void render(boolean markSafe) {
    if (markSafe) {
      fill(0, 255, 0);
    } else {
      fill(255);
    }
    stroke(0);
    strokeWeight(1);
    ellipse(xc, yc, dia, dia);
    fill(0);
    text(this.c, this.xc - 5, this.yc - 10);
  }

  // Not visible by *any* wolf
  void render() {
    render(false);
  }
}

class GameState {
  Barrier[] barriers;
  Sheep[] sheep;
  Wolf[] wolves;

  GameState(int nBarriers, String sheepChars, int nWolves) {
    barriers = new Barrier[nBarriers];
    for (int i = 0; i < barriers.length; i++) {
      barriers[i] = new Barrier(MIN_X, MIN_Y);
    }

    sheep = new Sheep[sheepChars.length()];
    for (int i = 0; i < sheep.length; i++) {
      sheep[i] = new Sheep(sheepChars.charAt(i), MIN_X, MIN_Y);
    }

    wolves = new Wolf[nWolves];
    for (int i = 0; i < wolves.length; i++) {
      wolves[i] = new Wolf(MIN_X, MIN_Y);
    }
  }

  // Randomize the specific sheep (which may or may not be in the game state), keeping it close
  // to a randome border
  void randomizeSheep(Sheep s) {
    // Pick a random barrier and position near it.
    int i = int(random(this.barriers.length));
    Barrier b  = this.barriers[i];
    float max_delta = b.len * SHEEP_BORDER_DISTANCE_FACTOR;
    float dx = random(-max_delta, max_delta);
    float dy = random(-max_delta, max_delta);
    s.xc = constrain(b.xc+dx, MIN_X, MAX_X);
    s.yc = constrain(b.yc+dy, MIN_Y, MAX_Y);
  }

  // Randomizes the locations and (where applicable) orientations
  void randomizeBorders() {
    // We want to make sure borders do not extend outside the boundaries
    final float DELTA = MIN_BORDER_LEN/2;
    assert(MAX_X > DELTA);
    assert(MAX_Y > DELTA);

    for (Barrier b : this.barriers) {
      b.xc = random(MIN_X+DELTA, MAX_X-DELTA);
      b.yc = random(MIN_Y+DELTA, MAX_Y-DELTA);
      b.len = random(MIN_BORDER_LEN, MAX_BORDER_LEN);
      b.angle = random(MIN_ANGLE, MAX_ANGLE);
    }
  }

  void randomizeSheep() {
    for (Sheep s : this.sheep) {
      randomizeSheep(s);
    }
  }

  void randomizeWolves() {
    for (Wolf w : this.wolves) {
      w.xc = random(MIN_X, MAX_X);
      w.yc = random(MIN_Y, MAX_Y);
    }
  }
}
