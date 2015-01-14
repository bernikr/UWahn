
float dy = 174.5;
int[] dxs = {148, 399, 648};
PImage[] dp = new PImage[4];
int dstatus = 0;
boolean dopen = false;
int dnextmillis = millis();

void dloadImg() {
  dp[0] = loadImage("door-1.png");
  dp[1] = loadImage("door-2.png");
  dp[2] = loadImage("door-3.png");
  dp[3] = loadImage("door-4.png");
}

void ddraw() {
  if(dopen && dstatus != 3 && dnextmillis < millis()){
    dstatus++;
    dnextmillis = millis() + 100;
  }else if(!dopen && dstatus != 0 && dnextmillis < millis()){
    dstatus--;
    dnextmillis = millis() + 100;
  }
  for (int i = 0; i < dxs.length; i++) {
    nimage(dp[dstatus], getX(dxs[i]), getY(dy)+noiseoff);
  }
}

