/* public class PhysController{ 
        
        private Kinect kinect;

        private PImage deptghImage;
        private PImage tImage;

        private Body control;

        private float minDepth = 950;
        private float maxDepth = 2490;

        // Constructor. Returns a physics object? No idea how that's gonna work yet
        public PhysController () {
                controller(width, height);
        }

        private void threshImage(float x_, float y_){
                width = x_;
                height = y_;

                kinect = new Kinect(master);
                kinect.initDepth();

                depthImage = new PImage(kinect.width, kinect.height);

                image(kinet.getDepthImage(), 0, 0, width, height);

                int[] rawDepth = kinect.getRawDepth();
                for (int i=0; i < rawDepth.length; i++) {
                        if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
                                depthImage.pixels[i] = color(255);
                        } else {
                                depthImage.pixel[i] = color(0);
                        }
                    }

                depthImage.updatePixels();
                image(depthImage, kinect.width, 0);

        }

       // public PImage controller (this.threshImage) {
                
      //  } 


} */