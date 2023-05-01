import processing.sound.*;
import java.awt.Point; 
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import processing.serial.*;


public PApplet master = this;

//Master Image
PImage masterImg;

//Set up arduino
Serial arduino;

//Array to store the Int arrays for the Switching block
ArrayList<int[]> currentArray = new ArrayList<int[]>();

//Depth Thresholds
float minDepth =  300;
float maxDepth = 9600;

//Kinects to Interate through
ArrayList<Kinect> kinects;

//Boxes and Notes to assign
ArrayList<Box> boxes;
ArrayList<String> notes;
ArrayList<String> sounds;
ArrayList<String> sounds2;

//Number of Boxes to spawn
int boxNumber = 60;

// Reset Counter to space out sound object creation
int counter = 0;

//Device variables
int numDevices = 0;

void setup() {
    // Size. Width has to be double the width of a Kinect
    // This lets 2 Kinect feeds populate next to each other
    // Scale by 2 to increase size
    size(640 * 4,480 * 2, P2D);
    
    //Sound arrays
    notes = new ArrayList<String>();
    notes.add("A__1.wav");
    notes.add("B__1.wav");
    notes.add("C__1.wav");
    notes.add("D__1.wav");
    notes.add("E__1.wav");
    notes.add("F__1.wav");
    notes.add("G__1.wav");
    notes.add("H__1.wav");
    notes.add("I__1.wav");
    notes.add("J__1.wav");
    notes.add("K__1.wav");
    notes.add("L__1.wav");
    notes.add("M__1.wav");
    notes.add("N__1.wav");
    notes.add("O__1.wav");
    notes.add("P__1.wav");
    notes.add("Q__1.wav");
    notes.add("R__1.wav");
    notes.add("S__1.wav");
    notes.add("T__1.wav");
    notes.add("U__1.wav");
    notes.add("V__1.wav");
    notes.add("W__1.wav");
    notes.add("X__1.wav");
    notes.add("Y__1.wav");
    notes.add("Z__1.wav");
    
    sounds = new ArrayList<String>();
    sounds.add("A__2.wav");
    sounds.add("B__2.wav");
    sounds.add("C__2.wav");
    sounds.add("D__2.wav");
    sounds.add("E__2.wav");
    sounds.add("F__2.wav");
    sounds.add("G__2.wav");
    sounds.add("H__2.wav");
    sounds.add("I__2.wav");
    sounds.add("J__2.wav");
    sounds.add("K__2.wav");
    sounds.add("L__2.wav");
    sounds.add("M__2.wav");
    sounds.add("N__2.wav");
    sounds.add("O__2.wav");
    sounds.add("P__2.wav");
    sounds.add("Q__2.wav");
    sounds.add("R__2.wav");
    sounds.add("S__2.wav");
    sounds.add("T__2.wav");
    sounds.add("U__2.wav");
    sounds.add("V__2.wav");
    sounds.add("W__2.wav");
    sounds.add("X__2.wav");
    sounds.add("Y__2.wav");
    sounds.add("Z__2.wav");
    
    sounds2 = new ArrayList<String>();
    sounds2.add("A__3.wav");
    sounds2.add("B__3.wav");
    sounds2.add("C__3.wav");
    sounds2.add("D__3.wav");
    sounds2.add("E__3.wav");
    sounds2.add("F__3.wav");
    sounds2.add("G__3.wav");
    sounds2.add("H__3.wav");
    sounds2.add("I__3.wav");
    sounds2.add("J__3.wav");
    sounds2.add("K__3.wav");
    sounds2.add("L__3.wav");
    sounds2.add("M__3.wav");
    sounds2.add("N__3.wav");
    sounds2.add("O__3.wav");
    sounds2.add("P__3.wav");
    sounds2.add("Q__3.wav");
    sounds2.add("R__3.wav");
    sounds2.add("S__3.wav");
    sounds2.add("T__3.wav");
    sounds2.add("U__3.wav");
    sounds2.add("V__3.wav");
    sounds2.add("W__3.wav");
    sounds2.add("X__3.wav");
    sounds2.add("Y__3.wav");
    sounds2.add("Z__3.wav");
    
    //KInect initialization
    numDevices = Kinect.countDevices();
    println(numDevices);
    
    //Initialize Kinect array
    kinects = new ArrayList<Kinect>();
    
    //Iterate through as many Kinects as are connected
    for (int i = 0; i < 2; i++) {
        //Initialize object for each Kinect detected
        Kinect tempKinect = new Kinect(this);
        
        //Activate the Current Kinect
        tempKinect.activateDevice(i);
        
        //Initialize Depth for current Kinect
        tempKinect.initDepth();
        
        //Add the current Kinect to the Array
        kinects.add(tempKinect);
        
        //Initialize rawDepth array for each Kinect
        //MUST BE IN THIS LOOP OR ONLY ONE KINECT WILL WORK
        int[] tempRawDepth = tempKinect.getRawDepth();
        
        //Add the rawDepth array to the Switching Array
        currentArray.add(tempRawDepth);
    }
    
    //Initialize Box Array
    boxes = new ArrayList<Box>(boxNumber);
    
    //Create Letters
    for (int i = 0; i < boxNumber; i++) {
        
        //Temp Boxes, spawn at random places on screen
        Box tmpBox = new Box(int(random(width)), int(random(height)), 15, 15, 150);
        
        //Assign Sounds, dependent on the Array they're pulling from. 
        if (tmpBox.arrayNumber <= 3) {
            SoundFile tempSound = new SoundFile(this, notes.get(tmpBox.noteNumber), false);
            tmpBox.boxNote = tempSound;
            tempSound = null;
        } else if (tmpBox.arrayNumber >= 4 && tmpBox.arrayNumber <= 7) {
            SoundFile tempSound = new SoundFile(this, sounds.get(tmpBox.noteNumber), false);
            tmpBox.boxNote = tempSound;
            tempSound = null;
        } else if (tmpBox.arrayNumber >= 8) {
            SoundFile tempSound = new SoundFile(this, sounds2.get(tmpBox.noteNumber), false);
            tmpBox.boxNote = tempSound;
            tempSound = null;
        }
        // Populate the Coordinate Array for each letter
        tmpBox.getCoord();
        
        //Add each new Letter to the box Array
        boxes.add(tmpBox);
    }
    
    //Blank image
    masterImg = createImage(width, height, ARGB);
    
    //Initialize Arduino Object with serial Port
    printArray(Serial.list());
    arduino = new Serial(this, Serial.list()[0], 115200);
}

//Reset Function, will work out a different physical interface
//at a later time. Possibly Arduino Button. 
void mouseReleased() {
    
    //Increment the counter to track the resets
    counter++;
    
    //Iterate through all the boxes
    for (int i = 0; i < boxes.size(); i++) {
        
        //Only shuffle the position on a normal reset
        boxes.get(i).bx = int(random(width));
        boxes.get(i).by = int(random(height));
        
        //If the counter hits 5, reset the letters and sounds attached to them
        //you only get 12 of these, so spread them out accordingly
        if (counter >= 10) {
            boxes.get(i).letterNumber = int(random(65, 65 + 24));
            boxes.get(i).noteNumber =  boxes.get(i).letterNumber - 65;
            boxes.get(i).letter = char(boxes.get(i).letterNumber);
            boxes.get(i).arrayNumber = int(random(10));
            
            // Note resets. This is where the problems lie, so We'll revisit this later.
            boxes.get(i).boxNote.stop();
            boxes.get(i).boxNote = null;
            while(boxes.get(i).boxNote == null) {
                if (boxes.get(i).arrayNumber <= 3) {
                    SoundFile tempSound = new SoundFile(this, notes.get(boxes.get(i).noteNumber), false);
                    boxes.get(i).boxNote = tempSound;
                    tempSound = null;
                } else if (boxes.get(i).arrayNumber >= 4 && boxes.get(i).arrayNumber <= 7) {
                    SoundFile tempSound = new SoundFile(this, sounds.get(boxes.get(i).noteNumber), false);
                    boxes.get(i).boxNote = tempSound;
                    tempSound = null;
                } else if (boxes.get(i).arrayNumber >= 8) {
                    SoundFile tempSound = new SoundFile(this, sounds2.get(boxes.get(i).noteNumber), false);
                    boxes.get(i).boxNote = tempSound;
                    tempSound = null;
                }
            }
        }
    }
    // Reset the counter every 5 increments, and hopefully call the GC. God knows GC won't actually
    // do anything here. 
    if (counter >= 10) {
        counter = 0;
        System.gc();
        //exit();
    }
}

void serialEvent() {
    if (arduino.available() > 0) {
        arduino.readString();
        if (arduino.readString() != null) {
            //Increment the counter to track the resets
            counter++;
            
            //Iterate through all the boxes
            for (inti = 0; i < boxes.size(); i++) {
                
                //Only shuffle the position on a normal reset
                boxes.get(i).bx = int(random(width));
                boxes.get(i).by = int(random(height));
                
                //If thecounter hits 5, reset the letters and sounds attached to them
                //you only get 12 of these, so spread them out accordingly
                if (counter >= 10) {
                    boxes.get(i).letterNumber = int(random(65, 65 + 24));
                    boxes.get(i).noteNumber =  boxes.get(i).letterNumber - 65;
                    boxes.get(i).letter = char(boxes.get(i).letterNumber);
                    boxes.get(i).arrayNumber = int(random(10));
                    
                    // Note resets. This is where the problems lie, so We'll revisit this later.
                    boxes.get(i).boxNote.stop();
                    boxes.get(i).boxNote = null;
                    while(boxes.get(i).boxNote == null) {
                        if (boxes.get(i).arrayNumber <= 3) {
                            SoundFile tempSound = new SoundFile(this, notes.get(boxes.get(i).noteNumber), false);
                            boxes.get(i).boxNote = tempSound;
                            tempSound = null;
                        } else if (boxes.get(i).arrayNumber >= 4 && boxes.get(i).arrayNumber <= 7) {
                            SoundFile tempSound = new SoundFile(this, sounds.get(boxes.get(i).noteNumber), false);
                            boxes.get(i).boxNote = tempSound;
                            tempSound = null;
                        } else if (boxes.get(i).arrayNumber >= 8) {
                            SoundFile tempSound = new SoundFile(this, sounds2.get(boxes.get(i).noteNumber), false);
                            boxes.get(i).boxNote = tempSound;
                            tempSound = null;
                        }
                    }
                }
            }
            // Resetthe counter every 5 increments, and hopefully call the GC. God knows GC won't actually
            // do anything here. 
            if (counter >= 10) {
                counter = 0;
                System.gc();
                //exit();
            }
        }
    }
    
}

//Calibration Controls
void keyPressed() {
    if (keyCode == RIGHT) {
        maxDepth += 10;
    }
    if (keyCode == LEFT) {
        maxDepth -= 10;
    }
    if (keyCode == UP) {
        minDepth += 10;
    }
    if (keyCode == DOWN) {
        minDepth -= 10;
    }
}

void draw() {
    //Load masterImg pixel Array
    masterImg.loadPixels();
    
    //Interating/Switching Variables
    int k = 0;
    int image = 1;
    
    //Combo Loop
    for (int i = 0; i < masterImg.pixels.length; i++) {
        
        //Set up the current array at the start of the loop
        if (i ==  0) {
            image = 0;
            
            // Modulus to switch the array every other time. 
        } else if (i % (kinects.get(image).width * 2) == 0) {
            
            // check which array is selected
            if (image ==  0) {
                
                // if it's 0, switch images that we're indexing
                image = 1;
                
                /* Subtract the width of the image from K so K iterates over the same
                set of numbers twice each time. Use [k] to coontrol each image individually
                
                Only has to go back when going to the second image (one on the right) otherwise
                it can just keep going. */
                if (k > kinects.get(image).width) {
                    k -= kinects.get(image).width;
                }
                
            } else {
                
                // don't have to reset K when coming back to the first image
                image = 0;
                i += masterImg.width;
            }
        }
        
        //reset K if it reaches the end prematurely. 
        //This helps to solve OutOfBounds errors
        if (k >= currentArray.get(image).length) {
            k = 0;
        }
        
        int i2 = i + 1;
        int i3 = i + width;
        int i4 = i2 + width;
        //Assign depth values to Master image
        if (i + masterImg.width + 1 < masterImg.pixels.length) {
            if (currentArray.get(image)[k] >= minDepth && currentArray.get(image)[k] <= maxDepth) {
                masterImg.pixels[i] = color(255);
                masterImg.pixels[i2] = color(255);
                masterImg.pixels[i3] = color(255);
                masterImg.pixels[i4] = color(255);
            } else {
                masterImg.pixels[i] = color(0);
                masterImg.pixels[i2] = color(0);
                masterImg.pixels[i3] =  color(0);
                masterImg.pixels[i4] = color(0);
            }
            i++;
        }
        //Increment k
        k++;
    }
    
    //Update Master Image
    masterImg.updatePixels();
    
    //Display mirrored Master Image
    pushMatrix();
    scale( -1,1);
    image(masterImg, -masterImg.width, 0);
    popMatrix();
    
    
    //Physics for Boxes
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).lookUnder(masterImg);
        boxes.get(i).display();
        boxes.get(i).edgeBounce();
        boxes.get(i).collisionPoint();
        boxes.get(i).collisionVector();
    }
    
    //debugging purposes and performance checks
    fill(255);
    textSize(20);
    text(frameRate, 10, 10);
    strokeWeight(10);
    stroke(150, 150, 150);
    line(20, 60, 240, 60);
    stroke(255);
    line(20, 60, frameRate * 4, 60);
}
