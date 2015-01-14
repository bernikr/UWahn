class Player extends character {

  //Keys: Up, Down, Left, Right, Hit
  public char[] keys = new char[5];
  boolean[] pressed = new boolean[5];
  Player otherpl;
  int hitcooldown = 0;

  Player(SpriteSet look, float nx, float ny, int ndir, character[] no) {
    super(look, nx, ny, ndir, 0, no, 0);
  }


  void defineKeys(char[] nk) {
    keys = nk;
  }

  void pressed(int i) {
    pressed[i] = true;
  } 
  void released(int i) {
    pressed[i] = false;
  }

  void move() {
    if (pressed[0]) super.move(0);
    if (pressed[1]) super.move(1);
    if (pressed[2]) super.move(2);
    if (pressed[3]) super.move(3);
    if (pressed[4]) hit();
  }

  void collide() {
    float dx = otherpl.x - x;
    float dy = otherpl.y - y;
    float distance = sqrt(dx*dx + dy*dy);
    float angle = atan2(dy, dx);
    if (distance < minDist*2.2 && status != 5) { 
      x += sin(angle)*(minDist*2-distance);
      y += cos(angle)*(minDist*2-distance);
    }
    super.collide();
  }

  void hit() {
    if(hitcooldown < millis()){
      hitcooldown = millis() + 500;
      
      boolean push = false;
  
      float dx = otherpl.x - x;
      float dy = otherpl.y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float angle = atan2(dy, dx);
      if(cos(angle)+0.5 > abs(sin(angle)) && dir == 1) push = true;
      if(sin(angle)+0.5 > abs(cos(angle)) && dir == 2) push = true;
      if(-cos(angle)+0.5 > abs(sin(angle)) && dir == 3) push = true;
      if(-sin(angle)+0.5 > abs(cos(angle)) && dir == 0) push = true;
      if(push && distance < 35){
        
         switch(dir){
            case 0:
              otherpl.vy-=15;
              break;
            case 2:
              otherpl.vy+=15;
              break;
            case 3:
              otherpl.vx-=15;
              break;
            case 1:
              otherpl.vx+=15;
              break;
          }
        
        if( otherpl.status == 5){
          otherpl.startAnimation(4);
          otherpl.seat.occupied = false;
          otherpl.seat.cooldown = millis() + 700;
        }
      }
      
      for (int i = 0; i < others.length; i++){
        push = false;
        dx = others[i].x - x;
        dy = others[i].y - y;
        distance = sqrt(dx*dx + dy*dy);
        angle = atan2(dy, dx);
        if(cos(angle)+0.2 > abs(sin(angle)) && dir == 1) push = true;
        if(sin(angle)+0.2 > abs(cos(angle)) && dir == 2) push = true;
        if(-cos(angle)+0.2 > abs(sin(angle)) && dir == 3) push = true;
        if(-sin(angle)+0.2 > abs(cos(angle)) && dir == 0) push = true;
        if(push && distance < 35){
          if( others[i].status == 5){
            others[i].leaveSeat();
          }else switch(dir){
            case 0:
              others[i].vy-=10;
              break;
            case 2:
              others[i].vy+=10;
              break;
            case 3:
              others[i].vx-=10;
              break;
            case 1:
              others[i].vx+=10;
              break;
          }
        }
      }
      if(status == 5){
        seat.occupied = false;
        seat.cooldown = millis() + 700;
      }
      if(status != 2) startAnimation(2);
    }
  }
}

