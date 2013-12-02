#include "testApp.h"

ofxQCAR * qcar = NULL;

//--------------------------------------------------------------
void testApp::setup(){	
	ofBackground(0);
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
    //ofSetOrientation(OF_ORIENTATION_90_LEFT);
    
    mainMenu = true;
    text = false;
    img = false;
    sound = false;
    tag = false;
    trigger = false;
    tuck = false;
    led = false;
    speaker=false;
    motor = false;
    audx=75;
    audy=100;
    
    //sender.setup(HOST, PORT);
    
    
    nImages = DIR.listDir("images/of_logos");
    images = new ofImage[nImages];
    
    for (int i=0; i<nImages; i++) {
        images[i].loadImage(DIR.getPath(i));
    }
    currentImage=0;
    
    imgC.loadImage("cat.jpg");
    
    synth.loadSound("sounds/1085.caf");
    synth.setVolume(0.75f);
    //synth.setMultiPlay(true);
    synth.setLoop(true);
    
    audimat.loadFont("audimat.otf", 20);
    audimat.setLineHeight(34.0f);
    audimat.setLetterSpacing(1.037);
    
    keyboard = new ofxiOSKeyboard(0,52,320,32);
    keyboard->setVisible(true);
    keyboard->setBgColor(255, 255, 255, 255);
	keyboard->setFontColor(0,0,0, 255);
	keyboard->setFontSize(26);
    
    
    teapotImage.loadImage("qcar_assets/TextureTeapotBrass.png");
    teapotImage.mirror(true, false);  //-- flip texture vertically since the texture coords are set that way on the teapot.
    
    qcar = ofxQCAR::getInstance();
    qcar->addTarget("Qualcomm.xml", "Qualcomm.xml");
    qcar->autoFocusOn();
    qcar->setCameraPixelsFlag(false);
    qcar->setup();
    qcar->setMaxNumOfMarkers(2);
    testMode = false;
}

void testApp::qcarInitialised() {
    scanTarget();
}

bool testApp::scanTarget() {
    qcar->scanCustomTarget();
    return true;
}

bool testApp::saveTarget() {
    if(qcar->hasFoundGoodQualityTarget()) {
        qcar->saveCustomTarget();
        return true;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Low Quality Image"
                                                        message:@"The image has very little detail, please try another."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    [alertView show];
    [alertView release];
    
    return false;
}

bool testApp::isScanning() {
    return qcar->isScanningCustomTarget();
}

bool testApp::isTracking() {
    return qcar->isTrackingCustomTarget();
}

//--------------------------------------------------------------
void testApp::update(){
    qcar->update();
    ofSoundUpdate();
}

//--------------------------------------------------------------
void testApp::draw(){
    
    qcar->draw();

    if(qcar->isScanningCustomTarget()) {
        int screenW = ofGetWidth();
        int markerW = screenW * 0.9;
        ofRectangle markerRect(0, 0, markerW, markerW);
        markerRect.x = (int)((ofGetWidth() - markerRect.width) * 0.5);
        markerRect.y = (int)((ofGetHeight() - markerRect.height) * 0.5);
        
        ofPushStyle();
        ofNoFill();
        ofSetLineWidth(3);
        if(qcar->hasFoundGoodQualityTarget()) {
            ofSetColor(ofColor::green);
        } else {
            ofSetColor(ofColor::red);
        }
        ofRect(markerRect);
        ofPopStyle();
    }
    
    if(qcar->hasFoundMarker()) {

        ofSetColor(ofColor::yellow);
        qcar->drawMarkerBounds();
        ofSetColor(ofColor::cyan);
        qcar->drawMarkerCenter();
        qcar->drawMarkerCorners();
        
        ofSetColor(ofColor::white);
        ofSetLineWidth(1);
        
        mPos = qcar->getMarkerCenter();
        mCorner = qcar->getMarkerCorner(OFX_QCAR_MARKER_CORNER_TOP_RIGHT);
        imageBox = qcar->getMarkerRect();
        
        if (mainMenu) {
        
            
            
            ofSetHexColor(0xff6b4f);
            
                        ofCircle(100, ofGetHeight()-150, 75);
            //imgC.draw(100, ofGetHeight()-150, 70, 70);
            
            
            ofCircle(300, ofGetHeight()-150, 75);
            //ofSetHexColor(0x00ccff);
            ofCircle(500, ofGetHeight()-150, 75);
            //            ofDrawBox(500, ofGetHeight()-150, 0, 50, 50, 50);
            
            
            //ofNoFill();
            //            ofSetColor(255*rand(), 255*rand(), 255*rand());
            //            for (int r = 500; r<550; r+=10) {
            //            ofRect(r, ofGetHeight()-150, 50, 50);
            //            }
            
            
            ofSetColor(ofColor::white);
            audimat.drawString("Tag", 75, ofGetHeight()-125);
            
            //            ofDrawBitmapString("Images", 75, ofGetHeight()-125);
            //            ofDrawBitmapString("Sound",275, ofGetHeight()-125);
            //            ofDrawBitmapString("Text", 475, ofGetHeight()-125);
            
            audimat.drawString("Trigger", 275, ofGetHeight()-125);
            audimat.drawString("Tuck", 475, ofGetHeight()-125);
        
        
        }
            
            if(tag){
                
        audimat.setLineHeight(34.0f);
        audimat.drawString("Double tap to go back", audx,audy);
           
            ofSetHexColor(0xbf8fec);
            ofCircle(100, ofGetHeight()-100, 75);
//            imgC.draw(100, ofGetHeight()-150, 70, 70);
            ofCircle(300, ofGetHeight()-100, 75);
            ofCircle(500, ofGetHeight()-100, 75);
//            ofDrawBox(500, ofGetHeight()-150, 0, 50, 50, 50);
            
            
            //ofNoFill();
//            ofSetColor(255*rand(), 255*rand(), 255*rand());
//            for (int r = 500; r<550; r+=10) {
//            ofRect(r, ofGetHeight()-150, 50, 50);
//            }

            
            ofSetColor(ofColor::white);
            audimat.drawString("Images", 75, ofGetHeight()-75);
            
//            ofDrawBitmapString("Images", 75, ofGetHeight()-125);
//            ofDrawBitmapString("Sound",275, ofGetHeight()-125);
//            ofDrawBitmapString("Text", 475, ofGetHeight()-125);
                
            audimat.drawString("Sound", 275, ofGetHeight()-75);
            audimat.drawString("Text", 475, ofGetHeight()-75);
        
        }
        
        
        if(img){
            audimat.setLineHeight(34.0f);
            audimat.drawString("Double tap to go back", audx,audy);
    ofSetHexColor(0xbf8fec);
    ofCircle(100, ofGetHeight()-100, 75);
    audimat.drawString("Images", 75, ofGetHeight()-75);
        
        ofPushMatrix();
        ofTranslate(mCorner.x, mCorner.y);
        ofRotateZ(90);

//        ofDrawBitmapString("Drag stuff here", mPos.x, mPos.y,-5);
        
        if(nImages>0){
            //ofRectMode(OF_RECTMODE_CENTER);
            ofSetHexColor(0xffffff);
            //images[currentImage].draw(0,0, images[currentImage].width, images[currentImage].height);
            images[currentImage].draw(0,0, images[currentImage].width,images[currentImage].height);
        }
        
        ofPopMatrix();
        
        }
        
        if(sound){
            audimat.setLineHeight(34.0f);
            audimat.drawString("Double tap to go back", audx,audy);
           ofSetHexColor(0xbf8fec);
            ofCircle(300, ofGetHeight()-150, 75);
            audimat.drawString("Sound", 275, ofGetHeight()-75);
            
            synth.play();
            
        }
        else{synth.stop();}
        
        
        
        if(text){
            audimat.setLineHeight(34.0f);
            audimat.drawString("Double tap to go back", audx,audy);
            ofSetHexColor(0xbf8fec);
            ofCircle(500, ofGetHeight()-150, 75);
            audimat.drawString("Text", 475, ofGetHeight()-75);
            
//
//        if(!keyboard->isKeyboardShowing()){
//        keyboard->openKeyboard();
//        keyboard->setVisible(true);
//            
//        ofSetColor(20, 160, 240, 255);
//        ofDrawBitmapString("text entered = "+  keyboard->getText() , 2, 70);
//            
//        } else{
//        keyboard->setVisible(false);
//        }
//            
//            
//            
        }
        
        
        if(trigger){
            
            
        }
        
 
        
        
//        cout<<"Or"<<ofGetOrientation()<<endl;
        
//        cout<<qcar->getOrientation();
        
        glEnable(GL_DEPTH_TEST);
        ofEnableNormalizedTexCoords();
        
        if(testMode == true){
        qcar->begin();
        teapotImage.getTextureReference().bind();
        ofScale(3, 3, 3);
        ofDrawTeapot();
        teapotImage.getTextureReference().unbind();
        qcar->end();
    }
    
        //cout<<"no of markers -"<<qcar->numOfMarkersFound()<<endl;
        //cout<<"Angle -"<<qcar->getMarkerAngleToCamera()<<endl;
        ofDisableNormalizedTexCoords();
        glDisable(GL_DEPTH_TEST);
    }
}

//--------------------------------------------------------------
void testApp::exit(){
    qcar->exit();
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    //
   
    if(mainMenu){
        
//        sound=true;
//        mainMenu = false;
//
        if(touch.x >=50 && touch.x<=150 && touch.y>=ofGetHeight()-175 && touch.y<=ofGetHeight()-125){
            
            tag = true;
            mainMenu = false;
        }
        
        
        if(touch.x >=250 && touch.x<=350 && touch.y>=ofGetHeight()-175 && touch.y<=ofGetHeight()-125){
            
            trigger = true;
            mainMenu = false;
        }
        
        
        
        }
    
        if(tag){
    if(touch.x >=50 && touch.x<=150 && touch.y>=ofGetHeight()-125 && touch.y<=ofGetHeight()-75){
        
        img = true;
        tag = false;
        }
            
            
    if(touch.x >=250 && touch.x<=350 && touch.y>=ofGetHeight()-125 && touch.y<=ofGetHeight()-75){
                
                sound = true;
                tag = false;
            }
            
            if(touch.x >=450 && touch.x<=550 && touch.y>=ofGetHeight()-125 && touch.y<=ofGetHeight()-75){
                
                text = true;
                tag = false;
            }
    }
        
       
        
        
    
        
        if(trigger){
            
            if(touch.x >=50 && touch.x<=150 && touch.y>=ofGetHeight()-175 && touch.y<=ofGetHeight()-125){
                
                speaker = true;
                mainMenu = false;
            }
            
            
            if(touch.x >=250 && touch.x<=350 && touch.y>=ofGetHeight()-175 && touch.y<=ofGetHeight()-125){
                
                led = true;
                mainMenu = false;
            }
            
            if(touch.x >=450 && touch.x<=550 && touch.y>=ofGetHeight()-175 && touch.y<=ofGetHeight()-125){
                
                motor = true;
                mainMenu = false;
            }
            
        }
        
        
    
//    if (img) {
//        
//    if(touch.x >=0 && touch.x<=ofGetWidth() && touch.y>=100 && touch.y<=ofGetHeight()-300){
//        ofxOscMessage m;
//        m.setAddress( "/image/selected" );
//        m.addStringArg(ofToString(currentImage));
//        sender.sendMessage( m );
//        cout<<"sent"<<endl;
//        audimat.drawString("Image tagged",100,100);
//    }
//    }
    
    
    
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    //
    
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    //
    if(img){
    if(nImages>0){
        currentImage++;
        currentImage%=nImages;
    }
    }
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

    cout<<"Double tap"<<endl;
    mainMenu = true;
    img = false;
    text = false;
    sound = false;
    tag = false;
    trigger= false;
    tuck = false;
    led = false;
    speaker = false;
    motor= false;
}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

    cout<<"new Or"<<newOrientation<<endl;
    
}

