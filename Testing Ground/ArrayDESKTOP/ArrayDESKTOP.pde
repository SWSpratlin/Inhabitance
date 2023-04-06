//This is the Collision Test for just the Pre-Recorded Video, NOT the Kinect. 
//Kinect version is in VideoCollision2

import processing.video.*;
import processing.sound.*;
import java.awt.Point; 

Movie colTest; //Pre-recorded Movie File
Point zeroPoint;

ArrayList<Box> boxes; //Testing for box arrays

Box box; //box object

boolean locked = false; //Mouse Locked indicator, will be deleted after testing

void setup() {
    size(1280, 720);
    surface.setResizable(true);
    
    boxes = new ArrayList<Box>(10);
    
    for (int i = 0; i < 15; i++) {
        Box tmpBox = new Box(int(random(width)), int(random(height)), 15, 15, 0);
        tmpBox.getCoord();
        boxes.add(tmpBox);
    }
    
    //Set up Movie Player, begin playing the file in the background
    colTest = new Movie(this, "BW_Collision_Three.mov");
    colTest.loop();
    
    zeroPoint = new Point(0,0);
}

// Movie Event.Called every new frame
void movieEvent(Movie colTest) {
    colTest.read();
    
}

void mouseReleased() {
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).bx = int(random(width));
        boxes.get(i).by = int(random(height));
    }
}

void draw() {
    image(colTest,0,0, width, height); // Draw the BG vid
    colTest.loadPixels();
    
    
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).lookUnder(colTest);
        boxes.get(i).collisionPoint();
        boxes.get(i).collisionVector();
        boxes.get(i).edgeBounce();
        boxes.get(i).display();
    }
}