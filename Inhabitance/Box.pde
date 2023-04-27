class Box{
    
    //X and Y size for the collision of the box
    int bW;
    int bH;
    
    //Corner coordinates, determines the location of the box
    int bx; 
    int by;
    
    //Threhsold for the search to return a collision point
    int threshold = 220; 
    
    //Center Coordinates of the Box
    int bCx = bW / 2; 
    int bCy = bH / 2;
    
    PImage box; //Box for collision detection area
    IntList px; //Array for collision detection
    ArrayList<Point> coord; //Coordinate array for Vector generation
    Point cPoint; //Point that feeds from collisionPoint into collisionVector.
    char letter; //Random letter variable, global so it can change
    int letterNumber; //Number associated with each letter. 
    int noteNumber; // ASCII number to access the <notes> array
    
    SoundFile boxNote;
    
    float varAmp = 0;
    
    //objects for any movement related methods
    PVector location;
    PVector velocity;
    PVector acceleration;
    PVector friction = new PVector(0,0);
    
    // Boolean for sound methods. 
    boolean hasMoved = false;
    boolean isMoving = false;
    
    float f; //friction coeffecient, used in collisionVector
    float mass = 1.5; //mass, just to find out if it helps. (it doesn't really)
    
    PFont font;
    
    //Constructor. Called in SETUP
    //Intakes spawn coordinates, size, color
    Box(int x_, int y_, int sizeW, int sizeH, int bColor) {
        
        //Spawn Coordinate variables
        this.bx = x_;
        this.by = y_;
        
        //Size variables
        this.bW = sizeW;
        this.bH = sizeH;
        
        //Initialize Collision variables
        location = new PVector(this.bx, this.by);
        velocity = new PVector(0,0);
        acceleration = new PVector(0,0);
        
        //Create PImage for the Box
        imageMode(CORNER);
        box = createImage(bW,bH, RGB);
        
        //Color Letter
        fill(200);
        
        font = createFont("01_AvenirHeavy.ttf", 30);
        
        
        //Generate random character
        letterNumber = int(random(65, 65 + 26)); //generate ASCII values for char(). CAPS. 
        noteNumber = letterNumber - 65; //convert ASCII values to ints that can access <notes>
        letter = char(letterNumber); // Assign char() a random CAPS letter
        
        boxNote = new SoundFile(master, notes.get(noteNumber));
        
        
        //Color Box pixels (mostly for debugging)
        box.loadPixels();
        for (int i = 0; i < box.pixels.length; i++) {
            //Make collision box transparent
            box.pixels[i] = color(bColor, 255,255,150);
        }
        //Update Box pixels
        box.updatePixels(); 
    }
    
    //Fills a Point Array with the coordinates of the entire box
    //IN THE ORDER they are listed as per the Pixel array
    //Call this in SETUP to avoid redrawing the coordinate array every frame
    void getCoord() {
        
        //initialize coordinate array
        coord = new ArrayList<Point>();
        
        //comb through the entire area of the box to assign every pixel a coordinate
        for (int y = 0; y < this.bH; y++) {
            for (int x = 0; x < this.bW; x++) { 
                
                //assign coordinates. USES CALCULATION TO MAKE SURE THE CENTER
                //COORDINATE IS 0,0. COLLISION IS EXTREMELY BUGGY WITHOUT THIS
                coord.add(new Point(x - (bW / 2),y - (bH / 2)));
            }
        }
    }
    
    // Display the Box(if visible) and Letter
    void display() {
        
        // Call box image. Necessary for loadPixels() later to work
        image(box, bx, by);
        
        //Call the text and character. This is where the text can be 
        //customized visually
        
        textFont(font, 30);
        text(letter, bx,(by + bH));
        
        //debugging text goes here
        // String debug = "--";
        // textSize(20);
        // text(debug, bx, by - 1);
    }
    
    /* Look Under function. Used for examining the pixels under the box. 
    
    Mustbe called in DRAW for any methods that reference the px[] array to work*/
    void lookUnder(PImage p) {
        
        //Generate PImage (and therefore a pixels array) for the space under the box
        PImage r = p.get(this.bx, this.by, this.bW, this.bH);
        
        //create pixels array that can be referenced 
        px = new IntList();
        px.append(r.pixels);
    }
    
    /*Method for finding the first white pixel, and it's location
    WITHIN the Box. Will use PVector(?) to apply a vector
    from the relationship to the center. 
    
    Must be called in DRAW for collisionVector to be 
    functional, preferably before collisionVector*/
    Point collisionPoint() {
        
        // Xand Y arrays to create a centroid coordinate 
        IntList collisionArrayX = new IntList();
        IntList collisionArrayY = new IntList();
        
        // Xand Y sum variables that clear every loop for the average
        //calculation to take place
        int sumX = 0;
        int sumY = 0;
        
        //scan the whole px array
        for (int i = 0; i < px.size(); i++) {
            // Check if any given pixel is brighter than the threshold
            if (int(brightness(px.get(i))) >= threshold) {
                
                //pupulate the X and Y arrays with the values from the
                // coord array. 
                collisionArrayX.append((coord.get(i).x));
                collisionArrayY.append((coord.get(i).y));
            }
            
            // Everytime the for loop goes through 2 rows of the Box, check for collision. Adding the 
            // row calculation makes the collisions more stable and intuitive
            if (i % (this.bW * 2) ==  0) {
                
                //Adding the size check here to stop empty arrays from trying to trigger a for loop
                if (collisionArrayY.size() != 0 && collisionArrayX.size() != 0) {
                    
                    // Add each value to the sum, to be divided for the mean
                    for (int o = 0; o < collisionArrayX.size(); o++) {
                        sumX += collisionArrayX.get(o);
                        sumY += collisionArrayY.get(o);
                    }
                    
                    //assign cPoint as the mean of the arrays rather than
                    // the first bright pixel in each pass. normalizes collision vector                
                    cPoint = new Point((sumX / collisionArrayX.size()),(sumY / collisionArrayY.size()));
                    
                    //return the centroid for collision purposes
                    collisionArrayX.clear();
                    collisionArrayY.clear();
                    return cPoint;
                }
            }
        }
        
        //if there are no bright pixels, return null
        cPoint = null;
        return null;
    }
    
    /* Needs to be called as a function AFTER lookUnder so the 
    px array is populated, and the collisionPoint method can
    run successfully.*/ 
    void collisionVector() {       
        
        //Method variables.
        //Friction coeffecient. Change from between 0.01 and 0.5 for best results
        float f = 0.25;
        
        //Acceleration coeffecient for how much speed picks up after collision
        //Change between 8 and 20 for best results
        float aMult = 8;
        
        //speed limiter so things don't fly away
        //Change between 3 and 10 for best results
        float topSpeed = 4.5;
        
        //Method objects
        PVector force;
        
        //Directional Vector for collision direction
        PVector dir = new PVector();
        
        //Apply the force ONLY if there is a collision happening
        if (cPoint != null) {
            
            //Get collision vector
            PVector colPoint = new PVector(cPoint.x, cPoint.y);
            PVector centerPoint = new PVector(bCx, bCy);
            
            //Calculate the direction between the center point and Collision Point
            dir = PVector.sub(centerPoint, colPoint);
            
            //Normalize the vector, and multiply it to create acceleration upon collision
            dir.normalize();
            dir.mult(aMult);
            isMoving = true;
            
        } else {
            //If there is no collision, make sure the directional vector is zeroed out. 
            //Causes drift without this.
            dir.set(0,0);
            isMoving = false;
        }
        
        //SET UPFRICTION
        friction = velocity.get();
        friction.mult( -1);
        friction.normalize();
        friction.mult(f);   
        
        //Apply collsition vector to acceleration
        acceleration.set(dir);
        
        //APPLY FRICTION
        friction.div(mass);
        acceleration.add(friction);
        
        //UPDATE
        location.set(this.bx,this.by);    
        velocity.add(acceleration);
        velocity.limit(topSpeed);
        location.add(velocity);
        acceleration.mult(0);
        
        //UPDATEPOSITION
        this.bx = int(location.x);
        this.by = int(location.y);
        
        //Drift elimination. If the velocity is within a certain threshold
        //zero it out. Threshold should be low enough that this seems natural
        float lowThresh = -0.04;
        float highThresh = 0.04;
        
        // Variable Amp
        float varAmp = map(this.by, 0, height, 0,1);
        boxNote.amp(varAmp);
        
        //lotta && statements to find out if 2 values are within a range
        if (lowThresh <= velocity.x && velocity.x <= highThresh && lowThresh <= velocity.y && velocity.y <= highThresh) {
            velocity.set(0,0);
            isMoving = false;
        }
        
        if (isMoving == true && boxNote.isPlaying() == false) {
            boxNote.play();
            isMoving = false;
        }
        
        float noteThresh = 0.25;
        
        if (isMoving == true && boxNote.position() > noteThresh) {
            boxNote.jump(0);
            isMoving = false;
        }
    }
    
    //bounce off the edges
    void edgeBounce() {
        
        //Check if the box is on the edge (same for all)
        if (this.bx < 0) {
            
            //set location to the lower bound, invert and multiply velocity to 
            //avoid getting stuck on the eges
            this.bx = 0;
            velocity.x *= -4;
        } else if (this.bx + bW >= width) {
            this.bx = width - bW;
            velocity.x *= -4;
        }
        if (this.by < 0) {
            this.by = 0;
            velocity.y *= -4;
        } else if (this.by + bH >= height) {
            this.by = height - bH;
            velocity.y *= -4;
        }
    }
}   