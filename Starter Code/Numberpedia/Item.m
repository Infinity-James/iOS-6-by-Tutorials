//
//  Item.m
//  Numberpedia
//
//  Created by James Valaitis on 03/12/2012.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Item.h"

@implementation Item

+ (id)itemWithName:(NSString *)name
		  andValue:(NSNumber *)value
{
	return [[self alloc] initWithName:name andValue:value];
}

- (id)initWithName:(NSString *)name
		  andValue:(NSNumber *)value
{
	if (self = [super init])
	{
		self.name	= name;
		self.value	= value;
	}
	
	return self;
}

- (NSComparisonResult)compare:(Item *)otherItem
{
	return [self.value compare:otherItem.value];
}

@end
