// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

// Basic example of controlling an object with the mouse (by attaching a spring)

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import processing.sound.*;
import SimpleOpenNI.*;
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;
//Importing a shit load of libraries for both physics and Kinect integration

public PApplet master = this;

// A reference to our box2d world
Box2DProcessing box2d;

// A list we'll use to track fixed objects
ArrayList boundaries;

//A list we'll use to load sound files into the Sound Class
ArrayList sounds;

// Box Objects
// TODO decide how many need to be loaded into the app, and 
// place them into an array.
// This might get long, so maybe figure out a way to shorten it? Reference MultiKinect
Box box;
Box box2;

// Call Sound class here so it is accessible in both Setup and Draw
Sound note1;
Sound note2;

// Serves two purposes. Sets gravity to zero to allow freedom of movement
// Acts as a Zero reference for the purposes of the auto-stop
Vec2 gravity;

// The Spring that will attach to the box from the mouse
Spring spring;

public int gTImer = 60; //60fps = 1 second, which is the time I want it to take things to stop. Will have to figure out collision later

void setup() {
  size(1280, 720);
  smooth(4);
  frameRate(60);
  
  //Load sound file and play. 
  //TODO find an effecient way to load all sound files and place them in an array
  note1 = new Sound("04_FinPad_MID_1.wav");
  note2 = new Sound("05_FinPad_MID_2.wav");
  note1.play();
  note2.play();
  
  // Set Gravity at Zero and setup the zero reference
  gravity = new Vec2(0,0);

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld(gravity);

  // Make the box
  box = new Box(width/2,height/2);
  box2 = new Box(10, 100);

  // Make the spring (it doesn't really get initialized until the mouse is clicked)
  spring = new Spring();

  // Add a bunch of fixed boundaries
  boundaries = new ArrayList();
  boundaries.add(new Boundary(width/2,height-5,width,10,0));
  boundaries.add(new Boundary(width/2,5,width,10,0));
  boundaries.add(new Boundary(width-5,height/2,10,height,0));
  boundaries.add(new Boundary(5,height/2,10,height,0));
}

// When the mouse is released we're done with the spring
void mouseReleased() {
  spring.destroy();
}

// When the mouse is pressed we. . .
void mousePressed() {
  // Check to see if the mouse was clicked on the box
  if (box.contains(mouseX, mouseY)) {
    // And if so, bind the mouse location to the box with a spring
    spring.bind(mouseX,mouseY,box);
  }else if (box2.contains(mouseX, mouseY)) {
    spring.bind(mouseX, mouseY, box2);
  }
}

void draw() {
  background(255);
  frameRate(60); //set FPS to 60 (its default 60, but I want to make sure)

  // We must always step through time!
  box2d.step();

  // Always alert the spring to the new mouse location
  spring.update(mouseX,mouseY);

  // Draw the boundaries
  for (int i = 0; i < boundaries.size(); i++) {
    Boundary wall = (Boundary) boundaries.get(i);
    wall.display();
  }

  // Draw the box
  box.display();
  box2.display();
  // Draw the spring (it only appears when active)
 // spring.display();

  // Mostly for diagnostics. Prints the Velocity of each body to the applet
  // Will be deleted once we move off of this testing ground
  Vec2 v = new Vec2();
  Vec2 v2 = new Vec2();
  v = box.getLinearVelocity();
  v2 = box2.getLinearVelocity();
  textSize(36);
  fill(0);
  text(v.toString(), 50, 50);
  text(v2.toString(), 50, 150);

  // Calling the auto stop method for each box, set to 90 frames since the last ~40 are
  // exponentially approaching zero and don't visually appear to be moving.
  box.makeStop(90);
  box2.makeStop(90);
  
  // Call Amplitude control method, tied to the Y position of the specified body
  // Need to input the size manually, no big deal, don't want to deal with writing another
  // method to return the body size
  note1.boxAmp(box, 75);
  note2.boxAmp(box2, 75);


}
