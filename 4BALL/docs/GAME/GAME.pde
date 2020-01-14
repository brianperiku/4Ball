import gifAnimation.*;   // import library for playing gifs

Game main;  // declare class 'Game'

Gif ron;    // declares both gifs to be used
Gif luiz;

String Ri="mouse to move";    // info string on controls to move paddles in both modes
boolean modeOne, modeTwo;    // the two game mode booleans to trigger each
float bx, by;      // x and y position of ball
int txtsize = 18;        // sets text size 
int background = 20;      // background color value 
int timeColorTwo,timeColorThree;    // colour of clock text
PImage ball_img, field, aldo, stad, sun, clouds;  // all images to be used
PFont f;
boolean lUp, lDown, tLeft, tRight, bLeft, bRight;
float xposTop, xposBot;
boolean begin=false; boolean restart=false; boolean end=false;
int a, b, mins, secs;  // variables for clock's minutes and seconds

void setup(){
  
   main = new Game();  // declare the class Game
 
  ron = new Gif(this, "ronaldinho.gif");  // import syntax to plays gifs
  ron.play();
  luiz = new Gif(this, "luiz.gif");
  luiz.play();
  
  imageMode(CENTER);
  ball_img = loadImage("socball.png");  // importing of all images/gifs/fonts
  field = loadImage("field.png");
  aldo = loadImage("aldo.png");
  stad = loadImage("stad.png");
  sun = loadImage("cloudy.png");
  clouds = loadImage("cloudy2.png");
  f = createFont("pixely.ttf", 18);
  
  size(400, 400);    // sets screen size, and media settings
  rectMode(CENTER);
  ellipseMode(RADIUS);
  textAlign(CENTER);
  textFont(f);  // font to be used throughout
 
  bx = width/2+1;    // xpos of ball starts in center of screen
  by = height/2-1;    // ypos of ball starts in center of screen
  xposTop = width/2;  // xpos of top paddle
  xposBot = width/2;  // xpos of bottom paddle
}

void draw() {
  
background(background);    // set background colour
main.beginScreen();
main.titleText();
main.drawField();
main.startup();
main.menu();
main.movePaddles();
main.velocity();
main.borders();
main.collisions();
main.limiter();
main.clock();
main.drawPaddles();
main.score();
main.instructions();
main.drawBall();
main.drawNet();
main.end();

}

void keyPressed(){      // 4 player mode controls
  if(modeOne==true){
    if (key == 'w' || key == 'W'){lUp = true;}
    if (key == 's' || key == 'S'){lDown = true;}
    if (key == 'j' || key == 'J'){tLeft = true;}
    if (key == 'l' || key == 'L'){tRight = true;}
    if (keyCode == LEFT){bLeft = true;}
    if (keyCode == RIGHT){bRight = true;}
  }
}

void keyReleased(){      // 4 player mode controls
  if(modeOne==true){
    if (key == 'w' || key == 'W'){lUp = false;}
    if (key == 's' || key == 'S'){lDown = false;}
    if (key == 'j' || key == 'J'){tLeft = false;}
    if (key == 'l' || key == 'L'){tRight = false;}
    if (keyCode == LEFT){bLeft = false;}
    if (keyCode == RIGHT){bRight = false;}
  }
}



class Game{           // MAIN CLASS
  
float bsize;                                                                  // size of ball
float xvelocity, yvelocity;                                                   // speed in x & y direction
float minVelocity, maxVelocity;                                               // min/max velocity in both directions
float pvelocity;                                                              // paddle moving velocity
float xposLeft, xposRight, yposRight, yposLeft, yposTop, yposBot;             // x or y positions of all 4 paddles
float xposStart, yposStart;                                                   // the x and y positions of the "click to start" txt on main screen
int r;                                                                        // radius of circle title text is placed around on main screen
float arclength;                                                              // arclength of circle on main title text
int pwidth, pheight;                                                          // paddle width & length
int walldist;                                                                 // distance of paddle from edge of screen
int scoreL,scoreR,scoreT,scoreB;                                              // respective player scores in 4p mode
int displayw, displayh;                                                       // h and w of display window
int rectFillYes, rectFillNo, textFillYes, textFillNo;                         // fill colour of buttons to trigger restart or end of game
String start, title;                                                          // strings for main screen
String fourMode, soloMode, selMode;                                           // strings for menu screen
String cont, yes, no;                                                         // strings end screen
boolean menu;                                                                 // boolean to trigger menu


Game(){             // CONSTRUCTOR

r = 100;
bsize = 5;             
xvelocity = random(-3,3);      // rate of balls x coordinate change
yvelocity = random(-3,3);      // rate of balls y coordinate change
maxVelocity = 4;    // maximum velocity in both directions
pvelocity = 4;
pwidth = 5;                   // paddle width
pheight = 50;                 // paddle length
walldist = 15;                // distance of paddle from edge of screen
displayw = 400;
displayh = 400;
start = "click to start";     // start button text
title = "4BALL";              
menu = false;
modeOne=false;
modeTwo=false;
yposRight = height/2;
xposRight = width-walldist-pwidth-2;
xposLeft = walldist+pwidth+2;
yposLeft = height/2;
yposTop = walldist+pwidth+2;
yposBot = height-walldist-pwidth-2;
xposStart = width/2;
yposStart = 0.65*height;
}


void beginScreen(){
  if (begin == false){
    fill(102,132,35);
    background(143,194,255);
    noStroke();
    rect(width/2,height-40,width,80);
    fill(255);
    rect(width/2,337,width,4); 
    image(stad,width/2,0.7*height,400,100);
    image(ron,width/6,3*height/4,300,200);
    image(luiz,5*width/6,3*height/4-4,300,200);
    image(aldo,width/2,0.82*height,150,150);
    image(sun,352,56,150,100);
    image(clouds,40,180,120,80);
    
  if(menu==false){
    image(ball_img,width/2,2*height/5,150,150);
    }
  }
}


void titleText(){
  if (begin == false){
      translate(width/2+5, 2*height/5);
      noFill(); noStroke(); textSize(42);
      ellipse(0, 0, r*2, r*2);
      arclength = 0;
      
    for (int i = 0; i < title.length(); i++){
        char currentChar = title.charAt(i);
        float w = textWidth(currentChar);
        arclength += 1.375*w;
        float theta = PI + arclength/r;    // Angle in rad = arclength / radius 
        pushMatrix();// Polar to cartesian
        translate(r*cos(theta), r*sin(theta)); // Rotate box
        rotate(theta+PI/2); // offset rotation by 90deg
        text(currentChar,0,0);     // print chars
        popMatrix();// Move halfway again
        arclength += w/2;
        }
  }
}


void startup(){
 if (begin == false){
    translate(-1*(width/2)-5, -2*height/5);
    fill(255);
    textSize(18);
    text(start, xposStart, yposStart);    // button to start game
  
  if(mouseX>(xposStart-(textWidth(start)/2)) && mouseX<(xposStart+(textWidth(start)/2)) && mouseY>(yposStart-txtsize) && mouseY<(yposStart+txtsize)){
  if(mousePressed == true){
    start = "";
    title = "";// makes text dissapear upon clicking
    menu = true;
    selMode = "select mode"; fourMode = "four player"; soloMode = "1P TRAINING";}     // and menu opens
    }
    }
}


void menu(){
 if(menu==true){
    textSize(28);
    text(selMode,width/2,height/8);
    textSize(18);
    text(fourMode,width/2,height/4);
    text(soloMode,width/2,height/3);
  
  if(mouseX>129 && mouseX<266 && mouseY>82 && mouseY<100){  // if four player mode selected
  if(mousePressed == true){ 
    selMode = ""; fourMode = ""; soloMode = "";
    menu=false;
    end = false;
    begin=true;
    modeOne=true;
    }
    }
  if(mouseX>129 && mouseX<266 && mouseY>117 && mouseY<135){  // if one player mode selected
  if(mousePressed == true){ 
    selMode = ""; fourMode = ""; soloMode = "";
    menu=false;
    end = false;
    begin=true;
    modeTwo=true;
  }
  }
}
}


void velocity(){
  if(secs>2 || mins>0){
  if (begin == true || restart == true){
    if(modeOne==true){
      bx += xvelocity;    // increase ball's x value by velocity in x direction
      by += yvelocity;    // increase ball's y value by velocity in y direction  
      }
    if(modeTwo==true){
      bx += 1.25*xvelocity;
      by += 1.25*yvelocity;
      }
  }
  }
}


void movePaddles(){

  if(modeOne==true){
  
    if (lUp == true){yposLeft-=pvelocity;} // left paddle
    if (lDown == true){yposLeft+=pvelocity;}

    if(tLeft == true){xposTop-=pvelocity;} // top paddle
    if(tRight == true){xposTop+=pvelocity;}

    if(bLeft == true){xposBot-=pvelocity;} // bottom paddle
    if(bRight == true){xposBot+=pvelocity;}
  }

yposRight = constrain(mouseY,pheight-13,height-pheight+13);
  
  if(modeTwo==true){
    yposLeft = constrain(mouseY,pheight-13,height-pheight+13);
    xposBot = constrain(mouseX,pheight-13,height-pheight+13);
    xposTop = constrain(mouseX,pheight-13,height-pheight+13);
 }
}


void borders(){
  if(lUp == true && yposLeft <= yposTop+pheight/2-10)   {yposLeft = yposTop+pheight/2-10;} // LEFT
  if(lDown == true && yposLeft >= yposBot-pheight/2+10) {yposLeft = yposBot-pheight/2+10;}
  
  if(tLeft==true && xposTop <= xposLeft+pheight/2-4)    {xposTop = xposLeft+pheight/2-4;}  //TOP
  if(tRight==true && xposTop >= xposRight-pheight/2+4)  {xposTop = xposRight-pheight/2+4;} 
  
  if(bLeft==true && xposBot <= xposLeft+pheight/2-4)    {xposBot = xposLeft+pheight/2-4;}    //BOT
  if(bRight==true && xposBot >= xposRight-pheight/2+4)  {xposBot = xposRight-pheight/2+4;}
}


void collisions(){
if (begin == true || restart == true){

if(bx <= xposLeft && xvelocity<0){ // LEFT
if(by >= yposLeft-pheight/2-3 && by <= yposLeft+pheight/2+3) {
xvelocity*=-1;
  if(by<yposLeft-3*pheight/10 && yposLeft>37.0+pheight/2){yvelocity=-1.25*xvelocity;}
  if(by<yposLeft-pheight/10 && yposLeft<40.0){yvelocity=random(0.75,2);}
  
  if(by>yposLeft-3*pheight/10 && by<yposLeft-pheight/10){yvelocity=-0.75*xvelocity;}
  if(by>=yposLeft-pheight/10 && by<=yposLeft+pheight/10){xvelocity=2; yvelocity=random(-0.5,0.5);}
  if(by>yposLeft+pheight/10 && by<yposLeft+3*pheight/10){yvelocity=0.75*xvelocity;} 
  
  if(by>yposLeft+pheight/10 && yposLeft>360){yvelocity=random(-0.75,-2);}
  if(by>yposLeft+3*pheight/10 && yposLeft<360){yvelocity=1.25*xvelocity;}
}
}


if(bx >= xposRight && xvelocity>0){  // RIGHT
if(by >= yposRight-pheight/2-3 && by <= yposRight+pheight/2+3) { 
xvelocity *= -1;
  if(by<yposRight-3*pheight/10){yvelocity=1.25*xvelocity;}
  if(by<yposRight-pheight/10 && yposRight<40.0){yvelocity=random(0.75,2);}
  
  if(by>yposRight-3*pheight/10 && by<yposRight-pheight/10){yvelocity=0.75*xvelocity;}
  if(by>=yposRight-pheight/10 && by<=yposRight+pheight/10){xvelocity=-2; yvelocity=random(-0.5,0.5);}
  if(by>yposRight+pheight/10 && by<yposRight+3*pheight/10){yvelocity=-0.75*xvelocity;}
  
  if(by>yposRight+pheight/10 && yposRight>360){yvelocity=random(-0.75,-2);}
  if(by>yposRight+3*pheight/10){yvelocity=-1.25*xvelocity;}
}
}

if(by <= yposTop && yvelocity<0){    // TOP
if(bx >= xposTop-pheight/2-3 && bx <= xposTop+pheight/2+3){ 
yvelocity *=-1;
  if(bx<xposTop-3*pheight/10){xvelocity=-1.25*yvelocity;}
  if(bx>xposTop-3*pheight/10 && bx<xposTop-pheight/10){xvelocity=-0.75*yvelocity;}
  if(bx>=xposTop-pheight/10 && bx<=xposTop+pheight/10){yvelocity=2; xvelocity=random(-0.5,0.5);}
  if(bx>xposTop+pheight/10 && bx<xposTop+3*pheight/10){xvelocity=0.75*yvelocity;} 
  if(bx>xposTop+3*pheight/10){xvelocity=1.25*yvelocity;}
}
}

if(by >= yposBot && yvelocity>0){   // BOT
if(bx >= xposBot-pheight/2-3 && bx <= xposBot+pheight/2+3){
yvelocity *=-1;
  if(bx<xposBot-3*pheight/10){xvelocity=1.25*yvelocity;}
  if(bx>xposBot-3*pheight/10 && bx<xposBot-pheight/10){xvelocity=0.75*yvelocity;}
  if(bx>=xposBot-pheight/10 && bx<=xposBot+pheight/10){yvelocity=-2; xvelocity=random(-0.5,0.5);}
  if(bx>xposBot+pheight/10 && bx<xposBot+3*pheight/10){xvelocity=-0.75*yvelocity;} 
  if(bx>xposBot+3*pheight/10){xvelocity=-1.25*yvelocity;}
}
}

}
}


void limiter(){ 
    if(xvelocity >  maxVelocity)   {xvelocity =  maxVelocity;}                                //and x velocity is greater than max(right), cap to max
    if(xvelocity < -1*maxVelocity) {xvelocity = -1*maxVelocity;}                                //or x velocity is less than -max(left), cap to -max
    if(xvelocity<1 && xvelocity>0 && yvelocity<1 && yvelocity>-1)  {xvelocity = 1;}
    if(xvelocity>-1 && xvelocity<0 && yvelocity<1 && yvelocity>-1) {xvelocity = -1;}

    if(yvelocity >  maxVelocity) { yvelocity =  maxVelocity; }                                  // same with y velocity
    if(yvelocity < -1*maxVelocity) { yvelocity = -1*maxVelocity;}
    if(yvelocity<1 && yvelocity>0 && xvelocity<1 && xvelocity>-1)  {yvelocity = 1;}
    if(yvelocity>-1 && yvelocity<0 && xvelocity<1 && xvelocity>-1) {yvelocity = -1;}
}


void drawBall(){
  if (begin == true || restart == true){
    fill(0);
    stroke(255);
    strokeWeight(2);
    ellipse(bx, by, bsize, bsize); 
    
    image(ball_img, bx, by,3*bsize,3*bsize);
}
}
 
 
void drawPaddles(){
  if (begin == true || restart == true){
    strokeWeight(2);
    
    stroke(255,0,144);
    fill(57,255,20);
    rect(width-walldist, yposRight, pwidth, pheight);      // draw right paddle
    
    stroke(0,0,255);
    fill(0,191,255);
    rect(walldist, yposLeft, pwidth, pheight);            // draw left paddle
    
    stroke(90,39,41);
    fill(253,180,48); 
    rect(xposTop, walldist, pheight, pwidth);            // draw top paddle
    
    stroke(0);
    fill(255,0,0);
    rect(xposBot, height - walldist, pheight, pwidth);   // draw bottom paddle
}
}


void drawNet(){
    stroke(160,32,240);
    strokeWeight(4);
  if (begin == true){
  line(width/2-2*pheight, height-pwidth, width/2+2*pheight, height-pwidth); // bottom
  line(width/2-2*pheight, pwidth, width/2+2*pheight, pwidth);               // top
  line(pwidth, height/2-2*pheight, pwidth, height/2+2*pheight);             // left
  line(width-pwidth, height/2-2*pheight, width-pwidth, height/2+2*pheight); // right
}
}


void drawField(){
  if (begin == true || restart == true){
  image(field,width/2,height/2,width,height);
}
}


void clock(){
  if (begin == true || restart == true){
    a=(millis()-b)/1000;    //convert millis to mins
    mins=a/60;              
    secs=a%60;              //convert millis to secs
    timeColorTwo=0;
    timeColorThree=0;
    String time = mins+":"+secs;
  
  if(secs>2 || mins>0){timeColorTwo=255;timeColorThree=255;}
    noStroke();
    fill(0);
    rect(55,24,(56-(56-(textWidth(time)/2)))+25,25);  
    fill(255,timeColorTwo,timeColorThree);
    text(time,56,30);

  if((mouseX>129 && mouseX<266 && mouseY>82 && mouseY<100 && mousePressed==true )||(mouseX>120 && mouseX<199 && mouseY>173 && mouseY<209 && mousePressed==true)){
    b=millis();
  }
  if(mouseX>129 && mouseX<266 && mouseY>117 && mouseY<135 && mousePressed==true){
    b=millis();
  }
}
}


void score(){
  if(modeOne==true){
  if (begin == true || restart == true){

  noStroke();
  fill(0);
  rect(3*width/4,height/2-2,30,20); //right
  rect(width/4,height/2-2,30,20);   //top
  rect(width/2,3*height/4-2,30,20); //bot
  rect(width/2,height/4-2,30,20);   //left     
    
if(bx >= width-pwidth-5 && by>height/2-2*pheight && by<height/2+2*pheight){
if(mouseX<120 || mouseX>199 || mouseY<173 || mouseY>209){    
if(mouseX<199 || mouseX>278 || mouseY<173 || mouseY>209){
scoreR--;
}
}
}

if(bx <= 3 && by>height/2-2*pheight && by<height/2+2*pheight && (xvelocity!=0 || xvelocity!=0)){
if(mouseX<120 || mouseX>199 || mouseY<173 || mouseY>209){    
if(mouseX<199 || mouseX>278 || mouseY<173 || mouseY>209){
scoreL--;
}
}
} 

if(by == height-pwidth && by>width/2-2*pheight && by<width/2+2*pheight){
if(mouseX<120 || mouseX>199 || mouseY<173 || mouseY>209){    
if(mouseX<199 || mouseX>278 || mouseY<173 || mouseY>209){
scoreB--;
}
}
}

if(by == pwidth && by>width/2-2*pheight && by<width/2+2*pheight){
if(mouseX<120 || mouseX>199 || mouseY<173 || mouseY>209){    
if(mouseX<199 || mouseX>278 || mouseY<173 || mouseY>209){
scoreT--;
}
}
}
  fill(255);
  text(scoreR, 3*width/4+1,height/2+5);
  text(scoreL, width/4+1,height/2+5);
  text(scoreB, width/2+1,3*height/4+5);
  text(scoreT, width/2+1,height/4+5);
}
}
}


void instructions(){

 if (begin == true && restart == false){
 if(modeOne == true && secs<5){
  String Li="W & D to move";
  String Ui="J & L to move";
  String Di="< & > to move";
  fill(0);
  rect(80,255,125,20);
  rect(330,135,125,20);
  rect(width/2,340,125,20); 
  rect(width/2,55,125,20); 
  textSize(14); fill(255);
  text(Li,80,260);
  text(Ri,330,140);
  text(Di,width/2,345);
  text(Ui,width/2,60);
 }
 
if(modeTwo == true && secs<3){
  fill(0);
  rect(width/2,height/4-7,160,20);
  fill(255);
  text(Ri,width/2,height/4);
 }
 }
}


void end(){

 if(bx>displayw || bx<0 || by>displayh || by<0){
  xvelocity = 0; yvelocity=0;
  cont = "continue?"; yes = "yes";no = "no";
  
  if(mouseX<120 || mouseX>199 || mouseY<173 || mouseY>209){    // color button and text changer
  rectFillYes=0;textFillYes=255;}
  if(mouseX<199 || mouseX>278 || mouseY<173 || mouseY>209){
  rectFillNo=0;textFillNo=255;}
  if(end == false){
  fill(0); noStroke();
  rect(200,160,160,100);
  fill(rectFillYes);
  rect(width/2-40,height/2-8,80,35);
  fill(rectFillNo);
  rect(width/2+40,height/2-8,80,35);
  fill(255);
  text(cont, width/2,height/3);
  fill(textFillYes);
  text(yes, width/2-40,height/2);
  fill(textFillNo);
  text(no, width/2+40,height/2);}

  if(mouseX>199 && mouseX<278 && mouseY>173 && mouseY<209){ // if hovering over NO
    textFillNo=0;
    rectFillNo=255;
    
    if(mousePressed == true){      // if NO is selected
      begin = false;
      restart = false;
      end = true;
      modeOne=false;
      modeTwo=false;
      cont = ""; yes = ""; no = "";
      start = "click to start";
      title = "4ball";
      by = height/2-1;
      bx = width/2+2;
      xvelocity = random(-3,3);
      yvelocity = random(-3,3);
    }
  }
  if(mouseX>120 && mouseX<199 && mouseY>173 && mouseY<209){ // if hovering over YES
    textFillYes=0;
    rectFillYes=255;
    
    if(mousePressed == true){      // if YES is selected
      restart = true;
      cont = ""; yes = ""; no = "";
      by = height/2-2;
      bx = width/2+2;
      xvelocity = random(-3,3);
      yvelocity = random(-3,3);
      end = false;
    }
  }
}
}

}
