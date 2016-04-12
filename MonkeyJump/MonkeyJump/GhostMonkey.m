//
//  GhostMonkey.m
//  MonkeyJump
//
//  Created by James Valaitis on 18/01/2013.
//
//

#import "GhostMonkey.h"

@implementation GhostMonkey

- (void)changeState:(MonkeyState)newState
{
	[super changeState:newState];
	
	if (newState == kDead)
	{
		[self stopAllActions];
		[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monkey_ghost_dead.png"]];
	}
}

@end
