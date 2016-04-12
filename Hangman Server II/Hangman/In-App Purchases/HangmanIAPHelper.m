//
//  HangmanIAPHelper.m
//  Hangman
//
//  Created by James Valaitis on 22/12/2012.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "HangmanIAPHelper.h"
#import "HMContentController.h"
#import "IAPProduct.h"
#import "JSNotifier.h"

@implementation HangmanIAPHelper

#pragma mark - Overridden Methods

/**
 *	a method to handle unique notification of user on status of product
 *
 *	@param	status				the status of the purchase
 *	@param	product				the product the user must be notified about
 */
- (void)notifyWithStatus:(NSString *)status
			  forProduct:(IAPProduct *)product
{
	NSString *message			= [NSString stringWithFormat:@"%@: %@", product.skProduct.localizedTitle, status];
	JSNotifier *notification	= [[JSNotifier alloc] initWithTitle:message];
	[notification showFor:2.0];
}

/**
 *	allows for the provision of specific content pertaining to a non-local url
 *
 *	@param	url					a non-local url which holds the content we want to unlock
 */
- (void)provideContentWithURL:(NSURL *)url
{
	[[HMContentController sharedInstance] unlockContentWithDirURL:url];
}

#pragma mark - Singleton Methods

+ (HangmanIAPHelper *)sharedInstance
{
	static dispatch_once_t once;
	static HangmanIAPHelper *sharedInstance;
	
	dispatch_once(&once,
	^{
		sharedInstance		= [[self alloc] init];
	});
	
	return sharedInstance;
}

@end
















































