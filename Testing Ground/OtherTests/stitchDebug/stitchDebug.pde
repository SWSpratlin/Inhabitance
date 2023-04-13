PImage first;
PImage second;
PImage master;

ArrayList<PImage> currentArray = new ArrayList<PImage>();

int image = 0;
int k = 0;

void setup(){
  size(20, 10);
  
  first = createImage(10, 10, RGB);
  first.loadPixels();
  for (int i =0; i < first.pixels.length; i++){
    first.pixels[i] = color(150, 150, 40);
  }
  first.updatePixels();
  
  second = createImage(10,10, RGB);
  second.loadPixels();
  for (int i =0; i < second.pixels.length; i++){
    second.pixels[i] = color(30);
  }
  
  master = createImage(width, height, RGB);
  
  currentArray.add(first);
  currentArray.add(second);
}

void draw() {
  master.loadPixels();
  
  for(int i = 0; i< master.pixels.length; i++){ //<>//
   if (k >= currentArray.get(image).pixels.length) {
          k = 0;
        } else {
        k++;
        } 
        
    
    if (i ==0) {
      image = 0;
    } else if (i % currentArray.get(image).width == 0) {
      if (image == 0){
      image = 1;
      
        k -= currentArray.get(image).width; //<>//
      
    } else {
      image = 0;
      //i += master.width;
    }
   }
   first.pixels[k] = color((map(mouseX, 0, width, 0, 255)), 150, 200);
   second.pixels[k] = color((map(mouseY, 0, height, 0, 255)), 50, 160);
   
   //if (i + master.width +1 <master.pixels.length){ //<>//
      master.pixels[i] = currentArray.get(image).pixels[k];
      //master.pixels[i + 1] = currentArray.get(image).pixels[k];
     // master.pixels[i + master.width + 1] = currentArray.get(image).pixels[k];
      //master.pixels[i + master.width + 2] = currentArray.get(image).pixels[k];
   //}
    //<>//
  }
  master.updatePixels();
  image(master,0,0);
}
