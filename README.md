ofxQCAR is an OpenFrameworks wrapper for Qualcomm's Vuforia (QCAR). https://developer.vuforia.com

ofxQCAR wraps Vuforia SDK 2.0.32 and has been tested on OpenFrameworks 008.

The example project should get you up and running very quickly, although if you need to start your own XCode project from scratch, you will need to add the following frameworks to your XCode project.

1) Security.framework 2) SystemConfiguration.framework 3) CoreMotion.framework


SLIT:

Slit app is based on ofxQCAR which is Qualcomm's AR addon for openframeworks made possible by https://github.com/julapy/ofxQCAR

The app has the following modes:

Tag mode which is used to tag objects with images,sound or text
Trigger mode which is used for triggering an Arduino
Tuck mode which is used for playing multiplayer games present in the same physical space