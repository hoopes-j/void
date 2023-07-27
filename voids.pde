
AEC aec;

Window window;
Window window2;


float counterMaxMS = 10000;
int counter = 0;
float t = 0;
int counterMaxFrames;

Life life;
Facade facade;


void setup() {
  frameRate(25);
  size(1200, 400);
  
  aec = new AEC();
  aec.init();

  counterMaxFrames = toFrames(counterMaxMS);

  facade = new Facade(4);
}

PVector faceSize = new PVector(10,24);

void draw() {
  aec.beginDraw();  
  background(0, 0,0);
  noStroke();

  facade.backgroundColor = color(255);
  facade.animate();
  facade.draw();


  aec.endDraw();
  aec.drawSides();

  //counter++;
  //if (counter>=counterMaxFrames) {
  //  facade.backgroundColor = color(255);
  //}
}


float noiseLoop(float x,float y,float theta) {
  float rad = 1;
  float sc = 1; 
  float offset = 10; // parameters for the noise
  return noise(
    x*sc,
    y*sc+counter*.01
  );

}

// from easings.net
float easeInOutSine(float x) {
	return -(cos(PI * x) - 1) / 2;
}

void keyPressed() {
  aec.keyPressed(key);
}
