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

#define kHundredHints	@"com.andbeyond.jamesvalaitis.hangman.onehundredhints"
#define kTenHints		@"com.andbeyond.jamesvalaitis.hangman.tenhints"

#define kHardWords		@"com.andbeyond.jamesvalaitis.hangman.hardwords"
#define kiOSWords		@"com.andbeyond.jamesvalaitis.hangman.ioswords"

@implementation HangmanIAPHelper

#pragma mark - Convenience Methods

- (void)unlockWordsForProductIdentifier:(NSString *)productIdentifier
							inDirectory:(NSString *)directory
{
	//	finds product for this id and marks as purchased
	IAPProduct *product		= self.products[productIdentifier];
	product.purchase		= YES;
	
	//	set nsuserdefault to track whether purchased or not
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	//	unlock content with the hmcontentcontroller
	NSURL *resourceURL		= [NSBundle mainBundle].resourceURL;
	[[HMContentController sharedInstance] unlockWordsWithDirURL:[resourceURL URLByAppendingPathComponent:directory]];
}

#pragma mark - Initialisation

- (id)init
{
	IAPProduct *tenHints	= [[IAPProduct alloc] initWithProductIdentifier:kTenHints];
	IAPProduct *hundredhints= [[IAPProduct alloc] initWithProductIdentifier:kHundredHints];
	
	IAPProduct *hardWords	= [[IAPProduct alloc] initWithProductIdentifier:kHardWords];
	IAPProduct *iOSWords	= [[IAPProduct alloc] initWithProductIdentifier:kiOSWords];
	
	NSMutableDictionary *products
							= @{tenHints.productIdentifier : tenHints,
								hundredhints.productIdentifier : hundredhints,
								hardWords.productIdentifier : hardWords,
								iOSWords.productIdentifier : iOSWords}.mutableCopy;
	
	if (self = [super initWithProducts:products])
	{
		if ([[NSUserDefaults standardUserDefaults] boolForKey:kHardWords])
			[self unlockWordsForProductIdentifier:kHardWords inDirectory:@"HardWords"];
		
		if ([[NSUserDefaults standardUserDefaults] boolForKey:kiOSWords])
			[self unlockWordsForProductIdentifier:kiOSWords inDirectory:@"iOSWords"];
	}
	
	return self;
}

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
 *	a method to provide user the correct unique content for a specific product
 *
 *	@param	productIdentifier	the product id of the product we're providing content for
 */
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier
{
	//	get pointer to shared content controller
	HMContentController *contentController	= [HMContentController sharedInstance];
	
	//	if the user bought more hints, increment the hints appropriately
	if ([productIdentifier isEqualToString:kTenHints])
		[contentController setHints:contentController.hints + 10];

	else if ([productIdentifier isEqualToString:kHundredHints])
		[contentController setHints:contentController.hints + 100];
	
	else if ([productIdentifier isEqualToString:kHardWords])
		[self unlockWordsForProductIdentifier:productIdentifier inDirectory:@"HardWords"];
	
	else if ([productIdentifier isEqualToString:kiOSWords])
		[self unlockWordsForProductIdentifier:productIdentifier inDirectory:@"iOSWords"];
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
















































