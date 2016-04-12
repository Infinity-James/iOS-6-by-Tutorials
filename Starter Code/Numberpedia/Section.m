//
//  Section.m
//  Numberpedia
//
//  Created by James Valaitis on 03/12/2012.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Section.h"

@interface Section ()

@property (nonatomic, strong, readwrite)	NSMutableArray	*items;

@end

@implementation Section

- (id)initWithArray:(NSArray *)array
{
	if (self = [super init])
		self.items			= array.mutableCopy;
	
	return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
	return self.items[idx];
}

- (id)objectInItemsAtIndex:(NSUInteger)index
{
	return self.items[index];
}

@end
