class Seat {
  float x, y;
  int dir;
  boolean occupied = false;
  int cooldown = 0;
  
  Seat(float nx, float ny, int nd) {
    x = nx;
    y = ny;
    dir = nd;
  }

  float getX() {
    return x + (vwidth-level.width)/2;
  }

  float getY() {
    return y + vheight*vertoff-level.height/2;
  }
}

