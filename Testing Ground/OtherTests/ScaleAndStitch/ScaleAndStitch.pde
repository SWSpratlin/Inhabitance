//Import Point class, important
import java.awt.Point; 

//Import Sound library. Important for NoteTrack to work
import processing.sound.*;

// Serial Class for Processing
import processing.serial.*;

// name the PApplet master so we can refernce in other classes
public PApplet master = this;

//Create a PImage that will color the pixels around the mouse
PImage testImg1;
PImage testImg2;
PImage masterImg;

//Zero out mouse location variable to start
int mouseLoc = 0;
int boxNumber;
int counter = 0;
//Call the Box Array
ArrayList<Box> boxes;
ArrayList<PImage> currentArray = new ArrayList<PImage>(2);

ArrayList<String> notes;
ArrayList<String> sounds;
ArrayList<String> sounds2;


void setup() {
    //Set size, 1280
    size(1000, 500, P2D);
    
    //Set number of boxes to spawn
    boxNumber = 60;
    
    //intialize the box array
    boxes = new ArrayList<Box>(boxNumber);
    
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
    
    //initialize the boxes
    for (int i = 0; i < boxNumber; i++) {
        Box tmpBox = new Box(int(random(width)), int(random(height)), 20, 20, 130);
        tmpBox.getCoord();
        //tmpBox.loadNote();
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
        boxes.add(tmpBox);
    }
    
    //load the images to memory
    testImg1 = loadImage("250_img1.jpg");
    testImg2 = loadImage("250_img2.jpg");
    masterImg = createImage(testImg1.width * 4, testImg1.height * 2, RGB);
    
    //Put the images into an array
    currentArray.add(testImg1);
    currentArray.add(testImg2);
    
}

//Reset function for mouse click. Also randomizes letters
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
        if (counter >= 5) {
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
    if (counter >= 5) {
        counter = 0;
        System.gc();
        //exit();
    }
}

void draw() {
    
    //Switching Block
    int k = 0;
    int image = 0;
    
    masterImg.loadPixels();
    
    for (int i = 0; i < masterImg.pixels.length; i++) {
        if (i == 0) {
            image = 0;
        } else if (i % (currentArray.get(image).width * 2) == 0) {
            if (image == 0) {
                image = 1;
                k -= currentArray.get(image).width;
            } else {
                image = 0;
                i += masterImg.width;
            }
        }
        if (k >= currentArray.get(image).pixels.length) {
            k = 0;
        }
        
        int i2 = i + 1;
        int i3 = i + width;
        int i4 = i2 + width;
        
        if (i + masterImg.width + 1 < masterImg.pixels.length) {
            masterImg.pixels[i] = currentArray.get(image).pixels[k];
            masterImg.pixels[i2] = currentArray.get(image).pixels[k];
            masterImg.pixels[i3] = currentArray.get(image).pixels[k];
            masterImg.pixels[i4] = currentArray.get(image).pixels[k];
            i++;
        }
        int mouseLoc = mouseX + mouseY * width;
        int mouseLoc2 = mouseLoc + 1;
        int mouseLoc3 = mouseLoc + width;
        int mouseLoc4 = mouseLoc2 + width;
        if (mouseLoc4 < masterImg.pixels.length) {
            masterImg.pixels[mouseLoc] = color(255);
            masterImg.pixels[mouseLoc2] = color(255);
            masterImg.pixels[mouseLoc3] = color(255);
            masterImg.pixels[mouseLoc4] = color(255);
        }
        k++;
    }
    masterImg.updatePixels();
    pushMatrix();
    scale( -1,1);
    image(masterImg, -masterImg.width,0);
    popMatrix();
    
    
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).lookUnder(masterImg);
        boxes.get(i).collisionPoint();
        boxes.get(i).collisionVector();
        boxes.get(i).edgeBounce();
        boxes.get(i).display();
    }
    
    // Print the framerate to the window for Performance check purposes. 
    textSize(50);
    text(frameRate, 100, 100);
    stroke(255);
    strokeWeight(10);
    line(110, 110, frameRate * 4, 110);
    text(counter, 20, 150);
}