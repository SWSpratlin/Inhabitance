//Import Point class, important
import java.awt.Point; 
//Import Sound library. Important for NoteTrack to work
import processing.sound.*;

// name the PApplet master so we can refernce in other classes
public PApplet master = this;

//Create a PImage that will color the pixels around the mouse
PImage mouseLight;

//Zero out mouse location variable to start
int mouseLoc = 0;

//Call the Box Array
ArrayList<Box> boxes;

void setup() {
    //Set size, 1280
    size(1280, 480);
    
    //set BG color
    background(0);
    
    //Set number of boxes to spawn
    int boxNumber = 40;
    
    //intialize the box array
    boxes = new ArrayList<Box>(boxNumber);
    
    //initialize the boxes
    for (int i = 0; i < boxNumber; i++) {
        Box tmpBox = new Box(int(random(width)), int(random(height)), 20, 20, 130);
        tmpBox.getCoord();
        boxes.add(tmpBox);
    }
    
    //initialize the mouseLight PImage
    mouseLight = new PImage(width, height);
    mouseLight.loadPixels();
    for (int i = 0; i < mouseLight.pixels.length; i++) {
        mouseLight.pixels[i] = color(0);
    }
    mouseLight.updatePixels();
}

//Reset function for mouse click. Also randomizes letters
void mouseReleased() {
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).bx = int(random(width));
        boxes.get(i).by = int(random(height));
        boxes.get(i).letterNumber = int(random(65, 65 + 24));
    }
}

void draw() {
    //Draw white circle around the mouse
    //copy/paste/adjust from "flashlight" Daniel Schiffman example
    //Not important, will be replaced with Kinect Image
    image(mouseLight, 0,0);
    mouseLight.loadPixels();
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int loc = x + y * width;
            float b = alpha(mouseLight.pixels[loc]);
            float maxDist = 50;
            float d = dist(x,y,mouseX,mouseY);
            float adjustBrightness = 255 * (maxDist - d) / maxDist;
            b *= adjustBrightness;
            b = constrain(b, 0, 255);
            color c = color(b);
            mouseLight.pixels[loc] = c;
        }
    }
    mouseLight.updatePixels();
    
    //Apply methods to each box in the array
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).lookUnder(mouseLight);
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