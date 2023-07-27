int CLOSE = 0;
int OPEN = 1;

class Window {
  
  PVector origin;
  PVector size;
  PVector pos;
  int spacingX;
  int spacingY;
  int max_level;
  
  PVector v;
  
    int transparency = 255;
    float[] max_color = {0,0,0};
    // float[] max_color = {255,255,0};
    float[] min_color = {255,255,255};
    // float[] min_color = {255,0,0};
    // float[] min_color = {255,0,0};

    float[] axisBounds = {-1.0, 1.0};

    // closer to max_levels = open, closer to 0 = closed
    int gradientPos;
    
    
    int color_array_idx = 0;
    int color_array_size = 3;
    int[][] color_array = {
        {255,0,0},
        {255,0,255},
        {0,255,0},
        {0,0,0}
    };
    
    int fade_counter = 0;
    int fade_counter_max = 100;
    
    int shapeMode;
 
  Window(PVector _spacing, int _numShapes, PVector _size, PVector _origin) {
    this.pos = new PVector(0,0);
    this.v = new PVector(random(.01)+0.03,random(0.01)+0.05);
    this.origin = _origin;
    
    int spacingX = int(_spacing.x);
    int spacingY = int(_spacing.y);
    this.max_level = _numShapes;
    
    this.shapeMode = ELLIPSE;
    this.size = _size;

    this.gradientPos = 0;
    
  }
  
  
  void updatePos(float x, float y) {
    this.pos = new PVector(x,y);
  }
  
  void updateV(float x, float y) {
    this.pos = new PVector(x,y);
  }
  
  // Draw Concentric Rectangles
  void draw() {
    println(this.max_level);
    for (int i = 0; i < this.max_level; i++) {
      
      float[] c = {0,0,0};
      for (int channel = 0; channel < 3; channel++) {
        c[channel] = map(i, this.gradientPos, this.max_level, this.min_color[channel], this.max_color[channel]);
      }
      
      fill(c[0], c[1], c[2], transparency);
      int rect_width = int(this.size.x - this.spacingX*i*2);
      int rect_height = int(this.size.y - this.spacingY*i*2);
  
      rect(this.origin.x+i*this.spacingX+i*this.pos.x*this.spacingX, 
              this.origin.y+i*this.spacingY+(i*this.pos.y*this.spacingY), 
              rect_width, 
              rect_height);
    }
  }


  
  void checkBoundaries() {
    // If we are past the bounds of either axis, change the direction of the velocity
    if (pos.x > axisBounds[1] || pos.x < axisBounds[0]) {
      this.v.x *= -1.0;
    }
    if (pos.y > axisBounds[1] || pos.y < axisBounds[0]) {
      this.v.y *= -1.0;
    } 
  }
  
  void move() {
    this.pos.add(this.v);
    this.checkBoundaries();
  }
  
  void fade() {
    int color_pos_start = color_array_idx;
    int color_pos_end = (color_array_idx+1)%color_array.length;
        
    for (int i = 0; i < 3; i++) {
      this.min_color[i] = map(
          this.fade_counter, 
          0, this.fade_counter_max, 
          this.color_array[color_pos_start][i], this.color_array[color_pos_end][i]
      );
    }
    fade_counter++;
    if (fade_counter >= fade_counter_max) {
      color_array_idx = (color_array_idx+1)%color_array.length;
      print(color_array_idx, "\n");
      fade_counter = 0;
    }
  }


  void _fill(int r, int g, int b) {
    // Fill the window with a color 
    for (int i = 0; i < int(this.size.x); i++) {
        for (int j = 0; j < int(this.size.y); j++) {
            fill(r,g,b);
            rect(int(i+this.origin.x), int(j+this.origin.y), 1, 1);
        }
    }
  }

  void close() {

  }

    void shiftGradient(int direction) {
        if (direction==OPEN) {
            this.gradientPos=this.gradientPos+1;
        }
        else if (direction==CLOSE) {
            this.gradientPos=this.gradientPos-1;
        }
        else {
            println("direction doesn't exist");
        }

    }

  void updateLevels(int _num) {
    this.max_level = _num;
  }

  void updateSpacing(int _x, int _y) {
    this.spacingX = _x;
    this.spacingY = _y;
  }
  
  void handleMousePressed() {
    this.pos.x = (mouseX - width/2) / float(width);
    this.pos.y = (mouseY - height/2) / float(height);
    
    if (this.shapeMode == RECT) {
      this.shapeMode = ELLIPSE;
    }
    else {
      this.shapeMode = RECT;
    }    
  }
}


// class Ripple() {
//     int x;
//     int y; 

//     // Ripple() {

//     // }



// }