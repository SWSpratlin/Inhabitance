//This is the KINECT version 
import processing.sound.*;
import java.awt.Point; 
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

public PApplet master = this;

// Depth image
PImage depthImg;
float minDepth =  300;
float maxDepth = 800;

Kinect kinect;

ArrayList<Box> boxes;
ArrayList<String> notes;

void setup() {
    size(640,480);
    
    notes = new ArrayList<String>();
    notes.add("A__1.wav");
    notes.add("B__1.wav");
    notes.add("C__1.wav");
    notes.add("D__1.wav");
    notes.add("E__1.wav");
    notes.add("F__1.wav");
    notes.add("G__1.wav");
    notes.add("H__1.wav");
    notes.add("I__1.wav");
    notes.add("J__1.wav");
    notes.add("K__1.wav");
    notes.add("L__1.wav");
    notes.add("M__1.wav");
    notes.add("N__1.wav");
    notes.add("O__1.wav");
    notes.add("P__1.wav");
    notes.add("Q__1.wav");
    notes.add("R__1.wav");
    notes.add("S__1.wav");
    notes.add("T__1.wav");
    notes.add("U__1.wav");
    notes.add("V__1.wav");
    notes.add("W__1.wav");
    notes.add("X__1.wav");
    notes.add("Y__1.wav");
    notes.add("Z__1.wav");
    
    //KInect initialization
    kinect = new Kinect(this);
    
    kinect.initDepth();
    
    boxes = new ArrayList<Box>(10);
    
    for (int i = 0; i < 30; i++) {
        Box tmpBox = new Box(int(random(width)), int(random(height)), 15, 15, 150);
        tmpBox.getCoord();
        boxes.add(tmpBox);
    } //calforentry
    
    //Blank image
    depthImg = new PImage(width, height);
}

void mouseReleased() {
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).bx = int(random(width));
        boxes.get(i).by = int(random(height));
    }
}

void keyPressed() {
    if (keyCode == RIGHT) {
        maxDepth += 10;
    }
    if (keyCode == LEFT) {
        maxDepth -= 10;
    }
    if (keyCode == UP) {
        minDepth += 10;
    }
    if (keyCode == DOWN) {
        minDepth -= 10;
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
    
    //debugging purposes
    fill(255);
    textSize(20);
    text(frameRate, 10, 10);
    stroke(255);
    strokeWeight(10);
    line(11, 11, frameRate * 4, 11);
    
}