//
//  GameOverScene.m
//  MonkeyJump
//
//  Created by Kauserali on 27/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOverScene.h"
#import "GameOverLayer.h"

@implementation GameOverScene

- (id) initWithScore:(int64_t)score andGameTrackingObject:(GameTrackingObject *)gameTrackingObject
{	
    if (self = [super init])
	{
        GameOverLayer *gameOverLayer	= [[GameOverLayer alloc] initWithScore:score andGameTrackingObject:gameTrackingObject];
        [self addChild:gameOverLayer];
    }
	
    return self;
}

@end
