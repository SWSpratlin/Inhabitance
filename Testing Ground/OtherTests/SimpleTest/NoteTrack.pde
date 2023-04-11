class NoteTrack{
    // ---- pull sound file from Data folder
    // pull isColliding from Box
    // pull Box y Coordinate
    // convert box coordinate from big number to value between 0 and 1
    // assign the sound.amp() that number
    // call this class in the Box constructor
    // write methods for Amp Control and Note Attach
    
    // Variable Amp variable
    float variableAmp = 0;
    
    // Declare the array
    ArrayList<SoundFile> notes; 
    ArrayList<String> noteNames;
    
    // Class variable that will allow for the consistent control of one of the sound files
    int noteNumber;
    
    NoteTrack(int _noteNumber) {
        
        // Load all sound files into an array
        notes = new ArrayList<SoundFile>();
        SoundFile aNote = new SoundFile(master, "A__1.wav", false);
        notes.add(aNote);
        SoundFile bNote = new SoundFile(master, "B__1.wav", false);
        notes.add(bNote);
        SoundFile cNote = new SoundFile(master, "C__1.wav", false);
        notes.add(cNote);
        SoundFile dNote = new SoundFile(master, "D__1.wav", false);
        notes.add(dNote);
        SoundFile eNote = new SoundFile(master, "E__1.wav", false);
        notes.add(eNote);
        SoundFile fNote = new SoundFile(master, "F__1.wav", false);
        notes.add(fNote);
        SoundFile gNote = new SoundFile(master, "G__1.wav", false);
        notes.add(gNote);
        SoundFile hNote = new SoundFile(master, "H__1.wav", false);
        notes.add(hNote);
        SoundFile iNote = new SoundFile(master, "I__1.wav", false);
        notes.add(iNote);
        SoundFile jNote = new SoundFile(master, "J__1.wav", false);
        notes.add(jNote);
        SoundFile kNote = new SoundFile(master, "K__1.wav", false);
        notes.add(kNote);
        SoundFile lNote = new SoundFile(master, "L__1.wav", false);
        notes.add(lNote);
        SoundFile mNote = new SoundFile(master, "M__1.wav", false);
        notes.add(mNote);
        SoundFile nNote = new SoundFile(master, "N__1.wav", false);
        notes.add(nNote);
        SoundFile oNote = new SoundFile(master, "O__1.wav", false);
        notes.add(oNote);
        SoundFile pNote = new SoundFile(master, "P__1.wav", false);
        notes.add(pNote);
        SoundFile qNote = new SoundFile(master, "Q__1.wav", false);
        notes.add(qNote);
        SoundFile rNote = new SoundFile(master, "R__1.wav", false);
        notes.add(rNote);
        SoundFile sNote = new SoundFile(master, "S__1.wav", false);
        notes.add(sNote);
        SoundFile tNote = new SoundFile(master, "T__1.wav", false);
        notes.add(tNote);
        SoundFile uNote = new SoundFile(master, "U__1.wav", false);
        notes.add(uNote);
        SoundFile vNote = new SoundFile(master, "V__1.wav", false);
        notes.add(vNote);
        SoundFile wNote = new SoundFile(master, "W__1.wav", false);
        notes.add(wNote);
        SoundFile xNote = new SoundFile(master, "X__1.wav", false);
        notes.add(xNote);
        SoundFile yNote = new SoundFile(master, "Y__1.wav", false);
        notes.add(yNote);
        SoundFile zNote = new SoundFile(master, "Z__1.wav", false);
        notes.add(zNote);
        
        // Call the specific one you want, change the object variable to be specific for each object
        noteNumber = _noteNumber;
        
        // subtract 65 to match the ASCII values with array indecies
        noteNumber -= 65; 
    }
    
    //standard play function
    void play(int _noteNumber) {
        int playNumber = _noteNumber - 65;
        notes.get(playNumber).play();
    }
    
    void jump(int _noteNumber, int jumpTime) {
        int jumpNumber = _noteNumber - 65;
        notes.get(jumpNumber).jump(jumpTime);
    }
    
    void stop(int _noteNumber) {
        int stopNumber = _noteNumber - 65;
        notes.get(stopNumber).stop();
    }
    
    //check for playing
    boolean isPlaying(int _noteNumber) {
        int playCheck = _noteNumber - 65;
        return notes.get(playCheck).isPlaying();
    }
    
    
    float variableAmplitude(int yPosition, int _noteNumber) {
        
        // calculate the Amplitude depending on the y position of the box
        int ampNumber = _noteNumber - 65;
        
        //so convenient. 
        variableAmp = map(yPosition, 0, height, 0, 1);
        
        //assign the amplitude to the file
        notes.get(ampNumber).amp(variableAmp);
        
        //troubleshooting purposes. Pushes the variableAmp float
        return variableAmp;
    }
    
    void setAmp(float setAmp) {
        notes.get(noteNumber).amp(setAmp);
    }
    
    
    //Purely for debugging
    String getFile(int _noteNumber) {
        int nameNumber = _noteNumber - 65;
        noteNames = new ArrayList<String>();
        noteNames.add("A");
        noteNames.add("B");
        noteNames.add("C");
        noteNames.add("D");
        noteNames.add("E");
        noteNames.add("F");
        noteNames.add("G");
        noteNames.add("H");
        noteNames.add("I");
        noteNames.add("J");
        noteNames.add("K");
        noteNames.add("L");
        noteNames.add("M");
        noteNames.add("N");
        noteNames.add("O");
        noteNames.add("P");
        noteNames.add("Q");
        noteNames.add("R");
        noteNames.add("S");
        noteNames.add("T");
        noteNames.add("U");
        noteNames.add("V");
        noteNames.add("W");
        noteNames.add("X");
        noteNames.add("Y");
        noteNames.add("Z");
        return noteNames.get(nameNumber);
    }
}