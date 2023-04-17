/* Test purely to see if I can get 2 Kinect cameras operational at the same time
This will be paired with the loops in PIMageStitch to combine them into one single

#TODO - Write ArrayList for Kinects
#TODO - Stitch Kinect PImages together
#TODO - Solve scaling problem
#TODO - Implement Box Class
#TODO - Implement Sound
*/


//Importing relevant libraries
import processing.sound.*;
import java.awt.Point;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

ArrayList<Kinect> kinects = new ArrayList<Kinect>();

PImage master;

int deviceIndex = 0;
int numDevices = 0;

void setup() {
    //Size of two kinect feeds
    size(1280, 480);
    
    numDevices = Kinect.countDevices();
    
    for (int i = 0; i < 2; i++) {
        Kinect tempKinect = new Kinect(this);
        tempKinect.activateDevice(i);
        tempKinect.initDepth();
        kinects.add(tempKinect);
    }
    
    master = createImage(width, height);
    
}

void draw() {
    int k = 0;
    
    master.loadPixels();
    
    for (int i = 0; i < master.pixels.length; i++) {
        
        if (i ==  0) {
            deviceIndex = 0;
        } else if (i % kinects.get(deviceIndex).width ==  0) {
            if (deviceIndex == 0) {
                deviceIndex = 1;
                if (k > kinects.get(deviceIndex).width) {
                    k -= kinect.get(deviceIndex).width;
                }
            } else {
                deviceIndex = 0;
            }
        }
        
    }
}