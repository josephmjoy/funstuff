/// Returns true iff barrier {b} blocks line of sight between {w} and {s}
boolean blocks(Barrier b, Wolf w, Sheep s) {
  return true;
}


// https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
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
