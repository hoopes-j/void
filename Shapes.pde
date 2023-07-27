class Circle {
    
    int x;
    int y;
    int r;
    float morphedRadius;

    color c;

    int numVertices;
    ArrayList<PVector> vertices;

    int frameCount = 0;
    int bpm;
    int beatCounter = 0;

    Circle(int _x, int _y, int _r, color _c) {
        this.x = _x;
        this.y = _y;
        this.r = _r;
        this.c = _c;

        this.numVertices = 20;
        this.vertices = new ArrayList<PVector>();
    }

    void draw(Boolean regen) {
        if (regen) {
            createVertices();
        }

        println("drawing");

        // ellipse(this.x, this.y, this.r, this.r);

        fill(this.c);
        beginShape();
        for (PVector pos : this.vertices) {
            vertex(this.x+pos.x,this.y+pos.y);
        }
        endShape(CLOSE);
    }

    void draw() {
        createVertices();

        println("drawing");

        // ellipse(this.x, this.y, this.r, this.r);

        fill(this.c);
        beginShape();
        for (PVector pos : this.vertices) {
            vertex(this.x+pos.x,this.y+pos.y);
        }
        endShape(CLOSE);

        frameCount++;
    }

    void createVertices() {
        float theta = 0;
        float deltaTheta = TAU/numVertices;
        this.vertices = new ArrayList<PVector>();
        for (int i = 0; i < numVertices; i++) {
            PVector _pos = new PVector(cos(theta), sin(theta));
            _pos.mult(this.r);
            this.vertices.add(_pos);
            theta += deltaTheta;
        }
    }

    void move(PVector vel) {
        this.x+=int(vel.x);
        this.y+=int(vel.y);
    }

    void updateColor(color _c) {
        this.c = _c;
    }

    void morph(float _amnt) {
        // morphs each vertex using perlin noise based on an amount from 0-1


        float theta = 0;
        float deltaTheta = TAU/numVertices;
        this.vertices = new ArrayList<PVector>();
        for (int i = 0; i < numVertices; i++) {
            PVector _pos = new PVector(cos(theta), sin(theta));
            float n = noise(i*.001, frameCount+0.001)*_amnt;
            float radius = n*this.r;
            println(radius);
            _pos.mult(radius);
            this.vertices.add(_pos);
            theta += deltaTheta;
        }
    }

    void beat() {
        beatCounter++;
        if (beatCounter==0) {
            beatCounter = 0;
        }
        if (beatCounter>=bpm) {
            println("beat");
            beatCounter=0;
            // this.colorB
        }

    }




}