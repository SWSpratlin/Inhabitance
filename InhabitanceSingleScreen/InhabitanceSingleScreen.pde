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
float maxDepth = 960;

//Kinects to Interate through
Kinect kinect;

//Boxes and Notes to assign
ArrayList<Box> boxes;
ArrayList<String> notes;
ArrayList<String> sounds;
ArrayList<String> sounds2;

//Number of Boxes to spawn
int boxNumber = 70;

// Reset Counter to space out sound object creation
int counter = 0;

//Device variables
int numDevices = 0;

void setup() {
    // Size. Width has to be double the width of a Kinect
    // This lets 2 Kinect feeds populate next to each other
    // Scale by 2 to increase size
    fullScreen(P2D, SPAN);
    size(640 * 2,480 * 2, P2D);
    surface.setLocation(0,0);
    
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
    kinect = new Kinect(this);
    kinect.activateDevice();
    kinect.initDepth();
    
    //Initialize Box Array
    boxes = new ArrayList<Box>(boxNumber);
    
    //Create Letters
    for (int i = 0; i < boxNumber; i++) {
        
        //Temp Boxes, spawn at random places on screen
        Box tmpBox = new Box(int(random(width)), int(random(height)), 15, 15, 0);
        
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
    arduino = new Serial(this, Serial.list()[7], 115200);
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

void resetButton() {
    if (arduino.available() > 0) {
        arduino.readString();
        if (arduino.readString() == null) {
            //Increment the counter to track the resets
            counter++;
            
            //Iterate through all the boxes
            for (int i = 0; i < boxes.size(); i++) {
                
                //Only shuffle the position on a normal reset
                boxes.get(i).bx = int(random(width));
                boxes.get(i).by = int(random(height));
                
                //If thecounter hits 5, reset the letters and sounds attached to them
                //you only get 12 of these, so spread them out accordingly
                if (counter >= 15) {
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
        println(arduino.available() + "data: " + arduino.readString());
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
    int[] rawDepth = kinect.getRawDepth();
    
    //Second iterating variable. 
    int k = 0;
    
    //Iterate through MasterImg pixel array
    for (int i = 0; i < masterImg.pixels.length; i++) {
        
        // CatchK if it is heading towards an OOB
        if (k >= rawDepth.length) {
            k = 0;
        }
        
        //Check for potential OOB errors
        if ((i + 1 + masterImg.width) < masterImg.pixels.length) {
            
            //Scaling variables
            int i2 = i + 1;
            int i3 = i + width;
            int i4 = i2 + width;
            
            //Run Threshold statement
            if (rawDepth[k] >= minDepth && rawDepth[k] <= maxDepth) {
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
            //Increment i to cover the i2 variable
            i++;
            
            /*
            if K has reached the end of a line of pixels in the kinect image (that is being scaled)
            increment i to cover the i3 and i4 variables, which have already been filled. 
            This essentially skips a row of pixels, since we're filling two at once.
            */
            if (k % kinect.width == 0) {
                i += masterImg.width;
            }
        }
        //Increment K to pull the next index from rawDepth
        k++;
    }
    
    // UpdateMaster Image
    masterImg.updatePixels();
    
    // Display mirrored Master Image
    pushMatrix();
    scale( -1,1);
    image(masterImg, -masterImg.width, 0);
    popMatrix();
    
    //call the resent button function for the arduino9    
    resetButton();
    
    // Physics for Boxes
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).lookUnder(masterImg);
        boxes.get(i).display();
        boxes.get(i).edgeBounce();
        boxes.get(i).collisionPoint();
        boxes.get(i).collisionVector();
    }
    
    //debugging purposes and performance checks
    // fill(255);
    // textSize(20);
    // text(frameRate, 10, 10);
    // strokeWeight(10);
    // stroke(150, 150, 150);
    // line(20, 60, 240, 60);
    // stroke(255);
    // line(20, 60, frameRate * 4, 60);
}
