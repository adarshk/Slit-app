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
    ofPoint target;
    ofTrueTypeFont audimat;
    int sub = 0;
    int add=0;
    
    
    void createUIObject(int id,int num){
        
        if (num == 1) {
            
        }
        
        
    }
    
    
    void updateUIObject(){
        
         if(sub<ofGetWidth()/2){
          
             sub +=3;
         }
        
    }
    
    
    
    //For displaying children
    
    void displayChildren(int numberOfChildren){
        for (int n=0; n<numberOfChildren; n++) {
         //   ofLine(<#float x1#>, <#float y1#>, ofGetWidth()/2, ofGetHeight()/2);
        }
        
    }
    
    void displayChildren(int numberOfChildren,ofColor col){
        
        int divisions = (ofGetWidth()*3/4 - ofGetWidth()/4)/numberOfChildren ;
        
//        float rng = ofMap(range, ofGetWidth()/4, ofGetWidth()*3/4, <#float outputMin#>, <#float outputMax#>)
        
        ofSetColor(col);
        
        for (int n=0; n<numberOfChildren; n++) {
               ofLine(ofGetWidth()/4 +n*divisions, ofGetHeight()/2, ofGetWidth()/2, ofGetHeight()*3/4);
            ofCircle(ofGetWidth()/4 +n*divisions, ofGetHeight()/2, 30);
        }
        
    }
    

    
    
    //For displaying main UI
    
    void displayMainUIObject(int wd,int ht,int rd){
        
        ofSetColor(ofColor::orange);
        ofCircle(ofGetWidth()/2, ofGetHeight()*3/4, 75);
        
    }
    
    
    void displayMainUIObject(ofColor col){
        
        ofSetColor(col);
        ofCircle(ofGetWidth()/2, ofGetHeight()*3/4, 75);
        
    }
    
    
    ofPoint displayMainUIObject(){
        
        //ofSetColor(ofColor::orange);
        ofCircle(ofGetWidth()/2, ofGetHeight()*3/4, 75);
        ofPoint mc(ofGetWidth()/2,ofGetHeight()*3/4);
        return mc;
    }
    
    
    ofPoint displayMainUIObjectOnLeft(ofPoint p){
        
        if (p.x>ofGetWidth()/4) {
            p.x-=7;
            cout<<"in p.x"<<endl;
        }
        else{
        displayChildren();
        }
        //ofSetColor(ofColor::orange);
        //ofCircle(ofGetWidth()/2, ofGetHeight()*3/4, 75);
        return p;
    }
    
    
    void displayTriangle(ofColor c, string text){
        
        ofDrawBitmapString(text, ofGetWidth()/2, ofGetHeight()*3/4);
        ofSetColor(c);
        
        ofTriangle(ofGetWidth()/2, ofGetHeight()*3/4 - 50, ofGetWidth()/2-(ofGetWidth()/2-ofGetWidth()/3), ofGetHeight()*3/4+50, ofGetWidth()/2 + (ofGetWidth()/2-ofGetWidth()/3), ofGetHeight()*3/4);
        
    }
    
    
    
    //Draw Flag + text + children for each object
    void displayFlag(ofColor c){
        
       
        ofSetColor(c);
        ofFill();
        ofBeginShape();
        ofVertex(0, ofGetHeight()*3/4-20);
        ofVertex(ofGetWidth()/3 - sub, ofGetHeight()*3/4-20);
        ofVertex(ofGetWidth()/3 - 20 - sub, ofGetHeight()*3/4+10);
        ofVertex(ofGetWidth()/3 - sub, ofGetHeight()*3/4+40);
        ofVertex(0, ofGetHeight()*3/4+40);
        ofEndShape();
        
 
    
    }
    
    void displayTrigger(ofColor c){
        
        
        ofSetColor(c);
        ofFill();
        ofBeginShape();
        ofVertex(ofGetWidth(), ofGetHeight()*3/4-20);
        ofVertex(ofGetWidth()*2/3, ofGetHeight()*3/4-20);
        ofVertex(ofGetWidth()*2/3 + 20, ofGetHeight()*3/4+10);
        ofVertex(ofGetWidth()*2/3, ofGetHeight()*3/4+40);
        ofVertex(ofGetWidth(), ofGetHeight()*3/4+40);
        ofEndShape();
        
        
        
    }
    
    void displayText(string text){
        
        ofSetColor(ofColor::white);
        audimat.setLineHeight(34.0f);
        audimat.drawString(text,ofGetWidth()/3 ,ofGetHeight()*3/4);
        //ofDrawBitmapString(text,ofGetWidth()/3 ,ofGetHeight()*3/4);
        
    }
    
    void displayChildren(){
        
        cout<<"in display Children"<<endl;
        
        
        ofLine(ofGetWidth()/3 - sub, ofGetHeight()*3/4-20, ofGetWidth()/2 - sub, ofGetHeight()*3/4-50);
        ofLine(ofGetWidth()/3 - 20 - sub, ofGetHeight()*3/4+10, ofGetWidth()/2 - sub, ofGetHeight()*3/4+10);
        ofLine(ofGetWidth()/3 - sub, ofGetHeight()*3/4+40, ofGetWidth()/2 - sub, ofGetHeight()*3/4+70);
        
        ofCircle(ofGetWidth()/2 - sub, ofGetHeight()*3/4-50, 25);
        ofCircle(ofGetWidth()/2 - sub, ofGetHeight()*3/4+10, 25);
        ofCircle(ofGetWidth()/2 - sub, ofGetHeight()*3/4+70, 25);
        
    }
    
    
    void displayChildrenFlags(ofColor cl){
        
        ofSetColor(cl);
        ofBeginShape();
        
        ofVertex(ofGetWidth()/3 + 5, ofGetHeight()*3/4-20);
        ofVertex(ofGetWidth()/3+ofGetWidth()/4-5, ofGetHeight()*3/4-20);
        ofVertex(ofGetWidth()/3+ofGetWidth()/4-25, ofGetHeight()*3/4 + 10);
        ofVertex(ofGetWidth()/3+ofGetWidth()/4-5, ofGetHeight()*3/4 + 40);
        ofVertex(ofGetWidth()/3+5, ofGetHeight()*3/4+40);
        ofVertex(ofGetWidth()/3 - 15, ofGetHeight()*3/4+10);
        ofEndShape();
        
    }
    
    
    void displayChildrenFlags(){
        
        
        ofBeginShape();
        
        ofVertex(ofGetWidth()/3 + 5, ofGetHeight()*3/4-20);
        ofVertex(ofGetWidth()/3+ofGetWidth()/4-5, ofGetHeight()*3/4-20);
        ofVertex(ofGetWidth()/3+ofGetWidth()/4-25, ofGetHeight()*3/4 + 10);
        ofVertex(ofGetWidth()/3+ofGetWidth()/4-5, ofGetHeight()*3/4 + 40);
        ofVertex(ofGetWidth()/3+5, ofGetHeight()*3/4+40);
        ofVertex(ofGetWidth()/3 - 15, ofGetHeight()*3/4+10);
        ofEndShape();
        
    }
    
    
    void displayChildrenTrigger(){
        
        
        ofBeginShape();
        
        ofVertex(ofGetWidth()*2/3 - 5, ofGetHeight()*3/4-20);
        ofVertex(ofGetWidth()*2/3-ofGetWidth()/4+5, ofGetHeight()*3/4-20);
        ofVertex(ofGetWidth()*2/3-ofGetWidth()/4+25, ofGetHeight()*3/4 + 10);
        ofVertex(ofGetWidth()*2/3-ofGetWidth()/4+5, ofGetHeight()*3/4 + 40);
        ofVertex(ofGetWidth()*2/3-5, ofGetHeight()*3/4+40);
        ofVertex(ofGetWidth()*2/3 + 15, ofGetHeight()*3/4+10);
        ofEndShape();
        
    }
    
    
};