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
    int bCx; 
    int bCy;
    
    PImage box;
    IntList px;
    ArrayList<Point> coord;
    Point cPoint; //DISTINCT FROM THE METHOD for internal usage.
    char letter;
    
    //objects for any movement related methods
    PVector location;
    PVector velocity;
    PVector acceleration;
    PVector friction = new PVector(0,0);
    PVector zeroVec = new PVector(0,0); //zero vector for reference 
    
    float f; //friction coeffecient 
    float mass = 1.5; //mass, just to find out if it helps.
    
    //Constructor
    Box(int x_, int y_, int sizeW, int sizeH, int bColor) {
        
        this.bx = x_;
        this.by = y_;
        
        this.bW = sizeW;
        this.bH = sizeH;
        
        location = new PVector(bx, by);
        velocity = new PVector(0,0);
        acceleration = new PVector(0,0);
        
        //Create PImage for the Box?
        imageMode(CORNER);
        box = createImage(bW,bH, RGB);
        fill(170);
        letter = char(int(random(65, 65 + 24)));
        box.loadPixels();
        colorMode(HSB);
        for (int i = 0; i < box.pixels.length; i++) {
            box.pixels[i] = color(bColor, 0, 0, 255);
        }
        box.updatePixels(); 
    }
    
    //Fills a Point Array with the coordinates of the entire box
    //IN THE ORDER they are listed as per the Pixel array
    //Call this in SETUP to avoid redrawing the coordinate array every frame
    void getCoord() {
        coord = new ArrayList<Point>();
        for (int y = 0; y < this.bH; y++) {
            for (int x = 0; x < this.bW; x++) { 
                coord.add(new Point(x,y));
            }
        }
    }
    
    // Display the Box
    // will be replaced with the generation of an image (glyph) 
    void display() {
        image(box, bx, by);
        textSize(30);
        text(letter, bx,(by + bH));
    }
    
    //Get the center point for the box. Will be used
    //to calculate a vector later on
    Point getCenter() {
        int bCx = (this.bW / 2);
        int bCy = (this.bH / 2);
        return new Point(bCx, bCy);
    }
    
    /*Mouse attachment method, mostly used for testing right now
    while I don't have a live feed. Probably won't ned, but
    I'll keep it in. */
    void attachMouse() {
        if (locked) {
            this.bx = mouseX;
            this.by = mouseY;
        }
    }
    
    /* Look Under function. Used for examining the pixels under
    the box. Will need to figure out how to deciper the data
    and perform a function depending on the result
    
    Must be called in DRAW for any methods that reference
    the px[] array to work*/
    void lookUnder(PImage p) {
        PImage r = p.get(this.bx, this.by, this.bW, this.bH);
        px = new IntList();
        px.append(r.pixels);
    }
    
    /*Method for finding the first white pixel, and it's location
    WITHIN the Box. Will use PVector(?) to apply a vector
    from the relationship to the center. */
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
                //this is currently non-functional
                collisionArrayX.append((coord.get(i).x));
                collisionArrayY.append((coord.get(i).y));
            }
            // Every 10 loops of the for loop, take the average of the array.
            //This is untested, may need additioanl conditions to properly operate
            if (i % 10 ==  0) {
                
                //Adding the size check here to stop empty arrays from trying to trigger a for loop
                if (collisionArrayY.size() != 0 && collisionArrayX.size() != 0) {
                    
                    // Add each value to the sum, to be divided for the mean
                    for (int o = 0; o < collisionArrayX.size(); o++) {
                        sumX += collisionArrayX.get(o);
                        sumY += collisionArrayY.get(o);
                    }
                    
                    //assign cPoint as the mean of the arrays rather than
                    // the first bright pixel in each pass                  
                    cPoint = new Point((sumX / collisionArrayX.size()),(sumY / collisionArrayY.size()));
                    
                    //return the centroid for collision purposes
                    collisionArrayX.clear();
                    collisionArrayY.clear();
                    return cPoint;
                }
            }
        }
        //if there are no bright pixel, return null
        cPoint = null;
        return null;
    }
    
    /* Beginnings of the collision vector method. 
    Willneedto be called as a function AFTER lookUnder so the 
    px arrayis populated, and the collisionPoint method can
    run successfully.*/ 
    void collisionVector() {       
        //GET DIRECTIONAL VECTOR
        float centerX = float(bCx);
        float centerY = float(bCy);
        
        //Methodvariables
        float f = 0.25;
        float aMult = 10;
        int stopTime = 10;
        float topSpeed = 4;
        
        //Methodobjects
        PVector force;
        PVector dir = new PVector(0,0);
        
        //Apply the force ONLY if there is a collision happening
        if (cPoint != null) {
            
            float collisionX = float(cPoint.x);
            float collisionY = float(cPoint.y);
            
            //Get collision vecotr
            PVector centerPoint = new PVector(centerX, centerY);
            PVector colPoint = new PVector(collisionX, collisionY);
            dir = PVector.sub(centerPoint, colPoint);
            dir.normalize();
            dir.mult(aMult);
        }
        
        //SET UPFRICTION
        friction = velocity.get();
        friction.mult( -1);
        friction.normalize();
        friction.mult(f);   
        
        //Apply collsition vector to acceleration
        acceleration.set(dir);
        
        //APPLY FRICTION
        force = PVector.div(friction,mass);   
        acceleration.add(force);
        
        //UPDATE
        location.set(this.bx,this.by);    
        velocity.add(acceleration);
        velocity.limit(topSpeed);
        location.add(velocity);
        
        //UPDATEPOSITION
        this.bx = int(location.x);
        this.by = int(location.y);
    }
    
    //bounce off the edges
    void edgeBounce() {
        if (this.bx <= 0 || this.bx + bW >= width) {
            this.bx = int(random(width));
            velocity.set(0,0);
        }
        if (0 >= this.by || this.by + bH >= height) {
            this.by = int(random(height));
            velocity.set(0,0);
        }
    }
}   