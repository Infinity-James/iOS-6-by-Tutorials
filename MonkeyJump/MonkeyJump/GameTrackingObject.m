//
//  GameTrackingObject.m
//  MonkeyJump
//
//  Created by James Valaitis on 18/01/2013.
//
//

#import "GameTrackingObject.h"

@implementation GameTrackingObject

- (id)init
{
	if (self = [super init])
		self.seed			= 1;
	
	return self;
}

- (void)addJumpTime:(double)jumpTime
{
	if (!self.jumpTimingSinceStartOfGame)
		self.jumpTimingSinceStartOfGame		= @[].mutableCopy;
	
	[self.jumpTimingSinceStartOfGame addObject:@(jumpTime)];
}

- (void)addHitTime:(double)hitTime
{
	if (!self.hitTimingSinceStartOfGame)
		self.hitTimingSinceStartOfGame		= @[].mutableCopy;
	
	[self.hitTimingSinceStartOfGame addObject:@(hitTime)];
}

#pragma mark - NSCopying Methods

/**
 *	returns a new instance that’s a copy of the receiver
 *
 *	@param	zone				identifies an area of memory from which to allocate for the new instance
 */
- (id)copyWithZone:(NSZone *)zone
{
	GameTrackingObject *copy				= [[GameTrackingObject allocWithZone:zone] init];
	copy.jumpTimingSinceStartOfGame			= self.jumpTimingSinceStartOfGame.mutableCopy;
	copy.hitTimingSinceStartOfGame			= self.hitTimingSinceStartOfGame.mutableCopy;
	copy.seed								= self.seed;
	
	return copy;
}

#pragma mark - NSObject Methods

/**
 *	returns a string that describes the contents of the receiver
 */
- (NSString *)description
{
	return [NSString stringWithFormat:@"Jump times: %@, Hit times: %@, seed: %ld",
			self.jumpTimingSinceStartOfGame.description,
			self.hitTimingSinceStartOfGame.description,
			self.seed];
}

@end
