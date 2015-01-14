//Startvariables
float speed = maxspeed;

//Variables
float scroll, nscroll;
float trackscroll;
float noisepos = 0;
float noiseoff;
boolean instation = false;
PImage background;
boolean showtrans = false;
float transscroll;
boolean firsttrans = true;
int acc = 0;
int acclastmillis;
String overlaytext = "";
int remauf = 0;
int remfahr = 0;
int sec;
boolean firstsetacc = true;
boolean startanimation = true;

void gamesetup() {

  //create seats
  for (int i = 0; i< seatx.length; i++) {
    for (int j = 0; j < seaty.length; j++) {
      seats[i*seaty.length+j] = new Seat(seatx[i], seaty[j], (i%2==0) ? 3 : 1);
    }
  }
  seats[40] = new Seat(38, 19, 1);
  seats[41] = new Seat(757, 19, 3);
  seats[42] = new Seat(38, 157, 1);
  seats[43] = new Seat(757, 157, 3);

  seatlist = new ArrayList<Seat>();
  for (int i = 0; i< seats.length; i++) {
    seatlist.add(seats[i]);
  }

  //create NPCs
  for ( int i = 0; i < charnum; i++) {
    int hotseatnum = (int)random(seatlist.size());
    Seat hotseat = seatlist.get(hotseatnum);
    seatlist.remove(hotseatnum);
    npcs[i] = new character(pl[(int)random(2)], hotseat.getX(), hotseat.getY(), hotseat.dir, i, npcs, 5);
    npcs[i].seat = hotseat;
    hotseat.occupied = true;
  }



  //Initiate Players
  p1 = new Player(pl[(int)random(2)], 50, vheight*vertoff, 1, npcs);
  p1.defineKeys(p1k);
  p2 = new Player(pl[(int)random(2)], vwidth-50, vheight*vertoff, 3, npcs);
  p2.defineKeys(p2k);

  p1.otherpl = p2;
  p2.otherpl = p1;
  
  gameover = false;
  overlaytext = "";
  
  sec = millis();
  remfahr = (int)random(10,20);
}

void gameloop() {

  if(sec + 1000 < millis()){
    if(instation){
      sec = millis();
      remauf--;
      if(!gameover) overlaytext = str(remauf);
      if(remauf == 0){
        overlaytext = "";
        instation = false;
        dopen = false;
        checkwin();
        remfahr = (int)random(10,20);
        firstsetacc = true;
        setAcc(1);
      }
    }else{
      sec = millis();
      remfahr--;
      if(remfahr == 0 && firstsetacc){
        setAcc(-1);
        firstsetacc = false;
      }
    }
  }
  
  if (acc == -1){
    if(acclastmillis + 100 < millis()){
      speed*=0.98;
      acclastmillis = millis();
    }
    
    if (speed < maxspeed*0.1){
      speed = 0;
      dopen = true;
      acc = 0;
      firsttrans = true;
      instation = true;
      remauf = (int)random(15,30);
      if(!gameover) overlaytext = str(remauf);
    }
  
    if (speed/maxspeed < 0.9 && firsttrans) {
        firsttrans = false;
        showtrans = true;
        transscroll = trackscroll-tracks.width*2;
    }
    
    if(!firsttrans && transscroll > tracks.width){
      background = station;
    }
     
    
    if(!firsttrans && transscroll > tracks.width*2){
      showtrans = false;
    }
  }
  
  if (acc == 1){
    if(acclastmillis + 100 < millis()){
      speed*=1.1;
      acclastmillis = millis();
    }
    
    if (speed > maxspeed*0.99){
      speed = maxspeed;
    }
    
    if(firsttrans){
      firsttrans = false;
      showtrans = true;
      transscroll = trackscroll-tracks.width*2;
    }
   
    if(!firsttrans && transscroll > tracks.width + scroll){
      showtrans = false;
      firsttrans = true;
      acc = 0;
      background = tracks;
    }
    
  }
  
  if(speed == 0) background = station;
  
  //Draw Background (Tracks or station)
  nimage(background, trackscroll, vheight/2);
  nimage(background, trackscroll-tracks.width, vheight/2);
  nimage(background, trackscroll+tracks.width, vheight/2);
  trackscroll += speed;
  if (trackscroll > tracks.width) trackscroll -= tracks.width;

  if(showtrans && acc == -1) {
    transscroll += speed;
    nimage(tracks, transscroll+tracks.width, vheight/2);
    nimage(transition1, transscroll, vheight/2);
    nimage(station, transscroll-tracks.width, vheight/2);
  }
  
  if(showtrans && acc == 1) {
    transscroll += speed;
    nimage(tracks, transscroll-tracks.width, vheight/2);
    nimage(transition2, transscroll, vheight/2);
    nimage(station, transscroll+tracks.width, vheight/2);
  }

  //Draw level
  noisepos += 0.07*speed/maxspeed; //Wackeln der wagen;
  noiseoff = (noise(noisepos)-0.5)*2.5;
  nimage(level, vwidth/2, vheight*vertoff+noiseoff);
  nimage(link, (vwidth-level.width-link.width)/2, vheight*vertoff+(noise(noisepos+20)-0.5)*2.5);
  nimage(wagon, (vwidth-level.width-wagon.width)/2-link.width, vheight*vertoff+(noise(noisepos+30)-0.5)*2.5);
  nimage(link, (vwidth+level.width+link.width)/2, vheight*vertoff+(noise(noisepos+40)-0.5)*2.5);
  nimage(wagon, (vwidth+level.width+wagon.width)/2+link.width, vheight*vertoff+(noise(noisepos+50)-0.5)*2.5);

  ddraw();

  //Show NPCs
  for (int i = 0; i < charnum; i++) {
    npcs[i].collide();
    npcs[i].randmove();
    npcs[i].show();
  }

  //Draw and move players
  p1.show();
  p1.move();
  p1.collide();

  p2.show();
  p2.move();
  p2.collide();
  
  //Show Text
  textAlign(CENTER,CENTER);
  textSize(45*scale);
  text(overlaytext, width/2, height*0.1);
  textSize(20*scale);
  if(gameover) text("Drücke eine beliebige Taste zum Fortfahren.", width/2, height*0.9);
  
  //Scroll
  if((intrain(p1.x,p1.y,0) && intrain (p2.x,p2.y,0) || instation) && !gameover){
    nscroll = constrain((p1.x+p2.x-vwidth)/2, -vwidth/2, vwidth/2);
    //Block if outside of display
    if(startanimation){
      if(abs(scroll-nscroll) < 2){
        scroll = nscroll;
        startanimation = false;
      }else{
        scroll = (scroll-nscroll)*0.95+nscroll;
      }
    }else{
      scroll = nscroll;
      if (abs(p1.x-p2.x)+10 > vwidth) {
        if (p1.x-scroll < 5) {
          p1.x = 5+scroll;
          p2.x = vwidth+scroll-5;
        } else {
          p2.x = 5+scroll;
          p1.x = vwidth+scroll-5;
        }
      }
    }
  }
}

void checkwin(){
  if(!intrain(p1.x,p1.y,0) && !intrain(p2.x,p2.y,0)){
    overlaytext = "Ihr habt beide verloren!";
    gameover = true;
    tastencooldown = millis() + 1000;
  }else if(!intrain(p1.x,p1.y,-minDist/2)){
    overlaytext = "Spieler 2 hat gewonnen";
    gameover = true;
    tastencooldown = millis() + 1000;
  }else if(!intrain(p2.x,p2.y,-minDist/2)){
    overlaytext = "Spieler 1 hat gewonnen";
    gameover = true;
    tastencooldown = millis() + 1000;
  }
}
