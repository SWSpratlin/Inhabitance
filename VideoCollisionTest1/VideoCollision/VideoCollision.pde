//import processing.video.*;
//import processing.sound.*;


//Movie mov;

public boolean locked = false;

PShape box;

void setup() {
    size(1440, 1080);
    background(0);
    surface.setTitle("Video Collision Test");
    //mov = new Movie(this, "BW_Collision.mov");
    
    box = createShape(RECT, 100, 100, 50,50);
    box.setStroke(color(255));
    box.setFill(color(200));
}

void draw() {
    background(0);
    
    shape(box);
    
    if (locked && box.contains(mouseX,mouseY)) {
        translate(mouseX,mouseY);
    }
}

void mousePressed() {
    locked = true;
}

void mouseRelease() {
    locked = false;
}