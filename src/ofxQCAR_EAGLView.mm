//
//  ofxQCAREAGLView.m
//
//  Created by lukasz karluk on 19/01/12.
//

#import "ofxQCAR_EAGLView.h"
#import "ofxQCAR.h"

@implementation ofxQCAR_EAGLView

- (void)dealloc {
    [super dealloc];
}

- (void)renderFrameQCAR {
    [self drawView];
}

- (void)stopAnimation {
    ofxQCAR::getInstance()->pause();
}

- (void)startAnimation {
    ofxQCAR::getInstance()->resume();
}

@end