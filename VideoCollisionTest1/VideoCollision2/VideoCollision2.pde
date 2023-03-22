import processing.video.*;
import java.awt.Point; 

Movie colTest; //Pre-recorded Movie File
Point zeroPoint;

Box box; //box object [will become a letter later]

boolean locked = false; //Mouse Locked indicator, will be deleted after testing

void setup() {
    size(1280,720);
    
    //Set up Movie Player, begin playing the file in the background
    colTest = new Movie(this, "BW_Collision.mov");
    colTest.loop();
    
    //Instantiate the box
    box = new Box(250,400, 20, 20, 175);
    
    // Populate coordinate array
    box.getCoord();
    zeroPoint = new Point(0,0);
}

// Movie Event.Called every new frame
void movieEvent(Movie colTest) {
    colTest.read();
}

// Mouse Pressed / released booleans.Mostly for tests
void mousePressed() {
    locked = true;
}
void mouseReleased() {
    locked = false;
}


void draw() {
    image(colTest,0,0, width, height); // Draw the BG vid
    colTest.loadPixels();
    
    //populate the px Array
    box.lookUnder(colTest);
    
    //Attach the mouse, and draw the box. 
    box.attachMouse();
    box.display();
    
    //Testing windowfor lookUnder, deleted after testing
    fill(255);
    rect(10, 670, 40, 40);
    PImage u = colTest.get(box.bx, box.by, box.bW, box.bH);
    image(u, 20, 680);
    box.collisionPoint();
    
    //Print collision point, will be deleted after testing
    if (box.collisionPoint() != zeroPoint) {
        println("the collision point is: [" + (box.collisionPoint().x + "," + (box.collisionPoint()).y) + "]");
    }
    
    box.collisionVector();
}