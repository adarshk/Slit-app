ofxQCAR is an OpenFrameworks wrapper for Qualcomm's Vuforia (QCAR). https://developer.vuforia.com

ofxQCAR wraps Vuforia SDK 2.0.32 and has been tested on OpenFrameworks 008.

The example project should get you up and running very quickly, although if you need to start your own XCode project from scratch, you will need to add the following frameworks to your XCode project.

1) Security.framework 2) SystemConfiguration.framework 3) CoreMotion.framework


SLIT:

An app that uses Augmented reality to Tag any object with images,sound & text or control any sensors on an arduino using gestures.


Slit is an app (currently on iOS) that enables anyone to interact with any objects using augmented reality. The app has a number of modes which serve different purpose depending on the object. The app is based on the concept of active vs passive objects.

By default all objects that are detected are passive objects which can be tagged with text,images or sound. A different user running the same app on their device can view the same image (or text or sound) when the same object is detected in the app.

An active object is any object that can communicate back with the app so that it can be remotely triggered. For example an arduino can be triggered for controlling the sensors attached to it like LEDs, speakers , servos etc.

The user can also connect multiple objects using touch gestures and set rules to trigger certain objects according to the state of another object. For example, two speakers are connected by drawing a line between them to play the same audio on both speakers. A rule can be set to dim the LED when the song is played. The possibilities are endless and only limited by the sensors attached to the arduino which is controlled by the app.

Slit app is based on ofxQCAR which is Qualcomm's AR addon for openframeworks made possible by https://github.com/julapy/ofxQCAR


The app has the following modes:

Tag mode which is used to tag objects with images,sound or text
Trigger mode which is used for triggering any sensors on an Arduino
Tuck mode which is used for playing multiplayer games between 2 or more people present in the same physical space detecting the same objects.

ICM, physical computing, augmented reality, AR, iOS