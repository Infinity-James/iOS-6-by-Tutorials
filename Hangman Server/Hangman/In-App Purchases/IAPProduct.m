//
//  IAPProduct.m
//  Hangman
//
//  Created by James Valaitis on 23/12/2012.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "IAPProduct.h"
#import "IAPProductInfo.h"
#import "IAPProductPurchase.h"

@implementation IAPProduct

#pragma mark - Convenience Methods

/**
 *	returns whether this product is available for purchase or not
 */
- (BOOL)allowedToPurchase
{
	if (!self.availableForPurchase)				return NO;
	if (!self.info)								return NO;
	if (!self.info.consumable && self.purchase)	return NO;
	if (self.purchaseInProgress)				return NO;
	
	return YES;
}

#pragma mark - Initialisation

/**
 *	initialise an instance of an iapproduct with a product identifier
 *
 *	@param	productIdentifier		product identifier of this in-app purchase product
 */
- (id)initWithProductIdentifier:(NSString *)productIdentifier
{
	if (self = [super init])
	{
		self.availableForPurchase	= NO;
		self.productIdentifier		= productIdentifier;
		self.skProduct				= nil;
	}
	
	return self;
}

@end
