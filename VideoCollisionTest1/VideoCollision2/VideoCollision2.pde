import processing.video.*;
import java.awt.Point; 

Movie colTest; //Pre-recorded Movie File

Box box; //box object [will become a letter later]

boolean locked = false; //Mouse Locked indicator, will be deleted after testing

void setup() {
    size(1280, 720);
    
    //Set up Movie Player, begin playing the file in the background
    colTest = new Movie(this, "BW_Collision.mov");
    colTest.loop();
    
    //Instantiate the box
    box = new Box(250,400, 20, 20, 175);
    box.getCoord();
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
    
    //Attach the mouse, and draw the box. 
    box.attachMouse();
    box.display();
    
    //Print order for collision, will be deleted after testing
    if (box.collisionPoint() != null) {
        println("the collision point is: " + box.collisionPoint());
    }
}