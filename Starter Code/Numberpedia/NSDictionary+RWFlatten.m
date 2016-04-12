//
//  NSDictionary+RWFlatten.m
//  Numberpedia
//
//  Created by James Valaitis on 03/12/2012.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "NSDictionary+RWFlatten.h"

@implementation NSDictionary (RWFlatten)

- (NSArray *)flattenIntoArray
{
	NSMutableArray *allValues	= [NSMutableArray arrayWithCapacity:self.count];
	
	[self enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *array, BOOL *stop)
	{
		[allValues addObjectsFromArray:array];
	}];
	
	return allValues;
}

@end
