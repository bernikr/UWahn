class SpriteSet{
  PImage[] p = new PImage[16];
  int[][] animations ={{0},{8,9,0,10,11,0},{1,2,3,4,5},{12},{12},{13},{14,15}};
  int[] animationtime = {1000, 70, 50, 150, 150, 1000, 150};
  
  SpriteSet(String pref){
    p[0] = rotImg(loadImage(pref+"-0.png"),2);
    p[1] = rotImg(loadImage(pref+"-h-1.png"),2);
    p[2] = rotImg(loadImage(pref+"-h-2.png"),2);
    p[3] = rotImg(loadImage(pref+"-h-3.png"),2);
    p[4] = rotImg(loadImage(pref+"-h-4.png"),2);
    p[5] = rotImg(loadImage(pref+"-h-5.png"),2);
    p[6] = rotImg(loadImage(pref+"-s-0.png"),2);
    p[7] = rotImg(loadImage(pref+"-s-1.png"),2);
    p[8] = rotImg(loadImage(pref+"-w-1.png"),2);
    p[9] = rotImg(loadImage(pref+"-w-2.png"),2);
    p[10] = rotImg(loadImage(pref+"-w-3.png"),2);
    p[11] = rotImg(loadImage(pref+"-w-4.png"),2);
    p[12] = rotImg(loadImage(pref+"-s-1.png"),2);
    p[13] = rotImg(loadImage(pref+"-s-0.png"),2);
    p[14] = rotImg(loadImage(pref+"-c-1.png"),2);
    p[15] = rotImg(loadImage(pref+"-c-2.png"),2);
  }
  
  PImage get(int i){
    return p[i];
  }
}
