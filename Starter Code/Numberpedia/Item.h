//
//  Item.h
//  Numberpedia
//
//  Created by James Valaitis on 03/12/2012.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

@interface Item : NSObject

@property (nonatomic, copy)	NSString	*name;
@property (nonatomic, copy)	NSNumber	*value;

+ (id)itemWithName:(NSString *)name
		  andValue:(NSNumber *)value;
- (id)initWithName:(NSString *)name
		  andValue:(NSNumber *)value;

@end
