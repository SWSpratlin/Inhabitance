# Thesis_TestingGrounds
 Testing Grounds for my thesis project

Unsure what use anyone else will have for this, but here it is.

CHANGELOG

04/27/2023
Cleanup and Adding "ScaleAndStitch" testing file
- Solved scaling issues
- solved mirroring issues
- deleted unused testing files to free up Data space
- Implemented ScaleAndStitch to solve mirroring and scaling simultanously
- Added "loadNote()" method to Box Class to handle randomization of Sound sets
- Added additional sound set in "sounds" array
- Moved initialization of Sound arrays into Box constructor

04/05/2023
Added SimpleTest sketch for easier testing
- Fixed collision detection (mostly)
- Fixed Edge Bounce method to actually function
- added Ramdon letter generation to the Box class
- Started writing Sound class

03/23/2023
Added Testing Ground folder, reorganized files
- Added different iterations of VideoCollision for work on both Intel(Laptop) and Apple Silicon(Destkop)
- Added library files for Box2D and OpenKinect
- restructured testing grounds for clarity/ease of Use
- Started using Testing Grounds for the actual purpose. 

03/21/2023
Updated to include VideoCollisionTest1 folder, including the Box class 

See change history for VideoCollision2 for more details about changes. 
- vector motion, simple collision
- stable "lookUnder" monitoring
- optimized PImage pixel array search 

03/13/2023
Created Repository, added PDE Files and .WAV files to one master folder. 

TODO Optimize Collision Point calculation and vector generation
