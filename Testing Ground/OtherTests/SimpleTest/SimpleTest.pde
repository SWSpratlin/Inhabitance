//Import Point class, important
import java.awt.Point; 

//Create a PImage that will color the pixels around the mouse
PImage mouseBox;

//Zero out mouse class to start
int mouseLoc = 0;

//Call the Box Array
ArrayList<Box> boxes;

void setup() {
    //Set size, 1280
    size(1280,720);
    
    //set BG color
    background(0);
    
    //intialize the box array
    boxes = new ArrayList<Box>(20);
    
    int boxNumber = 20;
    //initialize the boxes
    for (int i = 0; i < boxNumber; i++) {
        Box tmpBox = new Box(int(random(width)), int(random(height)), 15, 21, 0);
        tmpBox.getCoord();
        boxes.add(tmpBox);
    }
    
    //initialize the PImage
    mouseBox = new PImage(width, height);
    mouseBox.loadPixels();
    for (int i = 0; i < mouseBox.pixels.length; i++) {
        mouseBox.pixels[i] = color(180);
    }
    mouseBox.updatePixels();
}

void draw() {
    image(mouseBox, 0,0);
    
    //THIS IS NOT PART OF MY QUESTION, PRODUCES A WHITE
    //CIRCLE THAT FOLLOWS THE MOUSE. FOR TESTING PURPOSES
    //ONLY. PLEASE DON'T TROUBLESHOOT THIS
    mouseBox.loadPixels();
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int loc = x + y * width;
            float b = alpha(mouseBox.pixels[loc]);
            float maxDist = 50;
            float d = dist(x,y,mouseX,mouseY);
            float adjustBrightness = 255 * (maxDist - d) / maxDist;
            b *= adjustBrightness;
            b = constrain(b, 0, 255);
            color c = color(b);
            mouseBox.pixels[loc] = c;
        }
    }
    mouseBox.updatePixels();
    
    //Apply methods to each box in the array
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).lookUnder(mouseBox);
        boxes.get(i).collisionPoint();
        boxes.get(i).collisionVector();
        boxes.get(i).edgeBounce();
        boxes.get(i).display();
    }
    
}