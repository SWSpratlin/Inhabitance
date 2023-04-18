//This is the KINECT version 
import processing.sound.*;
import java.awt.Point; 
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

public PApplet master = this;

// Depth image
PImage depthImg;
PImage masterImg;

ArrayList<int[]> currentArray = new ArrayList<int[]>();
int[] rawDepth1;
int[] rawDepth2;

//Depth Thresholds
float minDepth =  300;
float maxDepth = 800;

//Kinects to Interate through
ArrayList<Kinect> kinects;

//Boxes and Notes to assign
ArrayList<Box> boxes;
ArrayList<String> notes;

//Number of Boxes to spawn
int boxNumber = 40;

//Device variables
int deviceIndex = 0;
int numDevices = 0;

void setup() {
    size(1280,480);
    
    //Populate Note Array
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
    numDevices = Kinect.countDevices();
    println(numDevices);
    
    kinects = new ArrayList<Kinect>();
    //Iterate through as many Kinects as are connected
    for (int i = 0; i < numDevices; i++) {
        Kinect tempKinect = new Kinect(this);
        tempKinect.activateDevice(i);
        tempKinect.initDepth();
        kinects.add(tempKinect);
    }
    
    //Initialize Array
    boxes = new ArrayList<Box>(boxNumber);
    
    //Create Boxes
    for (int i = 0; i < boxNumber; i++) {
        Box tmpBox = new Box(int(random(width)), int(random(height)), 15, 15, 150);
        tmpBox.getCoord();
        boxes.add(tmpBox);
    }
    
    //RawDepth Array. Changes every time the kinect it switched.
    rawDepth1 = kinects.get(0).getRawDepth();
    rawDepth2 = kinects.get(1).getRawDepth();
    currentArray.add(rawDepth1);
    currentArray.add(rawDepth2);
    
    //Blank image
    //depthImg = new PImage(width, height);
    masterImg = createImage(width, height, RGB);
}

//Reset Function, will work out a different method later
void mouseReleased() {
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).bx = int(random(width));
        boxes.get(i).by = int(random(height));
    }
}

//Calibration Controls
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
    //Load both Pixel Arrays
    masterImg.loadPixels();
    
    //Interating Variables
    int k = 0;
    int image = 0;
    
    //RawDepth Array. Changes every time the kinect it switched.
    rawDepth1 = kinects.get(0).getRawDepth();
    rawDepth2 = kinects.get(1).getRawDepth();
    
    //Combo Loop
    for (int i = 0; i < masterImg.pixels.length; i++) {
        
        //Set up the current array at the start of the loop
        if (i ==  0) {
            image = 0;
            
            // Modulus to switch the array every other time. 
        } else if (i % kinects.get(image).width == 0) {
            
            // check which array is selected
            if (image == 0) {
                
                // if it's 0, switch images that we're indexing
                image = 1;
                
                /* Subtract the width of the image from K so K iterates over the same
                set of numbers twice each time. Use [k] to coontrol each image individually
                
                Only has to go back when going to the second image (one on the right) otherwise
                it can just keep going. 
                */
                if (k > kinects.get(image).width) {
                    k -= kinects.get(image).width;
                }
                
            } else {
                
                // don't have to reset K when coming back to the first image
                image = 0;
                
            }
        }
        
        if (k >= currentArray.get(image).length) {
            k = 0;
        }
        
        //Assign depth values to Master image
        if (currentArray.get(image)[k] >= minDepth && currentArray.get(image)[k] <= maxDepth) {
            masterImg.pixels[i] = color(255);
        } else {
            masterImg.pixels[i] = color(0);
        }
        
        k++;
    }
    
    //Draw the thresholded image
    masterImg.updatePixels();
    image(masterImg, 0,0);
    
    //Physics for Boxes
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).lookUnder(masterImg);
        boxes.get(i).display();
        boxes.get(i).edgeBounce();
        boxes.get(i).collisionPoint();
        boxes.get(i).collisionVector();
    }
    
    // //debugging purposes
    // fill(255);
    // textSize(20);
    // text(frameRate, 10, 10);
    // stroke(255);
    // strokeWeight(10);
    // line(11, 11, frameRate * 4, 11);
}