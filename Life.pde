

class Life {
    
    PVector origin;
    PVector dist;


    Circle ballM;
    Circle ballF;

    int ballRadius;
    float ballSpeed = 0.5;
    Boolean ballsMorphing = false;
    Boolean ballsBeating = false;
    Boolean bloodAnimation = false;

    int frameCount;
    boolean running;


    Life(PVector _origin, PVector _dist) {
        this.origin = _origin;
        this.dist = _dist;

        this.ballRadius = 3;
    }  

    void begin() {
        this.frameCount = 0;
        this.running = true;
        
        PVector posF = this.origin.copy().add(this.dist.copy());
        PVector posM = this.origin.copy().sub(this.dist.copy());

        ballF = new Circle(int(posF.x), int(posF.y), this.ballRadius, color(255,0,0));
        ballM = new Circle(int(posM.x), int(posM.y), this.ballRadius, color(0,0,255));

        this.ballsMorphing = true;
    }  


    void draw() {

        if (ballF.x == ballM.x && ballF.y == ballM.y && ballsMorphing) {
            ballsMorphing = false;
            color mixedColor = this.ballM.c + this.ballF.c;
            this.ballM.updateColor(mixedColor);
            this.ballF.updateColor(mixedColor);
        }

        PVector ballVelocity = new PVector(1,1);
        if (ballsMorphing) {
            ballM.move(ballVelocity);
            ballF.move(ballVelocity.mult(-1));

            ballF.draw();
            ballM.draw();
        }
        else {
            ballF.beat();
            ballM.beat();
            ballF.draw(false);
            ballM.draw(false);
        }



        frameCount++;
    }
}