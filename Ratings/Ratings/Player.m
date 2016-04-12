
#import "Player.h"

@implementation Player

#pragma mark - Initialisation

/**
 *	called to initialise a class instance
 */
- (id)init
{
	if (self = [super init])
	{
		self.playerID					= [[NSUUID UUID] UUIDString];
	}
	
	return self;
}

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
	[aCoder encodeObject:self.playerID forKey:@"ID"];
	[aCoder encodeInteger:self.rating forKey:@"Rating"];
}

/**
 *	allows the decoding of object when initialising
 *
 *	@param	aDecoder					the object used to decode our properties
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
	{
		self.name						= [aDecoder decodeObjectForKey:@"Name"];
		self.game						= [aDecoder decodeObjectForKey:@"Game"];
		self.playerID					= [aDecoder decodeObjectForKey:@"ID"];
		self.rating						= [aDecoder decodeIntegerForKey:@"Rating"];
	}
	
	return self;
}

@end