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
    fill(150);
    ellipse(xc, yc, dia, dia);
  }
}

class Sheep{
  float xc;
  float yc; // center
  float dia;
  
  Sheep(float xc, float yc) {
    this(xc, yc, 5.0);
  }


  Sheep (float xc, float yc, float dia) {
    this.xc = xc;
    this.yc = yc;
    this.dia = dia;
  }

  void render() {
    fill(255);
    ellipse(xc, yc, dia, dia);
  }
}
