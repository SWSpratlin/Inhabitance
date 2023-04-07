PImage jay;
PImage tony;
PImage master;

ArrayList<PImage> currentArray = new ArrayList<PImage>(2);


void setup() {
    size(1000,500);
    
    jay = loadImage("jay.JPG");
    tony = loadImage("tony.jpg");
    master = createImage(1000,500,RGB);
    
    currentArray.add(jay);
    currentArray.add(tony);
    
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
        // Animation goes here
        currentArray.get(image).pixels[k] += 1;
        
        // Assign pixels to master
        master.pixels[i] = currentArray.get(image).pixels[k];
        k++;
    }
    master.updatePixels();
    //only displaying the master image
    image(master,0,0);
    
    textSize(50);
    text(frameRate, 20, 20);
}