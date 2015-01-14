import ddf.minim.*;

//Settings
float scale = 2;
char[] p1k= {'w','s','a','d',' '};
char[] p2k= {UP,DOWN,LEFT,RIGHT,ENTER};
int charnum = 7;
float minDist = 10;
int vheight = 400;
float vertoff = 0.425;
float maxspeed = 20;

int vwidth = vheight/9*16;

//Location of the seats
int[] seatx = {91, 206, 258, 289, 341, 456, 508, 539, 590, 706};
int[] seaty = {19, 54, 123, 157};
Seat[] seats = new Seat[44];
ArrayList<Seat> seatlist;

//Location of the walls
int[] walls = {106,190,273,356,440,523,606,690};

//Pictures
PImage tracks;
PImage level;
PImage link;
PImage wagon;
PImage station;
PImage transition1;
PImage transition2;
PImage title;
PImage instructions;
SpriteSet[] pl = new SpriteSet[2];

//Font
PFont font;

//Players
Player p1;
Player p2;

//NPCs
character[] npcs = new character[charnum];

//Sound
Minim m;
AudioPlayer music;

boolean game = false;
boolean gameover = false;
int tastencooldown = 0;
int start = 0;
int fadeout = 255;
int showkeypress;


void setup() {
  size((int)(scale*vwidth), (int)(scale*vheight));
  noSmooth();
  
  //Load Pictures
  tracks = loadImage("tracks.png");
  level = loadImage("level.png");
  link = loadImage("link.png");
  wagon = loadImage("roof.png");
  station = loadImage("station.png");
  transition1 = loadImage("transition1.png");
  transition2 = loadImage("transition2.png");
  title = loadImage("titlescreen.png");
  instructions = loadImage("instructions.png");
  pl[0] = new SpriteSet("m");
  pl[1] = new SpriteSet("w");
  dloadImg();
  
  //Load Font
  font = loadFont("PixelFont.vlw");
  textFont(font);
  background = tracks;
  scroll = -900;
  gamesetup();
  showkeypress = millis() + 1000;
  
  //Load and start Soundtrack
  m = new Minim(this);
  music = m.loadFile("OST1.wav");
  music.loop();
}

void draw() {
  imageMode(CENTER);
  if(start == 0){
    image(title, width/2, height/2, width, height);
    if(showkeypress < millis() && (music.position()/600) % 2  == 0){
      textSize(20*scale);
      textAlign(LEFT,CENTER);
      text("Drücke eine beliebige Taste zum Starten!", width*0.045, height*0.90);
    } 
  }
  
  if(start == 1) background(0);
  
  noTint();
  if(game) gameloop();
  
  if(start == 1){
    
    if(game) fadeout -= 7;
    if(fadeout < 0) start = 2;
    
    tint(255, fadeout);
    image(instructions, width/2, height/2, width, height);
    if(!game && tastencooldown < millis()){
      textSize(20*scale);
      textAlign(CENTER,CENTER);
      fill(255, map(constrain(sin((millis()-tastencooldown)/600f-PI/4)*1.2,-1,1),-1,1,0,255));
      text("Drücke eine beliebige Taste zum Starten!", width*0.5, height*0.90);
    } 
  }
}


//Keyevents
void keyPressed(){
  if(game && !gameover){
    for( int i = 0; i < p1.keys.length; i++){
      if (key == CODED){
        if(keyCode == p1.keys[i]) p1.pressed(i);
      }else{
        if(key == p1.keys[i] || key + 32 == p1.keys[i]) p1.pressed(i);
      }
    }
    for( int i = 0; i < p1.keys.length; i++){
      if (key == CODED){
        if(keyCode == p2.keys[i]) p2.pressed(i);
      }else{
        if(key == p2.keys[i]) p2.pressed(i);
      }
    }
  }
  
  if(gameover && tastencooldown < millis()){
    startanimation = true;
    gamesetup();
  }
  
  if(start == 0){
    start++;
    tastencooldown = millis() + 3000;
  }
  if(start == 1 && tastencooldown < millis()){
    game = true;
    fill(255);
  }
}

void keyReleased(){
  for( int i = 0; i < p1.keys.length; i++){
    if (key == CODED){
      if(keyCode == p1.keys[i]) p1.released(i);
    }else{
      if(key == p1.keys[i] || key + 32 == p1.keys[i]) p1.released(i);
    }
  }
  for( int i = 0; i < p1.keys.length; i++){
    if (key == CODED){
      if(keyCode == p2.keys[i]) p2.released(i);
    }else{
      if(key == p2.keys[i]) p2.released(i);
    }
  }
}


