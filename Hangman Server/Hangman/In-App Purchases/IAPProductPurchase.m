//
//  IAPProductPurchase.m
//  Hangman
//
//  Created by James Valaitis on 02/01/2013.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

#import "IAPProductPurchase.h"

static NSString	*const	kProductIdentifierKey	= @"ProductIdentifier";
static NSString	*const	kConsumableKey			= @"Consumable";
static NSString	*const	kTimesPurchasedKey		= @"TimesPurchased";
static NSString	*const	kLibraryRelativePathKey	= @"LibraryRelativePath";
static NSString	*const	kContentVersionKey		= @"ContentVersion";

@implementation IAPProductPurchase

#pragma mark - Initialisation

- (id)initWithProductIdentifier:(NSString *)productIdentifier
				   ifConsumable:(BOOL)consumable
				 timesPurchased:(int)timesPurchased
		withLibraryRelativePath:(NSString *)libraryRelativePath
			  andContentVersion:(NSString *)contentVersion
{
	if (self = [super init])
	{
		self.productIdentifier		= productIdentifier;
		self.consumable				= consumable;
		self.timesPurchased			= timesPurchased;
		self.libraryRelativePath	= libraryRelativePath;
		self.contentVersion			= contentVersion;
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
	[aCoder encodeObject:self.productIdentifier		forKey:kProductIdentifierKey];
	[aCoder encodeBool:self.consumable				forKey:kConsumableKey];
	[aCoder encodeInt:self.timesPurchased			forKey:kTimesPurchasedKey];
	[aCoder encodeObject:self.libraryRelativePath	forKey:kLibraryRelativePathKey];
	[aCoder encodeObject:self.contentVersion		forKey:kContentVersionKey];
}

/**
 *	allows the decoding of object when initialising
 *
 *	@param	aDecoder					the object used to decode our properties
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSString *productIdentifier		= [aDecoder decodeObjectForKey:kProductIdentifierKey];
	BOOL consumable					= [aDecoder decodeBoolForKey:kConsumableKey];
	int timesPurchased				= [aDecoder decodeIntForKey:kTimesPurchasedKey];
	NSString *libraryRelativePath	= [aDecoder decodeObjectForKey:kLibraryRelativePathKey];
	NSString *contentVersion		= [aDecoder decodeObjectForKey:kContentVersionKey];
	
	return [self initWithProductIdentifier:productIdentifier
							  ifConsumable:consumable
							timesPurchased:timesPurchased
				   withLibraryRelativePath:libraryRelativePath
						 andContentVersion:contentVersion];
}

@end
