import processing.sound.*;

ArrayList<SoundFile> notes; 
int colorVar = 0;

boolean keyPress = false;

void setup() {
    size(500,500);
    
    notes = new ArrayList<SoundFile>();
    SoundFile aNote = new SoundFile(this, "A__1.wav", false);
    notes.add(aNote);
    SoundFile bNote = new SoundFile(this, "B__1.wav", false);
    notes.add(bNote);
    SoundFile cNote = new SoundFile(this, "C__1.wav", false);
    notes.add(cNote);
    SoundFile dNote = new SoundFile(this, "D__1.wav", false);
    notes.add(dNote);
    SoundFile eNote = new SoundFile(this, "E__1.wav", false);
    notes.add(eNote);
    SoundFile fNote = new SoundFile(this, "F__1.wav", false);
    notes.add(fNote);
    SoundFile gNote = new SoundFile(this, "G__1.wav", false);
    notes.add(gNote);
    SoundFile hNote = new SoundFile(this, "H__1.wav", false);
    notes.add(hNote);
    SoundFile iNote = new SoundFile(this, "I__1.wav", false);
    notes.add(iNote);
    SoundFile jNote = new SoundFile(this, "J__1.wav", false);
    notes.add(jNote);
    SoundFile kNote = new SoundFile(this, "K__1.wav", false);
    notes.add(kNote);
    SoundFile lNote = new SoundFile(this, "L__1.wav", false);
    notes.add(lNote);
    SoundFile mNote = new SoundFile(this, "M__1.wav", false);
    notes.add(mNote);
    SoundFile nNote = new SoundFile(this, "N__1.wav", false);
    notes.add(nNote);
    SoundFile oNote = new SoundFile(this, "O__1.wav", false);
    notes.add(oNote);
    SoundFile pNote = new SoundFile(this, "P__1.wav", false);
    notes.add(pNote);
    SoundFile qNote = new SoundFile(this, "Q__1.wav", false);
    notes.add(qNote);
    SoundFile rNote = new SoundFile(this, "R__1.wav", false);
    notes.add(rNote);
    SoundFile sNote = new SoundFile(this, "S__1.wav", false);
    notes.add(sNote);
    SoundFile tNote = new SoundFile(this, "T__1.wav", false);
    notes.add(tNote);
    SoundFile uNote = new SoundFile(this, "U__1.wav", false);
    notes.add(uNote);
    SoundFile vNote = new SoundFile(this, "V__1.wav", false);
    notes.add(vNote);
    SoundFile wNote = new SoundFile(this, "W__1.wav", false);
    notes.add(wNote);
    SoundFile xNote = new SoundFile(this, "X__1.wav", false);
    notes.add(xNote);
    SoundFile yNote = new SoundFile(this, "Y__1.wav", false);
    notes.add(yNote);
    SoundFile zNote = new SoundFile(this, "Z__1.wav", false);
    notes.add(zNote);
    
}

void draw() {
    background(130);
    strokeWeight(15);
    stroke(0);
    fill(key);
    rectMode(CENTER);
    rect(width / 2, height / 2, 100, 100);
    
    float varAmp = map(mouseY, 0, height, 0, 1);
    if (key >= 97 && key <= 122 && notes.get(key - 97).isPlaying() == false && keyPress == true) {
        notes.get(key - 97).play();
        notes.get(key - 97).amp(varAmp);
    }
    
    textSize(30);
    text(key, 250, 50);
    int charInt = key;
    text(charInt, 250, 100);
}

void keyPressed() {
    keyPress = true;
}

void keyReleased() {
    keyPress = false;
}