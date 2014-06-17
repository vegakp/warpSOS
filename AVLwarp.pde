//Created by the Advanced Visualization Laboratory at Indiana University
//Created by Karla Vega
//Processing 2.1.1 

///////This is an example sketch that uses warping utilities for ECE projection

//Import any other libraries here
import java.util.*;

//Global variables
PGraphics pg; //offscreen buffer renderer
PImage ece; //reference image
float[] glyphParam = new float[4];
PShape worldSVG; //Background map image - SVG

void setup() {
  
  size(1000,500, P3D); //(2:1 for SOS)
  pg = createGraphics(1024,1024); //initialize offscreen buffer
  hint(DISABLE_DEPTH_TEST);//avoids z-fighting
  ece = loadImage("prewarped_ece.png");
  worldSVG = loadShape("BlankMap-Equirectangular.svg");
  noLoop(); 
  
}

void draw(){
  background(150);
  worldSVG.setFill(color(115,115,115)); 
  shape(worldSVG, 0, 0, width, height*.965); //show background image
// image(ece, 0, 0); //show reference image

//Create an offscreen render ellipse to be warped
  pg.beginDraw();
  pg.background(0,0,0,0);
  pg.stroke(255);
  pg.fill(155,255,255,100);
  pg.ellipse(512,512,1024,1024);
  pg.textAlign(CENTER);
  pg.fill(255);
  pg.textSize(250);
 // pg.text("HELLO", 512,637); // can add text or anyother graphics
  pg.endDraw();
  
 ///////////////////////////METHOD ONE/////////////////////////////////////////// 
  //Create quadStrip using method 1: Fish Eye Lense Algorithm
  //two files needed for this are getQuadStrip and C2SOS
  PShape quadStrip1, quadStrip2, quadStrip3, quadStrip4; // Initialize Quads
  float sizeQuadX = 25.0; // size of quad x direction
  float sizeQuadY = 25.0; // size of quad y direction
  float resQuad = sizeQuadY; //y resolution of image
  
  for(int j = (30*width/360); j<=(330*width/360); j=j+(30*width/360))
  {  
    for(int i = (30*height/180); i<=(150*height/180); i=i+(30*height/180))
    {
      PShape quadStrip; // initialize shape
      //USAGE: quadStrip =   getQuadStrip(x-position, y-postion, sizeQuadX, sizeQuadY, resQuad, image to warp);
      quadStrip =   getQuadStrip(j, i-resQuad, sizeQuadX, sizeQuadY, resQuad, pg);
     //Uncomment to render
     // shape(quadStrip);
    }
  }

  


/////////////////////////////METHOD TWO///////////////////////////////////////////////////

// The following code generates the grid lines
//needed for map function
  int w_start = 180; //Longitude start - largest longitude value
  int w_end = -180; //Longitude end - smallest longitude value
  float h_start = 90; //Latitude start - largest latitude value
  float h_end = -90; //Latitude end - smallest latitude value

stroke(120,120,120);
strokeWeight(1);

for (float i = -170; i <180; i=i+10){
  if(i==0){
    stroke(0,0,0,90);
  }else{
  stroke(120,120,120);}
  line(map(i, w_end, w_start, 0, width),0,map(i, w_end, w_start, 0, width),height);
}
  
for(int i = -80; i<90; i=i+10){
    if(i==0){
    stroke(0,0,0,90);
  }else{
  stroke(120,120,120);}
  line(0, map(i, h_start, h_end, 0, height), width, map(i, h_start, h_end, 0, height));
}

// End of code for grid lines

// Create QuadStrips using Tissot Indicatrix Method
  
  for(int j = -150; j<=150; j=j+30)
  {  
    for(int i = -60; i<= 60; i=i+30)
    {
      PShape circle_Tissot; //initialize shape
      //USAGE: name = createQuad(lon, lat, size x pixels, size y pixels, image);
      circle_Tissot = createQuad(j,i,25,25,pg);
      shape(circle_Tissot);
     }
  }

 //Uncomment to render image
// saveFrame("test.png"); 
}
