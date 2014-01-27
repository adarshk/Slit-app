//
//  Mario.h
//  UserDefinedTargets
//
//  Created by Adarsh on 26/11/2013.
//
//

#ifndef UserDefinedTargets_Mario_h
#define UserDefinedTargets_Mario_h



#endif


#pragma once

#define BOUNCE_FACTOR			0.7
#define ACCELEROMETER_FORCE		0.2
#define RADIUS					20


class Mario{

public:
    
    
    ofImage mario;
    
    void init(){
        mario.loadImage("images/mario/mariosprites.png");
        
    }
    
    void draw(){
        
        mario.draw(100, 100);
        //mario.drawSubsection(0, 0, 100, 100, 200, 0);
        
    }



};