#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxCoreMotion.h"


#include "ofxQCAR.h"
#include "Teapot.h"
#include "ofxOsc.h"
#include "UI.h"

//#define HOST "10.0.0.6"
//#define PORT 8000

class testApp : public ofxQCAR_App,ofxiPhoneMapKit {
	
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
    
    ofxOscSender sender;
  //  ofxOscReceiver receiver;
    int lastTime;
    
    ofxiPhoneMapKit mapKit;
    
    // optional callbacks for Map related events
//    void regionWillChange(bool animated);
//    void regionDidChange(bool animated);
//    void willStartLoadingMap();
//    void didFinishLoadingMap();
//    void errorLoadingMap(string errorDescription);
    
    void enableGyro();
    void getDeviceGLRotationMatrix();
    
    ofxCoreMotion coreMotion;
    ofQuaternion quat;
    
    vector<UI> objects;

};


