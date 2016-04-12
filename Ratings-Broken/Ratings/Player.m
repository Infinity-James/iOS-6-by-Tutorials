//
//  Player.m
//  Ratings
//
//  Created by James Valaitis on 21/11/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "Player.h"

@implementation Player

#pragma mark - NSCoding Methods

/**
 *	allows the encoding of objects when saving
 *
 *	@param	aCoder						the object used to encode our properties
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.name forKey:@"Name"];
	[aCoder encodeObject:self.game forKey:@"Game"];
	[aCoder encodeInt:self.rating forKey:@"Rating"];
}

/**
 *	allows the decoding of object when initialising
 *
 *	@param	aDecoder					the object used to decode our properties
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init])
	{
		self.name = [aDecoder decodeObjectForKey:@"Name"];
		self.game = [aDecoder decodeObjectForKey:@"Game"];
		self.rating = [aDecoder decodeIntForKey:@"Rating"];
	}
	
	return self;
}

@end
