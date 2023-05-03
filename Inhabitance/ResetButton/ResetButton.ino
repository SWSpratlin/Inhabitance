// Simple Sketch to run a reset button for Inhabitance
#define SENSORPIN A0
#define THRESHOLD 400
// #define DELAYTIME 250

bool isPressed = false;

bool sensorState = false;
bool lastSensorState = false;

int sensorValue = 0;

void setup()
{
    Serial.begin(115200);
}

void loop()
{

    // Read the Analog Pin defined above. Assign value to SensorValue
    sensorValue = analogRead(SENSORPIN);

    // Trigger the Boolean if the sensor value is above a certain threshold
    if (sensorValue > THRESHOLD)
    {
        isPressed = true;
    }
    else
    {
        isPressed = false;
    }

    // Update the current State variable
    sensorState = isPressed;

    // check if the sensor state has changed from the last recorded state
    if (sensorState != lastSensorState && isPressed == true)
    {
        // the sensor values change frequently, so an additional if statement
        //  catches the changes under a certain threshold.
        // if we meet the reqs, print string CHANGE. This will be fed to Processing
        Serial.write("CHANGE");
        delay(100);
        }

    // Add a delay to keep the code from tripping over itself with the if statements
    delay(100);

    // Update the last state variable to check itself back later.
    lastSensorState = sensorState;
}