//
//  Section.h
//  Numberpedia
//
//  Created by James Valaitis on 03/12/2012.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

@interface Section : NSObject

@property (nonatomic, strong, readonly)	NSArray	*items;

- (id)initWithArray:(NSArray *)array;

@end
