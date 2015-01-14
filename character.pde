class character {
  SpriteSet sprite;    //Bildersatz
  float x, y, ox, oy, ax, ay;  //Koordinaten
  float vx, vy;        //geschwindigkeit für stoß
  int dir;             //Ausrichtung (0-3 im uhrzeiger sinn, beginn oben)
  float cspeed = 1.5;  //Bewegungsgeschwindigkeit
  character[] others;  //andere npcs
  int id;              //id des npcs im array (0 bei spielern)
  int movedir;         //Bewegungsrichtung (anderes format als ausrichtung 0-3 Up, down, left, right)
  int status, animationframe =0; //aktueller animationsstatus
  int lastanimationmillis; //zeit des letzten frame übergangs
  Seat seat;
  int collcount = 0;
  int cooldown = 0;

  
  character(SpriteSet look, float nx, float ny, int ndir, int nid, character[] no, int ns) {
    sprite = look;
    x = nx;
    y = ny;
    ox = nx;
    oy = ny;
    ax = nx;
    ay = ny;
    dir = ndir;
    id = nid;
    others = no;
    status = ns;
  }

  void move(int i) {
    //Bewegen
    switch(i) {
    case 0:
      movea(0);
      dir = 0;
      break;
    case 1:
      movea(2);
      dir = 2;
      break;
    case 2:
      movea(3);
      dir = 3;
      break;
    case 3:
      movea(1);
      dir = 1;
      break;
    }
    movea(dir);
  }

  void movea(int i) {
    if (cooldown < millis()){
      if (status == 5){
        startAnimation(4);
        seat.occupied = false;
        seat.cooldown = millis()+700;
      }
      switch(i) {
        case 0:
          y-=cspeed;
          break;
        case 2:
          y+=cspeed;
          break;
        case 3:
          x-=cspeed;
          break;
        case 1:
          x+=cspeed;
          break;
      }
    
      if (status == 0) startAnimation(1); //Move animation

    }else{
      dir= seat.dir;
    }
  }

  //Movement in random direction
  void randmove() {
    if (random(1)>0.9) {
      movedir = (int)random(4);
    }
    if (status != 5) move(movedir);
  }

  //show character
  void show() {
    //geschwindigkeits berechnungen:
    x += vx;
    y += vy;
    vx *= 0.7;
    vy *= 0.7;

    if (status ==1 && x == ax && y == ay) status = 0; //reset walking animation
    ax = x; 
    ay = y;
    //play animation
    if (lastanimationmillis + sprite.animationtime[status] < millis()) {
      lastanimationmillis = millis();
      animationframe += 1;
    }
    //animation loop
    if (sprite.animations[status].length -1 < animationframe) switch(status) { 
    case 0:
      animationframe = 0;
      break;
    case 1:
      animationframe = 0;
      break;
    case 2:
      animationframe = 0;
      status = 0;
      break;
    case 3:
      animationframe = 0;
      status = 5;
      break;
    case 4:
      animationframe = 0;
      status = 0;
      break;
    case 5:
      animationframe = 0;
      break;
    case 6:
      animationframe = 0;
      status = 0;
      break;
    }
    nimage(rotImg(sprite.get(sprite.animations[status][animationframe]), dir), x, y+noiseoff); //show
  }

  //Collisions
  void collide() {
    boolean coll = false;
    
    //with other NPCs
    float dx, dy, distance, angle;
    for (int i = id+1; i < others.length; i++) {
      dx = others[i].x - x;
      dy = others[i].y - y;
      distance = sqrt(dx*dx + dy*dy);
      angle = atan2(dy, dx);
      if (distance < minDist*2 && status != 5) { 
        coll = true;
        x += sin(angle)*(minDist*2-distance);
        y += cos(angle)*(minDist*2-distance);
      }
    }
    if (id!=0) {
      dx = p1.x - x;
      dy = p1.y - y;
      distance = sqrt(dx*dx + dy*dy);
      angle = atan2(dy, dx);
      if (distance < minDist*2 && status != 5) { 
        coll = true;
        x += sin(angle)*(minDist*2-distance);
        y += cos(angle)*(minDist*2-distance);
      }
      dx = p2.x - x;
      dy = p2.y - y;
      distance = sqrt(dx*dx + dy*dy);
      angle = atan2(dy, dx);
      if (distance < minDist*2 && status != 5) { 
        coll = true;
        x += sin(angle)*(minDist*2-distance);
        y += cos(angle)*(minDist*2-distance);
      }
    }

    //with walls
    if (!instation && !intrain(x, y, minDist) && !gameover) {
      x = ox;
      y = oy;
      startAnimation(6);
    }
    for( int i = 0; i < walls.length; i++){
      if(between(x,getX(walls[i]+12),getX(walls[i]-12)) && !between(y,getY(71),getY(105)) && y < getY(176)){
        x = ox;
        y = oy;
        startAnimation(6);
      }
    }
    if(!between(x,(vwidth-level.width)/2+minDist,(vwidth+level.width)/2-minDist) && between(y,vheight*vertoff+level.height/2+minDist,vheight*vertoff-level.height/2+minDist)){
      x = ox;
      y = oy;
      startAnimation(6);
    }
    if(y < getY(minDist) || y > vheight-minDist){
      x = ox;
      y = oy;
      startAnimation(6);   
    }
    
    if(x < -vwidth/2 || x > vwidth*1.5){
      x = ox;
      y = oy;
      startAnimation(6);  
    }
    
    if(between(y, getY(165), getY(185))){
      boolean door = true;
      for(int i = 0; i < dxs.length; i++){
        if(between(x, getX(dxs[i]+15), getX(dxs[i]-15))) door = false;
      }
      if(door){
        x = ox;
        y = oy; 
        startAnimation(6); 
      }else if(!instation){
        y -= 1;
      }
    }
    
    //with seats
    for (int i = 0; i < seats.length; i++) {
      dx = seats[i].getX() - ((seats[i].dir == 1) ? x + 10 : x - 10);
      dy = seats[i].getY() - y;
      distance = sqrt(dx*dx + dy*dy);
      angle = atan2(dy, dx);
      if (distance < minDist*1.5 && status != 5 && !seats[i].occupied && seats[i].cooldown < millis()) { 
        coll = true;
        x = seats[i].getX();
        y = seats[i].getY();
        dir = seats[i].dir;
        seat = seats[i];
        seat.occupied = true;
        cooldown = millis() + 500;
        startAnimation(3);
      }
    }
    
    if(coll){
      collcount++;
    }else{
      collcount = 0;
    }
    
    //move when on the outside of the train
    if(!intrain(x,y,-minDist/2)){
      x += speed;
    }
    
    oy=y; ox=x; // alte koordinaten speichern
  }

  void startAnimation(int animation) {
    lastanimationmillis = millis();
    status = animation;
    animationframe = 0;
  }

  void leaveSeat() {
    startAnimation(4);
    seat.occupied = false;
    seat.cooldown = millis() + 700;
    x = (seat.dir == 1) ? x + minDist*2 : x - minDist*2;
  }
}

