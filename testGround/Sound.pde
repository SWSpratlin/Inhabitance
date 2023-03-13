public class Sound {

    private SoundFile sound;
    private String x;
    private Box body;
    private float yAmp;

    //Constructor
    public Sound(String file) {
        x = file;
        //Load whatever sound file is called in the constructor
        //TODO change this to an INT so a random position in an array can be input
        sound = new SoundFile(master, x);
    }

    //Play method, call this in [void setup()] to avoid playing a new instance every frame
    void play() {
        sound.play();
    }

    //Amplitude control via Y position of whatever box is input. Might need to stay this way
    //I'd like this to also be a random INT of an array, but it might be easier to call 40 individual
    //boxes and attach random sounds to them
    void boxAmp(Box body, int ySize) {
         
         //get pixel coordinates of the input body
         float aPos = body.getPixelCoordY();
         
         //equation to fit that number into a 0-1 scale for amplitute's sake
         yAmp = (((aPos - ySize) / (height - ySize)) * (1.0 - 0.0) + 0.00);
         
         //Apply this number to amplitude of the called file
         sound.amp(yAmp);

    }

}