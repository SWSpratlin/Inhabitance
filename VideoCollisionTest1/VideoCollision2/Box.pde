class Box{
    
    int bW;
    int bH;
    int c;
    int bx;
    int by;
    
    PImage box;
    IntList px;
    ArrayList<Point> coord;
    
    //Constructor
    Box(int x_, int y_, int sizeW, int sizeH, int bColor) {
        
        this.bx = x_;
        this.by = y_;
        
        this.bW = sizeW;
        this.bH = sizeH;
        
        this.c = bColor;
        
        //Create PImage for the Box?
        imageMode(CORNER);
        box = createImage(bW,bH, RGB);
        box.loadPixels();
        for (int i = 0; i < box.pixels.length; i++) {
            box.pixels[i] = color(c);
        }
        box.updatePixels(); 
    }
    
    /*Fills a Point Array with the coordinates of the entire box
    IN THE ORDER they are listed as per the Pixel array */
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
    void getCenter() {
        int bCw = this.bx + (this.bW / 2);
        int bCh = this.by + (this.bH / 2);
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
    and perform a function depending on the result*/
    void lookUnder(PImage p) {
        PImage r = p.get(this.bx, this.by, this.bW, this.bH);
        px = new IntList();
        px.append(r.pixels);
        for (int i = 0; i < px.size(); i++) {
            px.set(i, int(brightness(px.get(i))));
        }
    }
    
    /*Method for finding the first white pixel, and it's location
    WITHIN the Box. Will use PVector(?) to apply a vector
    from the relationship to the center. */
    Point collisionPoint() {  
        //Search function to comb the "px" array for a white pixel
        for (int i = 0; i < px.size(); i++) { 
            if (px.get(i) >= 220) { //threshold at 220
                return coord.get(i);
            }
        }
        return null;     
    }   
}