class Box{
    
    int bW; //Sixe parameters
    int bH;
    private int c; //Color alpha value
    int bx; //Corner coordinates, spawn
    int by;
    int threshold = 220; //Threhsold for the search
    int bCx; //Center Coordinates of the Box
    int bCy;
    
    PImage box;
    IntList px;
    ArrayList<Point> coord;
    Point cPoint; //DISTINCT FROM THE METHOD for internal usage.
    
    //objects for any movement related methods
    PVector location;
    PVector velocity;
    PVector acceleration;
    PVector friction;
    float f; //friction coeffecient 
    
    //Constructor
    Box(int x_, int y_, int sizeW, int sizeH, int bColor) {
        
        this.bx = x_;
        this.by = y_;
        
        this.bW = sizeW;
        this.bH = sizeH;
        
        this.c = bColor;
        
        location = new PVector(bx, by);
        velocity = new PVector(0,0);
        acceleration = new PVector(0,0);
        
        //Create PImage for the Box?
        imageMode(CORNER);
        box = createImage(bW,bH, RGB);
        box.loadPixels();
        for (int i = 0; i < box.pixels.length; i++) {
            box.pixels[i] = color(c);
        }
        box.updatePixels(); 
    }
    
    //Fills a Point Array with the coordinates of the entire box
    //IN THE ORDER they are listed as per the Pixel array
    //Call this in SETUP to avoid redrawing the coordinate array every time
    void getCoord() {
        coord = new ArrayList<Point>();
        for (int y = 0; y < this.bH; y++) {
            for (int x = 0; x < this.bW; x++) { 
                coord.add(new Point(x,y));
            }
        }
    }
    
    //Display the Box
    void display() {
        image(box, bx, by);
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
        //Search function to comb the "px" array for a white pixel
        for (int i = 0; i < px.size(); i++) { 
            if (int(brightness(px.get(i))) >= threshold) {
                cPoint = new Point(coord.get(i));
                return coord.get(i);
            } 
        }
        cPoint = zeroPoint;
        return zeroPoint;
    }
    
    /* Beginnings of the collision vector method. 
    Will need to be called as a function AFTER lookUnder so the 
    px array is populated, and the collisionPoint method can
    run successfully. */
    void collisionVector() {
        
        /* since I'm writing basically all the physics and
        forces that happen in this single method, I'm gonna
        just do it all at once, call this method in draw[], 
        and call it a day. Hopefully it reloads itself. 
        
        Update analogue is will be first so it's the first thing
        to happen when the method is called in draw. */
        //UPDATE
        this.bx = int(location.x);
        this.by = int(location.y);
        
        //GET DIRECTIONAL VECTOR
        float centerX = float(bCx);
        float centerY = float(bCy);
        if (cPoint != zeroPoint) {
            float collisionX = float(cPoint.x);
            float collisionY = float(cPoint.y);
            float f = 0.01;
            
            PVector centerPoint = new PVector(centerX, centerY);
            PVector colPoint = new PVector(collisionX, collisionY);
            acceleration = PVector.sub(centerPoint, colPoint);
            acceleration.normalize();
            acceleration.mult(0.5);
            
            //SET UP FRICTION
            friction = velocity.get();
            friction.mult( -1);
            friction.normalize();
            friction.mult(f);
            
            //APPLY FRICTION
            acceleration.add(friction);
            
            location.set(this.bx,this.by);
            velocity.add(acceleration);
            location.add(velocity);
        }
    }
    
}   