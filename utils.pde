


int toFrames(float _ms) {

    return int((_ms/1000)*frameRate);

}


void pixel(int x, int y) {
    rect(x,y,1,1);
}

void pixel(int x, int y, color c) {
    fill(c);
    rect(x,y,1,1);
}


void pixel(float x, float y) {
    rect(x,y,1,1);
}


PVector addVector(PVector a, PVector b) {
    PVector _tmp = new PVector(a.x+b.x,a.y+b.y);
    return _tmp;
}

PVector subVector(PVector a, PVector b) {
    PVector _tmp = new PVector(a.x-b.x,a.y-b.y);
    return _tmp;
}

float vecArea(PVector a) {
    return a.x*a.y;
}