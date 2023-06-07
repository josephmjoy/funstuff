


float denom(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  return (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
}

float t_param(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float denom) {
  float t_num =  (x1 - x3) * (y3 - y4)  - (y1 - y3) * (x3 - x4);
  return t_num/denom;
}

float u_param(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float denom) {
  float u_num =  (x1 - x3) * (y1 - y2)  - (y1 - y3) * (x1 - x2);
  return u_num/denom;
}

/// Returns true iff barrier {b} blocks line of sight between {w} and {s}
boolean blocks(Barrier b, Wolf w, Sheep s) {
  float dx = b.len/2 * cos(b.angle);
  float dy = b.len/2 * sin(b.angle);
  
  // Barier line segment coordinates
  float x1 = b.xc - dx;
  float y1 = b.yc - dy;
  float x2 = b.xc + dx;
  float y2 = b.yc + dy;

  // Sheep to wolf segment
  float x3 = s.xc;
  float y3 = s.yc;
  float x4 = w.xc;
  float y4 = w.yc;

  // https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
  float denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
  
  // If denom is too close to zero it means the lines are almost parallel.
  // We treat this as non-blocking.
  if (Math.abs(denom) < 1.0E-5) {
    System.out.println("parallel lines");
    return false; // ************************************ EARLY RETURN ****************
  }
  
  float t = ((x1 - x3) * (y3 - y4)  - (y1 - y3) * (x3 - x4))/denom;
  float u = ((x1 - x3) * (y1 - y2)  - (y1 - y3) * (x1 - x2))/denom;
  boolean intersects = t >= 0.0 && t <= 1.0 && u >= 0.0 && u <= 1.0;
  return intersects;

}