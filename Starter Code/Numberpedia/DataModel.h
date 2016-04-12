//
//  DataModel.h
//  Numberpedia
//
//  Created by James Valaitis on 03/12/2012.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

@interface DataModel : NSObject

@property (nonatomic, strong, readonly)	NSArray	*sortedItems;
@property (nonatomic, strong, readonly)	NSArray	*sortedSectionNames;

- (void)sortByValue;
- (void)clearSortedItems;
- (id)	objectAtIndexedSubscript:(NSUInteger)idx;
- (id)	objectForKeyedSubscript:(id)key;

@end
