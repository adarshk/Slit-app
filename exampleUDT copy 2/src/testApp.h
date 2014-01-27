#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "ofxOpenCv.h"

#include "ofxCoreMotion.h"


#include "ofxQCAR.h"
#include "Teapot.h"
#include "ofxOsc.h"
#include "UI.h"
#include "Ball.h"
#include "Mario.h"

#define HOST "128.122.151.166"
#define HOST2 "192.168.2.2"
#define PORT 8000
#define PORT2 12000

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
    
    void drawObjects();
    
    ofImage teapotImage;
    ofImage marioSprite;
    
    ofDirectory DIR,DIR2;
    int nImages,nSounds;
    ofImage *images;
    ofImage imgC;
    int currentImage;
    bool testMode;
    ofSoundPlayer *sounds;
    int currentSound;
    
    
    ofVec2f mPos,mCorner;
    
    ofRectangle imageBox;
    
    bool back;
    bool backTouched;
    bool startMenu;
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
    bool gameController;
    
    bool selected;
    
    int audx,audy;
    
    ofSoundPlayer synth;
    
    ofxiPhoneKeyboard *keyboard;
    
    ofTrueTypeFont audimat;
    
    ofxOscSender sender,sender2;
    ofxOscReceiver receiver;
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
    
    vector<UI> mainMenuElements;
    vector<UI> childrenElements;
    vector<string> elementsText;
    ofPoint mainCircle;
    float m;
    int subtract;
    bool activeObjects;
    int su=0;
    
    string tx = "";
    
    int numActiveObjects;
    
    int testCurrentImage = 0;
    
    string receivedText="";
    
    vector<Ball> balls;
    
    Mario mr;

    
    int mariox = 0;
    int marioy=500;
    
    ofImage gameboy;
    
    string mark="";
    bool chips= false;
    int xinc = 100;int yinc=100;
    
    
    bool up=false;
    bool down=true;
    bool left = false;
    bool right = false;
    
    int tempIncx=100,tempIncY=100;
};


