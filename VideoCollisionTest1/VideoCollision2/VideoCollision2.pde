import processing.video.*;
import java.awt.Point;

Movie colTest; //Pre-recorded Movie File

Box box;

boolean locked = false; //Mouse Locked indicator

void setup() {
    size(1280, 720);
    
    //Set up Movie Player, begin playing the file in the background
    colTest = new Movie(this, "BW_Collision.mov");
    colTest.loop();
    
    //Instantiate the box
    box = new Box(250,400, 20, 20, 175);
}

//Movie Event. Called every new frame
void movieEvent(Movie colTest) {
    colTest.read();
}

//Mouse Pressed/released booleans. Mostly for tests
void mousePressed() {
    locked = true;
}
void mouseReleased() {
    locked = false;
}


void draw() {
    image(colTest,0,0, width, height); // Draw the BG vid
    colTest.loadPixels();
    
    //Creating the lookunder window to see if it works
    box.lookUnder(colTest);
    
    //Attach the mouse, and draw the box. 
    box.attachMouse();
    box.display();
    
    fill(255);
    rect(10, 670, 40, 40);
    
    PImage u = colTest.get(box.bx, box.by, box.bW, box.bH);
    image(u, 20, 680);
    
    println("collision location is: " + box.collisionPoint());
}

