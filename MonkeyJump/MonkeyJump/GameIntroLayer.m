//
//  GameIntroLayer.m
//  MonkeyJump
//
//  Created by Kauserali on 02/08/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameIntroLayer.h"
#import "MenuScene.h"

@implementation GameIntroLayer

- (void) onEnter {
    [super onEnter];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;

    CCSprite *background = [CCSprite spriteWithFile:@"bg_intro.png"];
    background.position = ccp(winSize.width * 0.5, winSize.height * 0.5);
    [self addChild:background];
    
    [self scheduleOnce:@selector(makeTransition:) delay:1];
}

- (void) makeTransition:(ccTime)dt {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[MenuScene alloc] init] withColor:ccWHITE]];
}
@end
