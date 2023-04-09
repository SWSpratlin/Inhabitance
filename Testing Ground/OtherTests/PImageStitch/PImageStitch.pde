import java.awt.Point; 

PImage jay;
PImage tony;
PImage master;

ArrayList<PImage> currentArray = new ArrayList<PImage>(2);

//Call the Box Array
ArrayList<Box> boxes;

int mouseLoc = 0;




void setup() {
    size(1000,500);
    
    //Set number of boxes to spawn
    int boxNumber = 40;
    
    jay = createImage(500,500,RGB);
    jay.loadPixels();
    for (int i = 0; i < jay.pixels.length; i++) {
        jay.pixels[i] = color(0);
    }
    jay.updatePixels();
    tony = createImage(500,500,RGB);
    tony.loadPixels();
    for (int i = 0; i < tony.pixels.length; i++) {
        tony.pixels[i] = color(30);
    }
    tony.updatePixels();
    master = createImage(1000,500,HSB);
    
    currentArray.add(jay);
    currentArray.add(tony);
    
    //intialize the box array
    boxes = new ArrayList<Box>(boxNumber);
    
    //initialize the boxes
    for (int i = 0; i < boxNumber; i++) {
        Box tmpBox = new Box(int(random(width)), int(random(height)), 15, 25, 0);
        tmpBox.getCoord();
        boxes.add(tmpBox);
    }
    
    
}

void draw() {
    master.loadPixels();
    
    //global variables make this
    int k = 0;
    int image = 0;
    
    //Combination loop
    for (int i = 0; i < master.pixels.length; i++) {
        if (i ==  0) {
            image = 0;
        } else if (i % currentArray.get(image).width == 0) {
            if (image == 0) {
                image = 1;
                k -= currentArray.get(image).width;
            } else {
                image = 0;
            }
        }
        mouseLoc = mouseX + mouseY * width;
        // Animation goes here
        master.pixels[mouseLoc++] = color(255);
        
        // Assign pixels to master
        master.pixels[i] = currentArray.get(image).pixels[k];
        k++;
    }
    master.updatePixels();
    //only displaying the master image
    image(master,0,0);
    
    //Apply methods to each box in the array
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).lookUnder(master);
        boxes.get(i).collisionPoint();
        boxes.get(i).collisionVector();
        boxes.get(i).edgeBounce();
        boxes.get(i).display();
    }
    
    textSize(50);
    text(frameRate, 10, 50);
    strokeWeight(10);
    stroke(0);
    line(20, 60, 240, 60);
    stroke(255);
    line(20, 60, frameRate * 4, 60);
}