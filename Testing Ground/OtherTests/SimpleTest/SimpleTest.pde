import java.awt.Point; 
boolean locked = false;
//Create a PImage that will color the pixels around the mouse
PImage mouseBox;
int mouseLoc = 0;
//Call the Box class
Box box;
void setup() {
    //Set size, 1280
    size(1280, 720);
    
    //set BG color
    background(0);
    
    //initialize the box
    box = new Box(500, 500, 40, 40, 255);
    box.getCoord();
    
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
    
    box.lookUnder(mouseBox);
    box.collisionPoint();
    box.collisionVector();
    box.edgeBounce();
    box.display();
}