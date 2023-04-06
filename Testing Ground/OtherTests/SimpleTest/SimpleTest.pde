import java.awt.Point; 
boolean locked = false;
//Create a PImage that will color the pixels around the mouse
PImage mouseBox;

//Call the Box class
Box box;
void setup() {
    //Set size, 1280
    size(1280, 720);
    
    //set BG color
    background(0);
    
    //Make the window resizable
    surface.setResizable(true);
    
    //initialize the box
    box = new Box(500, 500, 40, 40, 255);
    box.getCoord();
    
    //initialize the PImage
    mouseBox = new PImage(width, height);
}

void draw() {
    
    mouseBox.loadPixels();
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int loc = x + y * width;
            
        }
    }
    
}






