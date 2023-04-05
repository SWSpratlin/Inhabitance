//This is the KINECT version, DOES NOT WORK. For testing see
//the iteration in Video Collision 3 folder

import processing.video.*;
import java.awt.Point; 

//Expeimenting with Kinect Interaction
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Point zeroPoint;

// Depth image
PImage depthImg;
float minDepth =  300;
float maxDepth = 800;

Kinect kinect;

ArrayList<Box> boxes;

//Box object spawns a letter
Box box;

boolean locked = false; //Mouse Locked indicator, will be deleted after testing

void setup() {
    size(640,480);
    
    //KInect initialization
    kinect = new Kinect(this);
    
    kinect.initDepth();
    
    boxes = new ArrayList<Box>(10);
    
    for (int i = 0; i < 15; i++) {
        Box tmpBox = new Box(int(random(width)), int(random(height)), 15, 15, 150);
        tmpBox.getCoord();
        boxes.add(tmpBox);
    }
    
    //Blank image
    depthImg = new PImage(width, height);
    
    //ZeroPoint for reference
    zeroPoint = new Point(0,0);
}

void mouseReleased() {
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).bx = int(random(width));
        boxes.get(i).by = int(random(height));
    }
}

void keyPressed() {
    if (keyCode == RIGHT) {
        maxDepth += 50;
    }
    if (keyCode == LEFT) {
        maxDepth -= 50;
    }
    if (keyCode == UP) {
        minDepth += 50;
    }
    if (keyCode == DOWN) {
        minDepth -= 50;
    }
}

void draw() {
    
    image(kinect.getDepthImage(), 0, 0);
    
    depthImg.loadPixels();
    
    //Threshold the depth image
    int[] rawDepth = kinect.getRawDepth();
    for (int i = 0; i < rawDepth.length; i++) {
        if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
            depthImg.pixels[i] = color(255);
        } else {
            depthImg.pixels[i] = color(0);
        }
    }
    
    //Draw the thresholded image
    depthImg.updatePixels();
    image(depthImg, 0, 0, width, height);
    
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).lookUnder(depthImg);
        boxes.get(i).display();
        boxes.get(i).edgeBounce();
        boxes.get(i).collisionPoint();
        boxes.get(i).collisionVector();
    }
    
}