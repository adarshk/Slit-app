//
//  UI.h
//  UserDefinedTargets
//
//  Created by Adarsh on 24/11/2013.
//
//

#ifndef UserDefinedTargets_UI_h
#define UserDefinedTargets_UI_h



#endif

class UI{
    
    
public:
    
    ofPoint pos;
    string text;
    ofColor color;
    bool dragged;
    
    
    
    void createUIObject(int id,int num){
        
        if (num == 1) {
            
        }
        
        
    }
    
    
    void updateUIObject(){
        
        
    }
    
    void displayChildren(int numberOfChildren){
        for (int n=0; n<numberOfChildren; n++) {
         //   ofLine(<#float x1#>, <#float y1#>, ofGetWidth()/2, ofGetHeight()/2);
        }
        
    }
    
    void displayMainUIObject(ofPoint where){
        
        ofSetColor(ofColor::orange);
        ofCircle(ofGetWidth()/2, ofGetHeight()*3/4, 75);
        
    }
    
    
    
};