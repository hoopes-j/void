class Hole {
    PVector pos;
    PVector size;
    PVector nextSize;

    // New animations
    PVector nextPos;

    Boolean closed;
    Boolean active;


    // ANIMATION FLAG
    int INACTIVE = -1;
    int SCALING_DOWN = 0;
    int MOVING = 1;
    int SCALING_UP = 2;
    int WAIT = 3;
    int stage = INACTIVE;


    // Fading animations
    Boolean fadeIn = false;
    Boolean fadeOut = false;

    int fadeCount = 0;
    int fadeTimeMS = 500;
    int fadeTimeFrames;

    int fadeOutWaitCount = 0;
    int fadeOutWaitFrames;
    int fadeOutWaiting;

    // Movement animations
    Boolean moving = false;

    int moveCount = 0;
    int moveTimeMS = 500;
    int moveTimeFrames;

    boolean moveWait = false;
    int moveWaitTimeFrames;

    // Size animations
    Boolean changingSize = false;

    int sizeCount = 0;
    int sizeTimeMS = 500;
    int sizeTimeFrames;

    int sizeWaitCount = 0;
    int sizeWaitFrames;
    boolean sizeOutWaiting = false;
    int nextSizeTimeFrames;
    PVector nextNextSize;

    PVector moveSize = new PVector(1,1);

    // Echo animations
    ArrayList<PVector> echoes;

    Boolean activeAnimation;

    int waitCounter = 0;
    int waitTimeFrames;


    Hole() {
        this.pos = new PVector(random(40), random(22));
        this.nextPos = this.pos.copy();
        this.size = new PVector(1,1);

        this.fadeTimeFrames = toFrames(fadeTimeMS);
        this.moveTimeFrames = toFrames(moveTimeMS);
        this.sizeTimeFrames = toFrames(sizeTimeMS);
        this.waitTimeFrames = toFrames(5000);
        print(this.sizeTimeFrames);

        echoes = new ArrayList<PVector>();
        
        this.closed = false;
        this.activeAnimation = false;
    }

    void close() {
        this.size = new PVector(0,0);
        this.closed = true;
    }

    void draw() {


        color c = color(0,0,0);

        // Color Animation for fading
        if (fadeIn) {
            float fadeAmount = map(fadeCount, 0, fadeTimeFrames, 255, 0);
            c = color(fadeAmount);
        }
        else if (fadeOut) {
            float fadeAmount = map(fadeCount, 0, fadeTimeFrames, 0, 255);
            c = color(fadeAmount); 
        }
        else if (this.closed) {
            c = color(255,255,255);
        }

        // Animation Position
        PVector currPos = this.pos.copy();
        if (stage==MOVING) {
            println("moving");
            float movePos = float(moveCount)/float(moveTimeFrames);
            currPos = PVector.lerp(this.pos, this.nextPos, movePos);
        }

        // Size Animation
        PVector currSize = this.size.copy();
        if (stage==SCALING_DOWN) {
            float animationPos = float(sizeCount)/float(sizeTimeFrames);
            // println(animationPos);
            currSize = PVector.lerp(this.size, this.moveSize, animationPos);
        } 
        else if (stage==SCALING_UP) {
            println("scaling up");
            float animationPos = constrain(float(sizeCount)/float(sizeTimeFrames),0,1);
            println(animationPos);
            println("frame time: ", sizeTimeFrames);
            currSize = PVector.lerp(this.moveSize, this.size, animationPos);

        }
        if (stage==MOVING) {
            currSize = this.moveSize.copy();
        }

        facade.drawRect(currPos, currSize, c);

        if (fadeOut || fadeIn) {
            fadeCount++;
            if (fadeCount>=fadeTimeFrames) {
                println("done");
                if (fadeOut) {
                    closed = true;
                }
                fadeOut = false;
                fadeIn = false;
                fadeCount = 0;
            }
        }
        if (stage==MOVING) {
            moveCount++;
            if (moveCount>=moveTimeFrames) {
                println("done moving");
                this.pos = this.nextPos.copy();
                moveCount = 0;
                incrementStage();
                this.size = this.nextSize.copy();
            }
        }
        else if (stage==SCALING_DOWN) {
            sizeCount++;
            if (sizeCount>=sizeTimeFrames) {
                println("done changing size");
                sizeCount = 0;
                incrementStage();
            }
        }
        else if (stage==SCALING_UP) {
            sizeCount++;
            if (sizeCount>=sizeTimeFrames) {
                println("done scaling up");
                sizeCount = 0;
                incrementStage();
            }
        }
        else if (stage==WAIT) {
            waitCounter++;
            if (waitCounter>=waitTimeFrames) {
                print("done waiting");
                stage=INACTIVE;
                waitCounter=0;
            }
        }
        // if (this.moveWait) {
        //     moveCount++;
        //     if (moveCount>=moveWaitTimeFrames) {
        //         println("startin quesed move");
        //         moveCount = 0;
        //         this.moveWait = false;
        //         this.moving = true;
        //     }
        // }
        // if (this.sizeOutWaiting) {
        //     sizeWaitCount++;
        //     if (sizeWaitCount>=sizeWaitFrames) {
        //         println("starting queued scale");
        //         sizeCount=0;
        //         sizeWaitCount=0;
        //         this.sizeOutWaiting = false;
        //         this.changingSize = true;
        //         this.nextSize = this.nextNextSize.copy();
        //         this.sizeTimeFrames = this.nextSizeTimeFrames;
        //         print(this.nextSize);
        //     }
        // }
        if (echoes.size() > 0) {
            for (PVector echo: echoes) {
                PVector sizeDiff = subVector(currSize, echo);
                PVector echoPos = currPos.copy();
                echoPos.x += sizeDiff.x/2;
                echoPos.y += sizeDiff.y/2;

                float area = map(vecArea(echo), 0, vecArea(currSize),0,255);
                color echoColor = color(area);
                facade.rectOutline(echoPos, echo, echoColor);
            }
            updateEchoes();
        }
    }





    void fadeIn() {
        closed = false;
        this.fadeIn = true;
        this.activeAnimation = true;
    }

    void fadeOut() {
        this.fadeOut = true;
        this.activeAnimation = true;
    }

    void move(PVector _newPos) {
        this.nextPos = _newPos;
        this.moving = true;
    }

    void echo() {
        PVector newEcho = this.size.copy();
        echoes.add(newEcho);
    }

    void updateEchoes() {
        for (int i = 0; i < echoes.size(); i++) {
            PVector echo = echoes.get(i);
            echo.x -= 1;
            echo.y -= 1;
            if (echo.x <= 0 || echo.y <= 0) {
                echoes.remove(i);
            }
            else {
                echoes.set(i, echo);
            }
        }
    }

    void scale(PVector _newSize) {
        this.nextSize = _newSize;
        this.changingSize = true;
    }

    void scale(PVector _newSize, int _timeMS) {
        this.nextSize = _newSize;
        this.sizeTimeFrames = toFrames(_timeMS);
        this.changingSize = true;
    }

    boolean isAnimating() {
        return this.fadeOut || this.fadeIn || this.changingSize || this.moving;
    }

    void waitToMove(PVector _pos,int _timeMS, int _waitMS) {
        this.moveTimeFrames = toFrames(_timeMS);
        this.moveWait = true;
        this.moveWaitTimeFrames = toFrames(_waitMS);
        this.nextPos = _pos.copy();
    }


    void waitToScale(PVector _size, int _timeMS, int _waitMS) {
        this.sizeOutWaiting = true;
        this.sizeWaitFrames = toFrames(_waitMS);
        this.nextSizeTimeFrames = toFrames(_timeMS);
        this.nextNextSize = _size.copy();
    }


    void travel(PVector _newPos, PVector _newSize) {
        this.stage = SCALING_DOWN;
        this.nextPos = _newPos;
        this.nextSize = _newSize.copy();
        // this.nextSize = this.moveSize;
    }

    void setScaleTime(int _ms) {
        this.sizeTimeFrames = toFrames(_ms);
    }

    void setWaitTime(int _ms) {
        this.waitTimeFrames = toFrames(_ms);
    }
    void setWaitTime(float _ms) {
        this.waitTimeFrames = toFrames(int(_ms));
    }

    boolean inactive() {
        return stage==INACTIVE;
    } 

    void incrementStage() {
        stage++;
        println("next stage: ", stage);
    }
}
