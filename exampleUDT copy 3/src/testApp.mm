#include "testApp.h"

ofxQCAR * qcar = NULL;
ofxQCAR * qcar2 = NULL;
ofxQCAR_Marker qcar_marker;

//--------------------------------------------------------------
void testApp::setup(){	
	ofBackground(0);
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
    //ofSetOrientation(OF_ORIENTATION_90_LEFT);
    ofxAccelerometer.setup();
    ofxAccelerometer.setForceSmoothing(2);
    
    back=false;
    backTouched = false;
    startMenu = true;
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
    selected=false;
    gameController=false;
    audx=75;
    audy=100;
    lastTime =0;
    activeObjects = false;
    numActiveObjects =0;
    
    
    sender.setup(HOST, PORT);
    sender2.setup(HOST2, PORT2);
    
    receiver.setup( PORT2 );
    
    
    marioSprite.loadImage("images/mariosprites.png");
    gameboy.loadImage("images/mario/controls.png");
    
    nImages = DIR.listDir("images/of_logos");
    images = new ofImage[nImages];
    nSounds = DIR2.listDir("sounds/sou");
    cout<<"nSounds - "<<nSounds<<endl;
    sounds = new ofSoundPlayer[nSounds];

    for (int k=0; k<nSounds; k++) {
        sounds[k].loadSound(DIR.getPath(k));
        sounds[k].setVolume(0.75f);
        sounds[k].setLoop(true);
    }
    
    for (int i=0; i<nImages; i++) {
        images[i].loadImage(DIR.getPath(i));
    }
    currentImage=0;
    currentSound=0;
    
    imgC.loadImage("images/of_logos/DSC09302.jpg");
    
    
    
    //Sound
    synth.loadSound("sounds/1085.caf");
    synth.setVolume(0.75f);
    //synth.setMultiPlay(true);
    synth.setLoop(true);
    
    
    //Font
    audimat.loadFont("audimat.otf", 20);
    audimat.setLineHeight(34.0f);
    audimat.setLetterSpacing(1.037);
    
    
    //For using keyboard when user wants to attach Text
    keyboard = new ofxiOSKeyboard(0,52,320,32);
    //keyboard = new ofxiOSKeyboard(0,52,320,150);
    keyboard->setVisible(true);
    keyboard->setBgColor(255, 255, 255, 255);
	keyboard->setFontColor(0,0,0, 255);
	keyboard->setFontSize(26);
    
    
    teapotImage.loadImage("qcar_assets/TextureTeapotBrass.png");
    teapotImage.mirror(true, false);  //-- flip texture vertically since the texture coords are set that way on the teapot.
    
    qcar = ofxQCAR::getInstance();
    qcar->addTarget("Collect.xml", "Collect/Collect.xml");
    //qcar->addTarget("MyImages.xml", "qcar_assets/MyImages.xml");
//    qcar->addTarget("Qualcomm.xml", "qcar_assets/Qualcomm.xml");
//    qcar->addTarget("Gameboy.xml", "Gameboy/Gameboy.xml");
//    qcar->addTarget("Speaker.xml", "Speaker/Speaker.xml");
    //qcar->addTarget("CokeLabel.xml", "CokeLabel/CokeLabel.xml");
//    qcar->addTarget("ArduinoUnoR3.xml", "ArduinoUnoR3/ArduinoUnoR3.xml");
    qcar->autoFocusOn();
    qcar->setCameraPixelsFlag(false);
    qcar->setup();
    qcar->setMaxNumOfMarkers(2);
    testMode = false;
    
    
    
//    sender.setup("10.0.0.6", 8000);
    

    //Core Motion stuff here
    
    bool enableAttitude = true;
    bool enableAccelerometer = true;
    bool enableGyro = true;
    bool enableMagnetometer = true;
    coreMotion.setup(enableAttitude,enableAccelerometer,enableGyro,enableMagnetometer);
    quat = coreMotion.getQuaternion();
    
    
    mainMenuElements.assign(3, UI());
    childrenElements.assign(3, UI());
    
//    for (int e=0; e<elements.size(); e++) {
//        elements[e].createUIObject(<#int id#>, <#int num#>);
//    }
    
    m=ofGetElapsedTimef();
    subtract=0;
    
    balls.assign(10, Ball());
    for(int i=0; i<balls.size(); i++){
		balls[i].init(i);
	}
    
    mr.init();
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
    
    //cout<<"Accelerometer - "<<ofxAccelerometer.getOrientation().x<<endl;
    
    //ofLog(OF_LOG_VERBOSE,"x= %f, y= %f, z= %f",ofxAccelerometer.getOrientation().x,ofxAccelerometer.getOrientation().y,ofxAccelerometer.getForce().z);
    
    if( ofGetFrameNum() % 120 == 0 ){
		ofxOscMessage m;
		m.setAddress( "/misc/heartbeat" );
		m.addIntArg( ofGetFrameNum() );
		sender.sendMessage( m );
	}
    
    if( ofGetFrameNum() % 120 == 0 ){
		ofxOscMessage m2;
		m2.setAddress( "/misc/heartbeat" );
		m2.addIntArg( ofGetFrameNum() );
		sender2.sendMessage( m2 );
	}
    
    while( receiver.hasWaitingMessages() ){
		// get the next message
		ofxOscMessage m;
		receiver.getNextMessage( &m );
        
        if( m.getAddress() == "/tag/image" ){
			// both the arguments are int32's
			currentImage = m.getArgAsInt32( 0 );
			cout<<"testCurrentImage - "<<currentImage<<endl;
		}
        
        if( m.getAddress() == "/tag/sound" ){
			// both the arguments are int32's
			currentSound = m.getArgAsInt32( 0 );
			cout<<"testCurrentImage - "<<currentSound<<endl;
		}
        
        if( m.getAddress() == "/tag/text" ){
			// both the arguments are int32's
			receivedText = m.getArgAsString(0);
			cout<<"receivedText - "<<receivedText<<endl;
		}
        
        if( m.getAddress() == "/trigger/led" ){
			// both the arguments are int32's
			xinc = m.getArgAsInt32(0);
            yinc = m.getArgAsInt32(1);
            //xinc = tempIncx;
            //yinc = tempIncY;
			cout<<"mario received - "<<xinc<<endl;
		}
        
    }
    
    coreMotion.update();
    
    for(int i=0; i < balls.size(); i++){
		balls[i].update();
	}
    ofLog(OF_LOG_VERBOSE, "x = %f, y = %f", ofxAccelerometer.getForce().x, ofxAccelerometer.getForce().y);
    
}

//--------------------------------------------------------------
void testApp::draw(){
    
    //cout<<"width - "<<ofGetWidth()<<"  height - "<<ofGetHeight()<<endl;
    cout<<"No markers - "<<qcar->numOfMarkersFound()<<endl;
    
    qcar->draw();
    if(qcar->isTrackingCustomTarget()){
        cout<<"Tracking custom marker"<<endl;
    qcar_marker = qcar->getMarker(0);
    }

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
        //ofRect(markerRect);
        ofPopStyle();
    }
    
    if(qcar->hasFoundMarker()) {

        mark = qcar->getMarkerName();
        
        if (mark == "ArduinoUnoR3") {
            
            cout<<"Arduino found"<<endl;
            //trigger=true;
            
            ofSetColor(ofColor::white);
            drawTextDefault(1);
            
            //back = true;
        }
        
        
        if (mark == "chips") {
            
            cout<<"chips found"<<endl;
            //trigger=true;
            
            ofSetColor(ofColor::white);
            drawTextDefault(1);
            chips = true;
            mainMenu=false;
            
            //back = true;
        }
        
        if (mark == "stones") {
            
            cout<<"stones found"<<endl;
            //trigger=true;
            
            ofSetColor(ofColor::white);
            drawTextDefault(0);
            //chips = true;
            
            //back = true;
        }

        
        if (mark == "tarmac") {
            
            cout<<"tarmac found"<<endl;
            //trigger=true;
            
            ofSetColor(ofColor::white);
            drawTextDefault(0);
           //// chips = true;
            
            //back = true;
        }
        
        ofSetColor(ofColor::yellow);
        qcar->drawMarkerBounds();
        ofSetColor(ofColor::cyan);
        qcar->drawMarkerCenter();
        qcar->drawMarkerCorners();
        
        ofSetColor(ofColor::white);
        ofSetLineWidth(1);
        
        mPos = qcar->getMarkerCenter();
        mCorner = qcar->getMarkerCorner(OFX_QCAR_MARKER_CORNER_TOP_LEFT);
        imageBox = qcar->getMarkerRect();
        
        ofPushMatrix();
        ofTranslate(mPos.x, mPos.y);
        float angle;
        ofVec3f axis;
        quat.getRotate(angle, axis);
        ofRotate(angle, axis.x, -axis.y, axis.z);
        ofNoFill();
        //ofDrawBox(0, 0, 0, 200);
        //ofDrawAxis(100);
        ofPopMatrix();
        
        
        //audimat.setLineHeight(34.0f);
        //audimat.drawString("Marker:"+qcar->getMarkerName(), mPos.x, mPos.y);
        
        //marioSprite.drawSubsection(mPos.x, mPos.y, 100, 100, 200, 0);
        
        //Calling drawObjects here
        drawObjects();
        
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
        

        ofDisableNormalizedTexCoords();
        glDisable(GL_DEPTH_TEST);
        
        }
    
    
    else{
        
        if(mainMenu){
        if(ofGetElapsedTimef()-m<1){
        ofSetColor(ofColor::green);
            //ofSetPolyMode(OF_POLY_WINDING_NONZERO);
            ofBeginShape();
            ofVertex(0, ofGetHeight()/2-20);
            ofVertex(ofGetWidth()/2, ofGetHeight()/2-20);
            ofVertex(ofGetWidth()/2 - 20, ofGetHeight()/2);
            ofVertex(ofGetWidth()/2, ofGetHeight()/2+20);
            ofVertex(0, ofGetHeight()/2+20);
            ofEndShape();
        
        ofSetColor(ofColor::white);
        audimat.setLineHeight(34.0f);
        audimat.drawString("Scan marker to start", 20,ofGetHeight()/2+5);
        }
        
        else{
        
            if(subtract<ofGetWidth()/2){
            ofSetColor(ofColor::green);
            //ofSetPolyMode(OF_POLY_WINDING_NONZERO);
            ofBeginShape();
            ofVertex(0, ofGetHeight()/2-20);
            ofVertex(ofGetWidth()/2-subtract, ofGetHeight()/2-20);
            ofVertex(ofGetWidth()/2 - 20 - subtract, ofGetHeight()/2);
            ofVertex(ofGetWidth()/2 - subtract, ofGetHeight()/2+20);
            ofVertex(0, ofGetHeight()/2+20);
            ofEndShape();
            
            ofSetColor(ofColor::white);
            audimat.setLineHeight(34.0f);
            audimat.drawString("Scan marker to start", 40-subtract,ofGetHeight()/2+5);
            subtract+=8;
        }
        }
        
            
        
    }
        
    }
        
}




    void testApp::drawObjects(){

        
        if (mainMenu) {
         
            //mainMenuElements[1].displayTriangle(ofColor::white, "Tag");
            mainMenuElements[1].displayFlag(ofColor::orange);
            ofSetColor(ofColor::white);
            audimat.setLineHeight(34.0f);
            audimat.drawString("Tag",ofGetWidth()/7+20 ,ofGetHeight()*3/4+20);
            
            

            mainMenuElements[1].displayTrigger(ofColor::white);
            ofSetColor(ofColor::orange);
            audimat.setLineHeight(34.0f);
            audimat.drawString("Trigger",ofGetWidth()*5/7 ,ofGetHeight()*3/4+20);
            
        }
        
        
    
        if(tag){
            
            
            //                mainMenuElements[1].displayChildren();
            
            mainMenuElements[1].displayFlag(ofColor::orange);
            ofSetColor(ofColor::white);
            ofFill();
            audimat.setLineHeight(34.0f);
            audimat.drawString("Tag",ofGetWidth()/7 + 30 ,ofGetHeight()*3/4+20);
            
            ofSetHexColor(0xFF7F50);
            ofFill();
            mainMenuElements[1].displayChildrenFlags();
            ofSetColor(ofColor::white);
            audimat.drawString("Images",ofGetWidth()/3+35, ofGetHeight()*3/4+20);
            
            
            ofSetHexColor(0xFF8C69);
            ofFill();
            ofPushMatrix();
            ofTranslate(ofGetWidth()/3-70, 0);
            mainMenuElements[2].displayChildrenFlags();
            ofSetColor(ofColor::white);
            audimat.drawString("Sound",ofGetWidth()/3+25, ofGetHeight()*3/4+20);
            ofPopMatrix();
            
            ofSetHexColor(0xFBCEB1);
            ofFill();
            ofPushMatrix();
            ofTranslate(ofGetWidth()/3+117, 0);
            mainMenuElements[3].displayChildrenFlags();
            ofSetColor(ofColor::white);
            audimat.drawString("Text",ofGetWidth()/3+30, ofGetHeight()*3/4+20);
            ofPopMatrix();
        }
        
        
        if (trigger) {
            
            mainMenuElements[1].displayTrigger(ofColor::white);
            ofSetColor(ofColor::orange);
            ofFill();
            audimat.setLineHeight(34.0f);
            audimat.drawString("Trigger",ofGetWidth()*5/7 ,ofGetHeight()*3/4+20);

            
            //cout<<"triggered "<<endl;
            ofSetHexColor(0xFF7F50);
            ofFill();
            mainMenuElements[1].displayChildrenTrigger();
            ofSetColor(ofColor::white);
            audimat.drawString("Speaker",ofGetWidth()*2/3-110, ofGetHeight()*3/4+20);
            
            ofSetHexColor(0xFF8C69);
            ofFill();
            ofPushMatrix();
            ofTranslate(ofGetWidth()/3-443, 0);
            mainMenuElements[2].displayChildrenTrigger();
            ofSetColor(ofColor::white);
            audimat.drawString("Servo",ofGetWidth()/3+120, ofGetHeight()*3/4+20);
            ofPopMatrix();
            
            ofSetHexColor(0xFBCEB1);
            ofFill();
            ofPushMatrix();
            ofTranslate(ofGetWidth()/3-623, 0);
            mainMenuElements[3].displayChildrenTrigger();
            ofSetColor(ofColor::white);
            audimat.drawString("LED",ofGetWidth()/3+200, ofGetHeight()*3/4+20);
            ofPopMatrix();
        }
        
        
        
        if (img) {
//            mainMenuElements[2].displayFlag(ofColor::violet);
//            ofSetColor(ofColor::white);
//            audimat.setLineHeight(34.0f);
//            audimat.drawString("Images",ofGetWidth()/7 ,ofGetHeight()*3/4+20);
            
            
            ofPushMatrix();
            ofTranslate(ofGetWidth()/3,ofGetHeight()*3/4 + 50);
            ofScale(0.5, 0.5);
            //ofRotateZ(90);
            
            
            if(nImages>0){
                ofSetHexColor(0xffffff);
                images[currentImage].draw(0,0, images[currentImage].width,images[currentImage].height);
                
                
                ofSetLineWidth(5);
                ofLine(images[currentImage].width + 20, images[currentImage].height/2, images[currentImage].width+70, images[currentImage].height/2);
                ofLine(- 20, images[currentImage].height/2, -70, images[currentImage].height/2);
                
                ofLine(images[currentImage].width+70, images[currentImage].height/2, images[currentImage].width+50, images[currentImage].height/2-20);
                ofLine(images[currentImage].width+70, images[currentImage].height/2, images[currentImage].width+50, images[currentImage].height/2+20);
                
                ofLine(-70, images[currentImage].height/2, -50, images[currentImage].height/2-20);
                ofLine(-70, images[currentImage].height/2, -50, images[currentImage].height/2+20);
//                images[currentImage].draw(ofGetWidth()*2/3,ofGetHeight()*3/4, images[currentImage].width,images[currentImage].height);
            }
            
            ofPopMatrix();
           
            ofPushMatrix();
            ofScale(0.5, 0.5);
            ofTranslate(posx-images[currentImage].width/2, posy-images[currentImage].height/2);
            images[currentImage].draw(posx,posy, images[currentImage].width,images[currentImage].height);
            ofPopMatrix();
            
            ofPushMatrix();
            ofTranslate(qcar->getMarkerCorner(OFX_QCAR_MARKER_CORNER_TOP_LEFT));
             ofPopMatrix();
            
            
//            ofRect(ofGetWidth()/3+ofGetWidth()/4,ofGetHeight()*3/4 + 150, 50, 50);
            audimat.setLineHeight(34.0f);
            audimat.drawString("Select",ofGetWidth()/3+ofGetWidth()/4,ofGetHeight()*3/4 + 135);
            
            
            if(selected){
            ofxOscMessage m2;
            m2.setAddress( "/tag/image" );
            m2.addIntArg(currentImage);
            sender2.sendMessage( m2 );
            }
        }
        
        
        
        
        
        if (sound) {
//            mainMenuElements[2].displayFlag(ofColor::violet);
//            ofSetColor(ofColor::white);
//            audimat.setLineHeight(34.0f);
//            audimat.drawString("Sound",ofGetWidth()/7 ,ofGetHeight()*3/4+20);

            if (nSounds>0) {
                sounds[currentSound].play();
                cout<<"sound playing.."<<endl;
                
                
                ofPushMatrix();
                ofTranslate(ofGetWidth()/3,ofGetHeight()*3/4 + 50);
                ofScale(0.5, 0.5);
                ofSetLineWidth(5);
                ofLine(imgC.width + 20, imgC.height/2, imgC.width+70, imgC.height/2);
                ofLine(- 20, imgC.height/2, -70, imgC.height/2);
                
                ofLine(imgC.width+70, imgC.height/2, imgC.width+50, imgC.height/2-20);
                ofLine(imgC.width+70, imgC.height/2, imgC.width+50, imgC.height/2+20);
                
                ofLine(-70, imgC.height/2, -50, imgC.height/2-20);
                ofLine(-70, imgC.height/2, -50, imgC.height/2+20);
                
                ofPopMatrix();
                
                audimat.setLineHeight(34.0f);
                audimat.drawString("Select",ofGetWidth()/3+ofGetWidth()/4,ofGetHeight()*3/4 + 135);
            }
            
            if(selected){
                ofxOscMessage m2;
                m2.setAddress( "/tag/sound" );
                m2.addIntArg(currentSound);
                sender2.sendMessage( m2 );
            }
            
            //synth.play();
            
        }
        else{
            sounds[currentSound].stop();
            //synth.stop();
        }
        
        
        if (text) {
            audimat.setLineHeight(34.0f);
            tx = keyboard->getText();
            audimat.drawString(keyboard->getText()+" Received text:"+receivedText,mPos.x,mPos.y);
            
            ofxOscMessage m2;
            m2.setAddress( "/tag/text" );
            m2.addStringArg(keyboard->getText());
            sender2.sendMessage( m2 );
        }
        
        
        if (back) {
            ofSetLineWidth(5);
            ofSetColor(ofColor::white);
            ofLine(10, ofGetHeight()*3/4+65, 50, ofGetHeight()*3/4+65);
            ofLine(10, ofGetHeight()*3/4+65, 20, ofGetHeight()*3/4 + 85);
            ofLine(10, ofGetHeight()*3/4+65, 20, ofGetHeight()*3/4 + 45);
            audimat.setLineHeight(17.0f);
            audimat.drawString("Back",50,ofGetHeight()*3/4 +75);
            
            
        }
        
        
        if (speaker) {
            cout<<"inside speaker"<<endl;
            ofxOscMessage m;
            m.setAddress( "/trigger/speaker" );
            m.addStringArg( "speaker" );
            sender.sendMessage( m );
        }
        
        if (motor) {
            cout<<"inside motor"<<endl;
            ofxOscMessage m;
            m.setAddress( "/trigger/motor" );
            m.addStringArg( "motor" );
            sender.sendMessage( m );
        }
        
        
        if (led) {
            cout<<"inside led"<<endl;
            ofxOscMessage m;
            m.setAddress( "/trigger/led" );
            m.addStringArg( "led" );
            sender.sendMessage( m );
        }
        
        
        if (gameController) {
            
//            ofSetColor(ofColor::gray);
//            ofFill();
//            ofRect(ofGetWidth()/3, ofGetHeight()/2, 30, 60);
//            ofRect(20, ofGetHeight()/2+40, 60, 30);
            
        }
        
        
//        if (mariox>400) {
//            mariox=0;
//        }
//        
//        //marioSprite.drawSubsection(mPos.x, mPos.y, 100, 100, mariox, marioy);
//        mariox+=100;
        
        
        
        
        if (chips) {
            mainMenu = false;
            img = false;
            text = false;
            sound = false;
            tag = false;
            trigger= false;
            tuck = false;
            led = false;
            speaker = false;
            motor= false;
            back=false;
            backTouched=false;
            
            ofPushMatrix();
            ofScale(0.3, 0.3);
            //gameboy.draw(ofGetWidth()/2, 4*ofGetHeight()/2);
            ofPopMatrix();
            
            
            if (mariox>400) {
                mariox=0;
            }
            
            if (xinc<0 || xinc>ofGetWidth()) {
                xinc=100;
            }
            
            if (yinc<0 || yinc>ofGetHeight()) {
                yinc=100;
            }
            
            if (up) {
                marioSprite.drawSubsection(xinc, yinc, 100, 100, 200, 0);
            }
            else if(down){
                marioSprite.drawSubsection(xinc, yinc, 100, 100, 200, 200);
                
            }

            
            else if(left){
                marioSprite.drawSubsection(xinc, yinc, 100, 100, 0, 200);
                
            }
            
            else if(right){
                marioSprite.drawSubsection(xinc, yinc, 100, 100, 200, 500);
                
            }
            else
            marioSprite.drawSubsection(xinc, yinc, 100, 100, mariox, marioy);
            //mariox+=100;
            cout<<"xinc - "<<xinc<<"  yinc - "<<yinc<<endl;
//            xinc+=ofRandom(5);
//            yinc+=ofRandom(5);
            
            ofxOscMessage m2;
            m2.setAddress( "/trigger/led" );
            m2.addIntArg(xinc);
            m2.addIntArg(yinc);
            sender2.sendMessage( m2 );
            
            
        }
        
        
        //gameboy.draw(mPos.x, mPos.y);
        
//Gamebiy controls
//        ofSetColor(ofColor::gray);
//        ofFill();
//        ofRect(ofGetWidth()/3, ofGetHeight()/2, 30, 60);
//        ofRect(20, ofGetHeight()/2+40, 60, 30);
        //marioSprite.drawSubsection(<#float x#>, <#float y#>, <#float w#>, <#float h#>, <#float sx#>, <#float sy#>)
        
//        ofPushStyle();
//        ofEnableBlendMode(OF_BLENDMODE_MULTIPLY);
//        for(int i = 0; i< balls.size(); i++){
//            balls[i].draw();
//        }
//        ofPopStyle();
        
        
        
        
      /*
        else if (mainMenu && activeObjects == true) {
            ofPushMatrix();
//            ofTranslate(float x, <#float y#>);
            mainMenuElements[1].displayFlag(ofColor::orange);
            ofSetColor(ofColor::white);
            audimat.setLineHeight(34.0f);
            audimat.drawString("Tag",ofGetWidth()/7 -su,ofGetHeight()*3/4+20);
//            mainMenuElements[1].displayText("Tag");
            ofPopMatrix();
            
       
            ofPushMatrix();
//            ofTranslate(<#float x#>, <#float y#>);
            mainMenuElements[2].displayFlag(ofColor::blue);
            ofSetColor(ofColor::white);
            audimat.setLineHeight(34.0f);
            audimat.drawString("Trigger",ofGetWidth()/7 -su,ofGetHeight()*3/4+20);
            ofPopMatrix();
            
            
            su+=3;
        }
        
        */
        
        
        
        
        
        
        
        
        
        
 
    

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
        
        if (touch.x>=0 && touch.x<=ofGetWidth()/3 && touch.y>=ofGetHeight()*3/4-20 && touch.y <=ofGetHeight()*3/4+40) {
            tag=true;
            trigger=false;
            mainMenu = false;
        }
        
//        if(touch.x >=50 && touch.x<=150 && touch.y>=ofGetHeight()-175 && touch.y<=ofGetHeight()-125){
//            
//            tag = true;
//           // mainMenu = false;
//        }
        
        
        if(touch.x >=ofGetWidth()*2/3 && touch.x<ofGetWidth() && touch.y>=ofGetHeight()*3/4-20 && touch.y <=ofGetHeight()*3/4+40){
            
            trigger = true;
            cout<<"trigger"<<endl;
            tag=false;
            mainMenu = false;
        }
        
        
        
        }
    
        if(tag){
            back=true;
    if(touch.x >ofGetWidth()/3 && touch.x<=ofGetWidth()/3+ofGetWidth()/4 && touch.y>=ofGetHeight()*3/4-20 && touch.y <=ofGetHeight()*3/4+40){
        
        img = true;
        sound=false;
        text=false;
        //tag = false;
        }
            
            
    if(touch.x >ofGetWidth()/3 + ofGetWidth()/4 && touch.x<=ofGetWidth()/3+2*ofGetWidth()/4 && touch.y>=ofGetHeight()*3/4-20 && touch.y <=ofGetHeight()*3/4+40){
                
                sound = true;
                img=false;
                text=false;
                //tag = false;
            }
            
            if(touch.x >ofGetWidth()/3 + 2*ofGetWidth()/4 && touch.x<=ofGetWidth()/3+3*ofGetWidth()/4 && touch.y>=ofGetHeight()*3/4-20 && touch.y <=ofGetHeight()*3/4+40){
                
                text = true;
                img=false;
                sound=false;
                //tag = false;
            }
    }
        
       
    
    if (touch.x>=0 && touch.x<=100 && touch.y>=ofGetHeight()*3/4+40 && touch.y <=ofGetHeight()*3/4+85) {
        backTouched = true;
    }
    
    
    
    if (trigger) {
        back = true;
        
        
        if(touch.x >ofGetWidth()*2/3-ofGetWidth()/4 && touch.x<=ofGetWidth()*2/3 && touch.y>=ofGetHeight()*3/4-20 && touch.y <=ofGetHeight()*3/4+40){
            
            
            if(speaker==true)
                speaker=false;
            
                
                else
            speaker = true;
            cout<<"speaker"<<endl;
            //tag = false;
        }
        
        
        
        if(touch.x >ofGetWidth()*2/3-2*ofGetWidth()/4 && touch.x<=ofGetWidth()*2/3-ofGetWidth()/4 && touch.y>=ofGetHeight()*3/4-20 && touch.y <=ofGetHeight()*3/4+40){
            
            if(motor==true)
                motor=false;
                
                else
            motor = true;
            cout<<"servo"<<endl;
            //tag = false;
        }
        
        if(touch.x >0 && touch.x<=ofGetWidth()*2/3-2*ofGetWidth()/4 && touch.y>=ofGetHeight()*3/4-20 && touch.y <=ofGetHeight()*3/4+40){
            
            if(led==true)
                led=false;
            else
            led = true;
            cout<<"led"<<endl;
            //tag = false;
        }
        
    }
    
    if (backTouched) {
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
        back=false;
        backTouched=false;
        
    }
    
    
    if (chips) {
        
        cout<<"chips Here"<<endl;
        if (touch.x>ofGetWidth()/2 && touch.x<ofGetWidth() && touch.y>ofGetHeight()/3 && touch.y<ofGetHeight()*2/3) {
            xinc+=10;
            right=true;
            up=false;
            down = false;
            left=false;
        }
        
        if (touch.x>0 && touch.x<ofGetWidth()/2 && touch.y>ofGetHeight()/3 && touch.y<ofGetHeight()*2/3) {
            xinc-=10;
            
            left  = true;
            right=false;
            up=false;
            down = false;
        }
        
        if (touch.x>ofGetWidth()/3 && touch.x<ofGetWidth()*2/3 && touch.y>0 && touch.y<ofGetHeight()/2) {
            yinc-=10;
            right=false;
            up=true;
            down = false;
            left=false;
        }

        
        if (touch.x>ofGetWidth()/3 && touch.x<ofGetWidth()*2/3 && touch.y>ofGetHeight()/2 && touch.y<ofGetHeight()) {
            yinc+=10;
            right=false;
            up=false;
            down = true;
            left=false;
        }
        
    }
    
//    if (chips) {
//        audimat.setLineHeight(17.0f);
//        audimat.drawString("Here1",ofGetWidth()/3 ,ofGetHeight()*3/4);
//    }
    

    
    
    /*
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
    
    
    */
        
    
    
//        if (img) {
//    
//        if(touch.x >=0 && touch.x<=ofGetWidth() && touch.y>=100 && touch.y<=ofGetHeight()-100){
//        audimat.drawString("Object tagged",100,100);
//        
//        }}
    
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
    
    
    
    if (img) {
        
        
    if (touch.x>=ofGetWidth()/3+ofGetWidth()/4 && touch.x<2*ofGetWidth()/3 && touch.y>=ofGetHeight()*3/4 + 135 && touch.y<ofGetHeight()*3/4 + 165) {
        selected=true;
        cout<<"selected"<<endl;
    }
        
        
        
        if (touch.x>ofGetWidth()/2 && touch.x<ofGetWidth() && touch.y>0 && touch.y<ofGetHeight()*2/3) {
                        currentImage++;
            if (currentImage>nImages-1) {
                currentImage=0;
            }
                }
            
            if (touch.x>0 && touch.x<ofGetWidth()/2 && touch.y>0 && touch.y<ofGetHeight()*2/3) {
                currentImage--;
                if (currentImage<0) {
                    currentImage=nImages-1;
                }
        }


        
    }
    
    
    if(text) {
        
        if (!keyboard->isKeyboardShowing()) {
            keyboard->openKeyboard();
            keyboard->setVisible(true);
        }
        else{
            keyboard->setVisible(false);
        }
        
    }
    
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    //
    if(img){
        if(nImages>0){
            //currentImage++;
            //currentImage%=nImages;
            
            
            posx=touch.x;
            posy=touch.y;
        }
    }
    
    
    if (sound) {
        if (nSounds>0) {
            currentSound++;
            currentSound%=nSounds;
        }
    }
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    //

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

//    cout<<"Double tap"<<endl;
/*
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
    back=false;
    chips=false;
    
  */
    /*
    ofxOscMessage m;
	m.setAddress( "/mouse/button" );
	m.addStringArg( "doubleTap" );
	sender.sendMessage( m );
     */
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








//Custom methods


void testApp::setTextSize(float sz){
    
}


float testApp::getTextSize(){
    
    return audimat.getLineHeight();
}

void testApp::drawText(){
    
}


void testApp::drawText(string tx, int wd, int ht){
    
    
}

void testApp::drawTextDefault(int n){
    
    audimat.setLineHeight(34.0f);
    
    if(n==0)
    audimat.drawString("Passive object found",ofGetWidth()/3 ,ofGetHeight()/4);
    
    if(n==1)
    audimat.drawString("Active object found",ofGetWidth()/3 ,ofGetHeight()/4);
    
}


