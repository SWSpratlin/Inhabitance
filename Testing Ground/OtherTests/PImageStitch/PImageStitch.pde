import java.awt.Point; 

PImage jay;
PImage tony;
PImage master;

ArrayList<PImage> currentArray = new ArrayList<PImage>(2);

//Call the Box Array
//ArrayList<Box> boxes;

int mouseLoc = 0;

void setup() {
    size(2000, 1000);
    //Set number of boxes to spawn
    //int boxNumber = 40;
    
    jay = loadImage("jay.JPG");
    //jay.loadPixels();
    
    tony = loadImage("tony.jpg");
    //tony.loadPixels();
    
    master = createImage(jay.width * 4, jay.height * 2,HSB);
    
    currentArray.add(jay); // set Jay at index 0
    currentArray.add(tony); // set Tony at index 1
    
    //intialize the box array
    //boxes = new ArrayList<Box>(boxNumber);
    
    //initialize the boxes
    //for (int i = 0; i < boxNumber; i++) {
    //Box tmpBox = new Box(int(random(width)), int(random(height)), 15, 25, 0);
    //tmpBox.getCoord();
    //boxes.add(tmpBox);
//}
}

// Mouse click randomizer
void mouseReleased() {
    //for (int i = 0; i < boxes.size(); i++) {
    //boxes.get(i).bx = int(random(width));
    //boxes.get(i).by = int(random(height));
//}
}

void draw() {
    master.loadPixels();
    
    //global variables make this work. K is the second (int i) analogue. Resets K after the for loop
    int k = 0;
    
    //int image serves to control the CurrentImage array's index. 0 or 1 depending on where in the loop
    int image = 0;
    
    //Combination loop
    for (int i = 0; i < master.pixels.length; i++) {
        
        //Set up the current array at the start of the loop
        if (i ==  0) {
            image = 0;
            
            // Modulus to switch the array every other time. 
        } else if (i % (currentArray.get(image).width * 2) == 0) {
            
            // check which array is selected
            if (image == 0) {
                
                // if it's 0, switch images that we're indexing
                image = 1;
                
                /* Subtract the width of the image from K so K iterates over the same
                set of numbers twice each time. Use [k] to coontrol each image individually
                
                Only has to go back when going to the second image (one on the right) otherwise
                it can just keep going. 
                */
                k -= currentArray.get(image).width;
                
            } else {
                
                // don't have to reset K when coming back to the first image
                image = 0;
                i += master.width;
                
            }
        }
        
        //animation variable
        //mouseLoc = mouseX + mouseY * width;
        
        if (k >= currentArray.get(image).pixels.length) {
            k = 0;
        }
        
        // Animation goes here
        //jay.pixels[k] += 1;
        // tony.pixels[k] += 1;
        
        int i2 = i + 1;
        int i3 = i + width;
        int i4 = i2 + width;
        // Assign pixels from each inmage to master
        if (i + master.width + 1 < master.pixels.length) {
            master.pixels[i] = currentArray.get(image).pixels[k];
            master.pixels[i2] = currentArray.get(image).pixels[k];
            master.pixels[i3] = currentArray.get(image).pixels[k];
            master.pixels[i4] = currentArray.get(image).pixels[k];
            i++;
        }
        k++;  
    }
    master.updatePixels();
    //only displaying the master image
    
    scale( -1,1);
    image(master, -master.width, 0);
    
    
    
    
    //Apply methods to each box in the array
    // for (int i = 0; i < boxes.size(); i++) {
    //     int u = boxes.size() - 1;
    //     boxes.get(i).lookUnder(master);
    //     boxes.get(i).collisionPoint();
    //     boxes.get(i).collisionVector();
    //     boxes.get(i).edgeBounce();
    //     boxes.get(i).display();
// }
    
    textSize(50);
    text(frameRate, -1000, 50);
    strokeWeight(10);
    stroke(0);
    line( -20, 60, -240, 60);
    stroke(255);
    line( -20, 60, -frameRate * 4, 60);
}