PImage source;   
int gridSize;
int dFactor = 1;
float[][] points = new float[gridSize][gridSize];
float average;
Element elements[]; 
float thresholds[] = new float[10];

void setup() {
  background(255);
  size(800, 800);
  gridSize = width/100;
  elements = new Element[100*100];
  source = loadImage("Face3.jpg");  
  println("start");
  noStroke();
}

void draw() {  
  noLoop();
  source.loadPixels();
  int index = 0;
  for (int x = 0; x < source.width; x+=gridSize) { //iterate through image through given grid size
    for (int y = 0; y < source.height; y+=gridSize) {
      avgB(x,y);
      elements[index] = new Element(x,y,average,0);
      average=0;
      index++;
    }
  }
  thresholdGen();
  println(thresholds);
  for(int i=0; i < elements.length; i++){
    //elements[i].pixellated(); 
    elements[i].threshold(); 
    elements[i].scribbled(); 
  }
}

void avgB(int i, int j){
  float k =0;
  for (int x = 0; x < gridSize; x++) {
    for (int y = 0; y < gridSize; y++) { //y is already higher than gridSize in second loop
      int loc = (i+x) + (j+y)*source.width;
      average += brightness(source.pixels[loc]);
      k++;
    }
  }
  average = average/k;
}

void thresholdGen(){
  float max = 0;
  float min = 10000;
  for(int i=0; i < elements.length; i++){
    if(elements[i].bright < min){
      min = elements[i].bright;
    }
    if(elements[i].bright > max){
      max = elements[i].bright;
    }
  }
  println(min, max);
  float len = (thresholds.length);
  for (int i = 0; i < thresholds.length; i++) {
    thresholds[i] = lerp(min, max, i*(1/len));
  }
}

void scribble(int st){
  strokeWeight(1);
  //rect(-gridSize,-gridSize,gridSize*2,gridSize*2);
  float x1,x2,y1,y2;
  x1 = random(-gridSize,gridSize);
  y1 = random(-gridSize,gridSize);
  for(int i = 0; i < st; i++){
    x2 = random(-gridSize,gridSize);
    y2 = random(-gridSize,gridSize);
    strokeWeight(2);
    stroke(53,70,92,150);
    line(x1,y1,x2,y2);
    x1 = x2;
    y1 = y2;
  }
}

class Element{
  int x,y,stro;
  float bright;
  
  Element(int xTemp, int yTemp, float brightTemp, int stroTemp){
    x = xTemp;
    y = yTemp;
    stro=stroTemp;
    bright = brightTemp;
  }
  
  void threshold(){
     for(int i = 0; i < thresholds.length; i++){
      if(bright < thresholds[i]){
        stro = (thresholds.length-i)*dFactor;
        break;
      } else {
        stro = 0;//thresholds.length; 
      }
    }
  }
  
  void scribbled(){ //scribbles
    pushMatrix();
    translate(x,y);
    scribble(stro);
    popMatrix();
  }
  
  void pixellated(){ //pixellated
    float fFill=0;
    for(int i = 0; i < thresholds.length; i++){
      if(bright < thresholds[i]){
        fFill = thresholds[i];
        break;
      } else {
        fFill = 255.0; 
      }
    }
    fill(fFill);
    rect(x,y,gridSize,gridSize);
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("scribbles"+(System.currentTimeMillis()/1000)+".png");
    print("saved.");
  }
  //if (key == 'd') {
  //  background(255);
  //  start = true;
  //}
}