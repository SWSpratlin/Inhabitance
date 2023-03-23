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
float maxDepth = 900;

Kinect kinect;

ArrayList<Box> boxes;

Box box; //box object [will become a letter later]

boolean locked = false; //Mouse Locked indicator, will be deleted after testing

void setup() {
    size(640,480);
    
    //KInect initialization
    kinect = new Kinect(this);
    
    kinect.initDepth();
    
    boxes = new ArrayList<Box>(10);
    
    //Populate coordinate array for each box
    boxes.forEach(Box :: getCoord);
    
    //Blank image
    depthImg = new PImage(kinect.width, kinect.height);
    
    //ZeroPoint for reference
    zeroPoint = new Point(0,0);
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
    image(depthImg, 0, 0);
    
    boxes.forEach(Box ::  display);
    for (int i = 0; i < boxes.size(); i++) {
        Box tempBox = (Box)boxes.get(i);
        tempBox.lookUnder(depthImg);
    }
    boxes.forEach(Box ::  collisionVector);
    
}