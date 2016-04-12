//
//  GameScene.m
//  MonkeyJump
//
//  Created by Kauserali on 26/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"
#import "HudLayer.h"
#import "SimpleAudioEngine.h"

@implementation GameScene

- (id) init
{
    if (self = [super init])
	{
        HudLayer *hudLayer		= [HudLayer node];
        [self addChild:hudLayer z:1];
        
        GameLayer *gameLayer	= [[GameLayer alloc] initWithHud:hudLayer];
        [self addChild:gameLayer];
    }
	
    return self;
}

- (id)initWithGameTrackingObject:(GameTrackingObject *)gameTrackingObject
{
	if (self = [super init])
	{
		HudLayer *hudLayer		= [HudLayer node];
		GameLayer *gameLayer	= [[GameLayer alloc] initWithHud:hudLayer andGameTrackingObject:gameTrackingObject];
		
		[self addChild:hudLayer z:1];
		[self addChild:gameLayer];
	}
	
	return self;
}

@end
