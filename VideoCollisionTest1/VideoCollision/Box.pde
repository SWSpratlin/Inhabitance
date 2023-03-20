class Box{
    
    //Defining the million variuables/objects that I'll need for
    //A primitive box object (needs to be a PShape)
    private int bWidth;
    private int bHeight;
    private int bCenterX;
    private int bCenterY;
    private int xPos;
    private int yPos;
    private PShape rectBox;
    
    //Constructor
    Box(int xPos, int yPos, int bWidth, int bHeight) {
        
        // Fieldsfor the Constructor
        this.xPos = xPos;
        this.yPos = yPos;
        this.bWidth = bWidth;
        this.bHeight = bHeight;
        
        //Create thePShape, will write another Method to display
        rectBox = createShape(RECT, xPos, yPos, bWidth, bHeight);
        rectBox.setStroke(color(255));
        rectBox.setFill(color(180));
        
        
    }
    
    //getCenter Method. Needed to do physics stuff
    //Hopefully center values conintually update, will need to 
    //write in an offset/updating code to continually update
    //the XY values of the Shape. Can that be done in the 
    //Constructor?
    public float getCenter(Box b) {
        bCenterX = xPos + (bWidth / 2);
        bCenterY = yPos + (bHeight / 2);
        return point(b.bCenterX, b.bCenterY);
    }  
    
    voiddisplay() {
        shape(rectBox);
    }
    
    boolean contains(float x, float y) {
        if (mouseX >= xPos && mouseX <= (xPos + bWidth) && mouseY >= yPos && mouseY <= (yPos + bHeight)) {
            return true;
        }
    }
    
}
