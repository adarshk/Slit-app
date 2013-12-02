#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "ofxQCAR.h"
#include "Teapot.h"
//#include "ofxOsc.h"

#define HOST "10.0.0.6"
#define PORT 8000

class testApp : public ofxQCAR_App {
	
public:
    void setup();
    void update();
    void draw();
    void exit();
    
    void qcarInitialised();
    bool scanTarget();
    bool saveTarget();
    bool isScanning();
    bool isTracking();
	
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    ofImage teapotImage;
    
    ofDirectory DIR;
    int nImages,nSounds;
    ofImage *images;
    ofImage imgC;
    int currentImage;
    bool testMode;
    
    ofVec2f mPos,mCorner;
    
    ofRectangle imageBox;
    
    bool mainMenu;
    bool text;
    bool img;
    bool sound;
    
    bool tag;
    bool trigger;
    bool tuck;
    
    bool led;
    bool speaker;
    bool motor;
    
    int audx,audy;
    
    ofSoundPlayer synth;
    
    ofxiPhoneKeyboard *keyboard;
    
    ofTrueTypeFont audimat;
    
 //   ofxOscSender sender;
    
};


