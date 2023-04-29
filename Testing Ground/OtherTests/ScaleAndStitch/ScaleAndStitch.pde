//Import Point class, important
import java.awt.Point; 

//Import Sound library. Important for NoteTrack to work
import processing.sound.*;

// name the PApplet master so we can refernce in other classes
public PApplet master = this;

//Create a PImage that will color the pixels around the mouse
PImage testImg1;
PImage testImg2;
PImage masterImg;

//Zero out mouse location variable to start
int mouseLoc = 0;
int boxNumber;

//Call the Box Array
ArrayList<Box> boxes;
ArrayList<PImage> currentArray = new ArrayList<PImage>(2);


void setup() {
    //Set size, 1280
    size(1000, 500, P2D);
    
    
    
    //Set number of boxes to spawn
    boxNumber = 60;
    
    //intialize the box array
    boxes = new ArrayList<Box>(boxNumber);
    
    //initialize the boxes
    for (int i = 0; i < boxNumber; i++) {
        Box tmpBox = new Box(int(random(width)), int(random(height)), 20, 20, 130);
        tmpBox.getCoord();
        tmpBox.loadNote();
        boxes.add(tmpBox);
    }
    
    //load the images to memory
    testImg1 = loadImage("250_img1.jpg");
    testImg2 = loadImage("250_img2.jpg");
    masterImg = createImage(testImg1.width * 4, testImg1.height * 2, RGB);
    
    //Put the images into an array
    currentArray.add(testImg1);
    currentArray.add(testImg2);
    
}

//Reset function for mouse click. Also randomizes letters
void mouseReleased() {
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).bx = int(random(width));
        boxes.get(i).by = int(random(height));
        boxes.get(i).letterNumber = int(random(65, 65 + 24));
        boxes.get(i).loadNote();
    }
}

void draw() {
    //Draw white circle around the mouse
    //copy/paste/adjust from "flashlight" Daniel Schiffman example
    //Not important, will be replaced with Kinect Image
    
    //Put in the Switching block with scaling implemented
    //Apply the MouseLight Effect
    //Apply the mirroring 
    //figure out how to fix the mirroring issues
    
    //Switching Block
    int k = 0;
    int image = 0;
    
    masterImg.loadPixels();
    
    for (int i = 0; i < masterImg.pixels.length; i++) {
        if (i == 0) {
            image = 0;
        } else if (i % (currentArray.get(image).width * 2) == 0) {
            if (image == 0) {
                image = 1;
                k -= currentArray.get(image).width;
            } else {
                image = 0;
                i += masterImg.width;
            }
        }
        if (k >= currentArray.get(image).pixels.length) {
            k = 0;
        }
        
        int i2 = i + 1;
        int i3 = i + width;
        int i4 = i2 + width;
        
        if (i + masterImg.width + 1 < masterImg.pixels.length) {
            masterImg.pixels[i] = currentArray.get(image).pixels[k];
            masterImg.pixels[i2] = currentArray.get(image).pixels[k];
            masterImg.pixels[i3] = currentArray.get(image).pixels[k];
            masterImg.pixels[i4] = currentArray.get(image).pixels[k];
            i++;
        }
        int mouseLoc = mouseX + mouseY * width;
        int mouseLoc2 = mouseLoc + 1;
        int mouseLoc3 = mouseLoc + width;
        int mouseLoc4 = mouseLoc2 + width;
        if (mouseLoc4 < masterImg.pixels.length) {
            masterImg.pixels[mouseLoc] = color(255);
            masterImg.pixels[mouseLoc2] = color(255);
            masterImg.pixels[mouseLoc3] = color(255);
            masterImg.pixels[mouseLoc4] = color(255);
        }
        k++;
    }
    masterImg.updatePixels();
    pushMatrix();
    scale( -1,1);
    image(masterImg, -masterImg.width,0);
    popMatrix();
    
    
    //Apply methods to each box in the array
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).lookUnder(masterImg);
        boxes.get(i).collisionPoint();
        boxes.get(i).collisionVector();
        boxes.get(i).edgeBounce();
        boxes.get(i).display();
    }
    
    // Print the framerate to the window for Performance check purposes. 
    textSize(50);
    text(frameRate, 100, 100);
    stroke(255);
    strokeWeight(10);
    line(110, 110, frameRate * 4, 110);
}