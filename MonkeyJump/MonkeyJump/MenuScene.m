//
//  MenuScene.m
//  MonkeyJump
//
//  Created by Kauserali on 27/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "MenuLayer.h"
#import "SimpleAudioEngine.h"

@implementation MenuScene

- (id) init {
    self = [super init];
    if (self) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"jump.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hurt.mp3"];
        
        MenuLayer *menuLayer = [MenuLayer node];
        [self addChild:menuLayer];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background_track.aiff"];
    }
    return self;
}
@end
