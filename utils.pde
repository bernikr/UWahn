//render a picture on the default (train) layer
void nimage(PImage i, float x, float y){
  imageMode(CENTER);
  image(i, (x-scroll)*scale, y*scale, i.width*scale, i.height*scale);
}

//rotate a picture 90°
PImage rotImg(PImage o, int d){
  PImage n = o;
  for(int k = 0; k < d; k++){
    n = createImage(o.height, o.width, ARGB);
    o.loadPixels();
    n.loadPixels();
    int row, column;
    for(int i = 0; i < o.pixels.length; i++) {
      row = (i / o.width);
      column = (i % o.width);
      n.pixels[row*o.width+column] = o.pixels[(o.height-1)*o.width-(((row*o.width+column) % o.height)*o.width)+(row*o.width+column)/o.height];
    }
    n.updatePixels();
    o = n;
  }
  return n;
}

boolean between(float value, float v1, float v2){
  if(v1 < v2){
    float t = v1;
    v1 = v2;
    v2 = t;
  }
  boolean ret = (value < v1 && value > v2);
  return ret;
}

boolean intrain(float x, float y, float dist){
  boolean ret = between(x,(vwidth-level.width)/2+dist,(vwidth+level.width)/2-dist) && between(y,vheight*vertoff+level.height/2-dist,vheight*vertoff-level.height/2+dist);
  return ret;
}

float getX(float x) {
  return x + (vwidth-level.width)/2;
}

float getY(float y) {
  return y + vheight*vertoff-level.height/2;
}

void setAcc(int i){
  acc = i;
  acclastmillis = millis();
  if (i == 1){ 
    speed = 0.5;
    firsttrans = true;
  };
}
