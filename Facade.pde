int MOVE = 0;
int SCALE = 1;
int FADE = 2;


class Facade {

    int boundX = 40;
    int boundY = 22;

    int numWindows;

    color[][] pixels;
    
    ArrayList<Hole> holes;
    Hole mainHole;

    int frameCount = 0;

    int startCount = 0;
    int startTimeMS = 5000;
    int startTimeFrames;

    ArrayList<Integer> movementIntervals;
    ArrayList<Integer> aniCounters;

    boolean startAnimation = false;

    color backgroundColor;

    Facade(int _numWindows) {
        this.numWindows = _numWindows;
        pixels = new color[boundX][boundY];
        holes = new ArrayList<Hole>();
        movementIntervals = new ArrayList<Integer>();
        aniCounters = new ArrayList<Integer>();

        backgroundColor = color(255);

        startTimeFrames = toFrames(startTimeMS);
    }

    void startupFade() {

    }

    void fill() {

        for (int i = 0; i < boundX; i++) {
            for (int j = 0; j < boundY; j++) {
                this.pixels[i][j] = backgroundColor;
            }
        }

    }

    void addRandomHole() {
        Hole _hole = new Hole();
        holes.add(_hole);
    }

    void addHole(int x, int y) {
        Hole _hole = new Hole();
        _hole.pos = new PVector(x,y);
    }

    void addHole(Hole hole) {
        holes.add(hole);
    }

    void draw() {
        this.fill();

        for (Hole hole : this.holes) {
            hole.draw();
        }
        
        // Draw main window;
        if (mainHole!=null) {
            mainHole.draw();
        }

        for (int i = 0; i < boundX; i++) {
            for (int j = 0; j < boundY; j++) {
                pixel(i,j,pixels[i][j]);
            }
        }
    }

    PVector generateNewPos(PVector oldPos, float moveAmount) {
        PVector velocity = new PVector(
            random(moveAmount)-moveAmount/2,
            random(moveAmount)-moveAmount/2
        );

        if (addVector(oldPos, velocity).x < 0) {
            velocity.x*=-1;
        }
        else if (addVector(oldPos, velocity).y < 0) {
            velocity.y*=-1;
        }
        PVector newPos = addVector(oldPos, velocity);

        return newPos;
    }

    void animateMultipleWindows() {

        while (holes.size()<this.numWindows) {
            Hole hole = new Hole();
            hole.size = new PVector(5,5);

            // hole.pos 
            hole.fadeIn();
            this.holes.add(hole);
            // this.movementIntervals.add(0);
            // this.aniCounters.add(0);
            // movementInterval = random()
        }


        for (int i = 0; i < holes.size(); i++) {
            Hole hole = this.holes.get(i);
            if (!hole.isAnimating()) {
                PVector newPos = generateNewPos(hole.pos, 20);
                float l = random(3)+5;
                PVector newSize = new PVector(l,l+3);
                if (hole.inactive()) {
                    hole.setScaleTime(500);
                    hole.setWaitTime(3000);
                    hole.travel(newPos, newSize); 
                }
            }
            else {
            } 
        }

    }

    void animate() {

        animateMultipleWindows();
    }

    int wrapX(int _x) {
        if (_x>=0) {
            return int(_x%this.boundX);
        }
        else {
            println("WARNING: X IS NEGATIVE");
            int _tmp = 0;
            while (_tmp<0) {
                _tmp = boundX+_x;
            }
            return _tmp;
        }
    }
    int wrapX(float _x) {
        return int(_x%this.boundX);
    }
    int wrapY(int _y) {

        if (_y>=0) {
            return int(_y%this.boundY);
        }
        else {
            int _tmp = 0;
            while (_tmp<0) {
                _tmp = boundY+_y;
            }
            return _tmp;
        }

    }


    void drawRect(int x, int y, int w, int h, color c) {
        for (int i = 0; i < w; i++) {
            for (int j = 0; j < h; j++) {
                int _x = facade.wrapX(i+x);
                int _y = facade.wrapY(j+y);
                facade.pixels[_x][_y] = c;
            }
        } 
    }

    void drawRect(PVector _pos, PVector _size, color c) {
        // for (int i = 0; i < int(currSize.x); i++) {
        //     for (int j = 0; j < int(currSize.y); j++) {
        //         int _x = facade.wrapX(i+int(currPos.x));
        //         int _y = facade.wrapY(j+int(currPos.y));
        //         facade.pixels[_x][_y] = c;
        //     }
        // }
        for (int i = 0; i < int(_size.x); i++) {
            for (int j = 0; j < int(_size.y); j++) {
                int _x = facade.wrapX(i+int(_pos.x));
                int _y = facade.wrapY(j+int(_pos.y));
                if (_y < 0){
                    println("y out of range!!!!");
                    println(_pos.x, _pos.y, _size.x, _size.y);
                }
                if (_x < 0) {
                    println("x out of range!!!!");
                    println(_pos.x, _pos.y, _size.x, _size.y);
                }
                facade.pixels[_x][_y] = c;
            }
        }
    }

    void rectOutline(PVector _pos, PVector _size, color c) {

        int x =int(_pos.x);
        int y =int(_pos.y);
        int w =int(_size.x);
        int h =int(_size.y);

        for (int i = 0; i < w; i++) {
            for (int j = 0; j < h; j++) {

                int _x = facade.wrapX(i+x);
                int _y = facade.wrapY(j+y);

                if (_x == x || _y == y || _x == x+w-1 || _y == y+h-1) {
                    facade.pixels[_x][_y] = c;
                }
            }
        }
    }


}
