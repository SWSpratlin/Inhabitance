PImage jay;
PImage tony;
PImage master;

void setup() {
    size(1000,500);
    
    jay = loadImage("jay.JPG");
    tony = loadImage("tony.jpg");
    master = createImage(1000,500,RGB);
    
}

void draw() {
    master.loadPixels();
    jay.loadPixels();
    tony.loadPixels();
    
    for (int i = 0; i < jay.pixels.length; i++) {
        jay.pixels[i] += 1;
    }
    
    for (int i = 0; i < tony.pixels.length; i++) {
        tony.pixels[i] -= 1;
    }
    
    int i = 0;
    int a = 0;
    int b = 0;
    
    for (int y = 0; y < jay.height; y++) {
        for (int x = 0; x < jay.width; x++) {
            master.pixels[i] = jay.pixels[a];
            a++;
            i++;
        }
        for (int u = 0; u < tony.width; u++) {
            master.pixels[i] = tony.pixels[b];
            b++;
            i++;
        }
    }
    master.updatePixels();
    image(master,0,0);
    
}