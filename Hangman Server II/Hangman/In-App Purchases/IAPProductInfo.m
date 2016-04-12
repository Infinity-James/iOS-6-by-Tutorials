//
//  IAPProductInfo.m
//  Hangman
//
//  Created by James Valaitis on 02/01/2013.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

#import "IAPProductInfo.h"

@implementation IAPProductInfo

#pragma mark - Initialisation

- (id)initFromDictionary:(NSDictionary *)dictionary
{
	if (self = [super init])
	{
		self.bundleDirectory		= dictionary[@"bundleDir"];
		self.consumable				= [dictionary[@"consumable"] boolValue];
		self.consumableAmount		= [dictionary[@"consumableAmount"] intValue];
		self.consumableIdentifier	= dictionary[@"consumableIdentifier"];
		self.icon					= dictionary[@"icon"];
		self.productIdentifier		= dictionary[@"productIdentifier"];
	}
	
	return self;
}

@end
