// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A rectangular box

class Box {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;

  // Constructor
  Box(float x_, float y_) {
    float x = x_;
    float y = y_;
    w = 75;
    h = 75;
    // Add the box to the box2d world
    makeBody(new Vec2(x,y),w,h);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    //float a = body.getAngle();

    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    //rotate(a);
    fill(175);
    stroke(0);
    rect(0,0,w,h);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {
    
    float damping = 0.1;
    
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    bd.linearDamping = damping;
    bd.angularDamping = damping;
    bd.fixedRotation = true;
    //bd.frequencyHz = 60.0;

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);
    

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 0;
    fd.friction = 1;
    fd.restitution = 0.1;

    body.createFixture(fd);
    //body.setMassFromShapes();

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
   // body.setAngularVelocity(random(-5, 5));
  }

  public Vec2 getLinearVelocity() {
    return body.getLinearVelocity();
  }

  // method to return the Y Position of the body
  // used mainly for the amplitude control of sound
  float getPixelCoordY () {
    Vec2 yPos = box2d.getBodyPixelCoord(body);
    return (yPos.y);
  }

  // Auto Stop function, tied to both the framerate and a global timer (gTimer)
  void makeStop(float t_) {
    float t = t_; //frames that the stop will take
    
    Vec2 oVel = new Vec2(body.getLinearVelocity()); //pull linear velocity from box
    float stepX = (oVel.x/t); //see how much the box needs to slow each frame to stop within the frame limit (x)
    float stepY = (oVel.y/t); //see how much the box needs to slow each frame to stop within the frame limit (y)
    Vec2 stepVec = new Vec2(stepX/(t/15),stepY/(t/15)); //step vector for subtraction purposes
    
    //For some reason, we couldn't resolve gTimer as a variable, so I created it again here
    int gTimer = 60;

    // Lock variable. Not sure if it's doing what I want it to do.
    // Theory is to get it to lock any changes to the oVel object.
    boolean locked = false;
    
    // Check if the object is unlocked, then input a value to oVel
    // Lock when the value is input
    if (oVel != gravity && !locked) {
        gTimer = 60;
        oVel.set(body.getLinearVelocity());
        locked = true;
  } 
  
   // For loop to set the timer to 1 second (60) and tick down each frame while it subtracts 
   // a precalculated value from the initial velocity until 0
   for(gTimer = 60; gTimer != 0; gTimer--) {
        body.setLinearVelocity(oVel.subLocal(stepVec));
    }
  
    // Unlock when velocity has stopped.
    if (oVel == gravity) {
        locked = false;
  }

    }

}
