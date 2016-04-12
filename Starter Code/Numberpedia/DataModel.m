//
//  DataModel.m
//  Numberpedia
//
//  Created by James Valaitis on 03/12/2012.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "DataModel.h"
#import "Item.h"
#import "Section.h"


@interface DataModel ()

@property (nonatomic, strong, readwrite)	NSArray	*sortedItems;
@property (nonatomic, strong, readwrite)	NSArray	*sortedSectionNames;

@end

@implementation DataModel
{
	NSDictionary	*_dictionary;
}

- (id)init
{
	if (self = [super init])
	{
		Section *physics		= [[Section alloc] initWithArray:@[
								   [Item itemWithName:@"Avogadro" andValue:@6.02214129e23],
								   [Item itemWithName:@"Boltzman" andValue:@1.3806503e-23],
								   [Item itemWithName:@"Planck" andValue:@6.626068e-34],
								   [Item itemWithName:@"Rydberg" andValue:@1.097373e-7]]];
		
		Section *mathematics	= [[Section alloc] initWithArray:@[
								   [Item itemWithName:@"e" andValue:@2.71828183],
								   [Item itemWithName:@"π" andValue:@3.14159265],
								   [Item itemWithName:@"Pythagoras’ constant" andValue:@1.414213562],
								   [Item itemWithName:@"Tau ( )" andValue:@6.2831853]]];
		
		Section *fun			= [[Section alloc] initWithArray:@[
								   [Item itemWithName:@"Absolute Zero" andValue:@-273.15],
								   [Item itemWithName:@"Beverly Hills" andValue:@90210],
								   [Item itemWithName:@"Golden Ratio" andValue:@1.618],
								   [Item itemWithName:@"Number of Human Bones" andValue:@214],
								   [Item itemWithName:@"Unlucky Number" andValue:@13]]];
		
		_dictionary				= @{@"Physics Constants" : physics,
									@"Mathematics" : mathematics,
									@"Fun Numbers" : fun,};
		
		self.sortedSectionNames	= [_dictionary.allKeys sortedArrayUsingSelector:@selector(compare:)];
	}
	
	return self;
}

- (void)sortByValue
{
	NSMutableArray *allItems	= [NSMutableArray arrayWithCapacity:50];
	
	[_dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, Section *section, BOOL *stop)
	 {
		 [allItems addObjectsFromArray:section.items];
	 }];
	
	self.sortedItems			= [allItems sortedArrayUsingSelector:@selector(compare:)];
}

- (void)clearSortedItems
{
	self.sortedItems			= nil;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
	return self.sortedSectionNames[idx];
}

- (id)objectForKeyedSubscript:(id)key
{
	return _dictionary[key];
}

@end
