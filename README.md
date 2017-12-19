# DRESS

Based off of Joe Mango's code for the DRESS system found here: https://github.com/JmangoITP/DRESS

The DRESS system is an early prototype to help caretakers of dementia patients take better care of their patients. Caretakers often find that patients have a difficult time getting dressed, and due to the private nature of the activity, caretakers often find friction when they are present to help their patients get dressed. The DRESS system aims to offer two solutions to this problem. The first solution is an automatic solution in which fiducial markers are on the patient's clothes and we use computer vision to detect when a garment is properly worn. The second solution is a manual solution in which the caretaker can observe the patient through telepresence and walk the patient through the process.  

The DRESS system can now:
* trigger lights to indicate which dresser to open
* read Fiducial markers using Reactivision (v. alpha)
* send video feeds to the caretaker interface

To begin, clone this repository. Open the MKR-1000 code to update the Arduino with your current WiFi Network ID & password (line 18-19)

Once the arduino has been updated, navigate to the directory and enter the following commands in your terminal:

    npm install
    node server

Once the server is running, navigate to your browser and enter the following URL for the caretaker's view:

    https://localhost:3000

For the patient's view, enter:

    https://localhost:3000/patient.html 

ToDo: 
- Get proper sound files for socks and shoes. Update the location of these sound files in /Dress-withWebRTC/public/js/patientWebRTC.js
- test multiple cameras. 2 - 3
    - move the camera controls on patient page to the caretaker.
- layout design 
- Update the TUIO code with the updated features in the webRTC code