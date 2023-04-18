
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

int minDepth = 200;
int maxDepth = 800;

PImage depthImg;

void setup() {
    kinect = new Kinect(this);
    size(640,480);
    kinect.initDepth();
    
    depthImg = new PImage(kinect.width, kinect.height);
    
}

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
    image(kinect.getDepthImage(), 0,0);
    
    int[] rawDepth = kinect.getRawDepth();
    depthImg.loadPixels();
    for (int i = 0; i < rawDepth.length; i++) {
        if (rawDepth[i] >= minDepth && rawDepth[i] <=  maxDepth) {
            depthImg.pixels[i] = color(255);
        } else{
            depthImg.pixels[i] = color(0);
        }
    }
    
    depthImg.updatePixels();
    image(depthImg, 0, 0, width, height);
    
    textSize(55);
    fill(150);
    strokeWeight(5);
    stroke(0);
    text(minDepth, 10,50);
    text(maxDepth, 10, 100);
}