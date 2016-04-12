//
//  IAPHelper.m
//  Hangman
//
//  Created by James Valaitis on 22/12/2012.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "IAPHelper.h"
#import "IAPProduct.h"
#import "IAPProductInfo.h"
#import "IAPProductPurchase.h"
#import "VerificationController.h"

static	NSString	*const	IAPHelperPurchasesList	= @"purchases.plist";

@interface IAPHelper () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@end

@implementation IAPHelper
{
	SKProductsRequest					*_productsRequest;
	RequestProductsCompletionHandler	_completionHandler;
}

#pragma mark - Convenience Methods

/**
 *	adds the info to a product, whether it's existing or not
 *
 *	@param	info						the info we want to add to a product
 *	@param	productIdentifier			the product id correlating to the product we want to add info to
 */
- (void)	 addInfo:(IAPProductInfo *)info
forProductIdentifier:(NSString *)productIdentifier
{
	IAPProduct *product					= [self addProductForProductIdentifier:productIdentifier];
	product.info						= info;
}

/**
 *	either returns an existing product by the id, or creates a new one and returns it
 *	
 *	@param	productIdentifier			the product id correlating to the product we want to retrieve or create
 */
- (IAPProduct *)addProductForProductIdentifier:(NSString *)productidentifier
{
	IAPProduct *product					= self.products[productidentifier];
	
	if (!product);
	{
		product							= [[IAPProduct alloc] initWithProductIdentifier:productidentifier];
		self.products[productidentifier]= product;
	}
	
	return product;
}

/**
 *	purchases a specific product
 *
 *	@param	product					the in-app product to purchase
 */
- (void)buyProduct:(IAPProduct *)product
{
	//	check if purchase is allowed to happen
	NSAssert(product.allowedToPurchase, @"This product isn't allowed to be purchased.");
	NSLog(@"Buying %@", product.productIdentifier);
	
	//	if it is mark the product as being purchased and issue an skpayment to the default queue
	product.purchaseInProgress			= YES;
	SKPayment *payment					= [SKPayment paymentWithProduct:product.skProduct];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

/**
 *	creates a request for a list of products and sends it to apple
 *
 *	@param	completionHandler		used to notify caller about the success of request, and which products are available
 */
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
	//	a block must be copied before being stored to guarantee its availability in future
	_completionHandler					= [completionHandler copy];
	
	NSMutableSet *productIdentifiers	= [NSMutableSet setWithCapacity:self.products.count];
	
	//	loops through dictionary of products and adds each product id to set for product request
	for (IAPProduct *product in self.products.allValues)
	{
		product.availableForPurchase	= NO;
		[productIdentifiers addObject:product.productIdentifier];
	}
	
	//	make and send product request
	_productsRequest					= [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
	_productsRequest.delegate			= self;
	[_productsRequest start];
}

/**
 *	allows for past-purchases to be restored
 */
- (void)restoreCompletedTransactions
{
	//	looks for all non-consumable purchases made before and call updatedtransactions method with restored case
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - Initialisation

/**
 *	initialise an instance of this helper with a dictionary of products
 *
 *	@param	products				a dictionary of products with the key as a product id and the value as an iapproduct
 */
- (id)init
{
	if (self = [super init])
	{
		self.products				= @{}.mutableCopy;
		
		//	load all purchases made
		[self loadPurchases];
		
		NSURL *productInfosURL		= [[NSBundle mainBundle] URLForResource:@"productInfos" withExtension:@"plist"];
		NSArray *productInfosArray	= [NSArray arrayWithContentsOfURL:productInfosURL];
		
		for (NSDictionary *productInfosDictionary in productInfosArray)
		{
			IAPProductInfo *info	= [[IAPProductInfo alloc] initFromDictionary:productInfosDictionary];
			[self addInfo:info forProductIdentifier:info.productIdentifier];
		}
		
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	
	return self;
}

#pragma mark - Purchase Helper Methods

/**
 *	gets the iap product and sets appropriate iap product purchase on it
 *
 *	@param	purchase			purchase info to set on product
 *	@param	productIdentifier	product identifier pertaining to product we want
 */
- (void) addPurchase:(IAPProductPurchase *)purchase
forProductIdentifier:(NSString *)productIdentifier
{
	IAPProduct *product		= [self addProductForProductIdentifier:productIdentifier];
	product.purchase		= purchase;
}

/**
 *	returns path of app's library directory (library directory used for private app files)
 */
- (NSString *)libraryPath
{
	NSArray *libraryPaths	= NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return libraryPaths[0];	
}

/**
 *	called on start up to load all of the product purchases
 */
- (void)loadPurchases
{
	//	unarchive plist file with the list of iapproductpurchases
	NSString *purchasesPath			= [self purchasesPath];
	NSArray *purchasesArray			= [NSKeyedUnarchiver unarchiveObjectWithFile:purchasesPath];
	
	//	gets full path of each purchase and unlcoks content
	for (IAPProductPurchase *purchase in purchasesArray)
	{
		if (purchase.libraryRelativePath)
		{
			NSString *localPath		= [[self libraryPath] stringByAppendingPathComponent:purchase.libraryRelativePath];
			NSURL *localURL			= [NSURL fileURLWithPath:localPath isDirectory:YES];
			NSLog(@"Going to unlock content at file url: %@", localURL);
			[self provideContentWithURL:localURL];
		}
		
		//	adds or updates the product, updating takes care of when user purchased no longer available product
		[self addPurchase:purchase forProductIdentifier:purchase.productIdentifier];
		NSLog(@"Loaded purchase; %@; for %@ (%@)", purchase,  purchase.productIdentifier, purchase.contentVersion);
	}
}

/**
 *	returns information about previous purchase for a product identifier
 *
 *	@param	productIdentifier	the product identifier pertaining to the product which we want the purcjase history of
 */
- (IAPProductPurchase *)purchaseForProductIdentifier:(NSString *)productIdentifier
{
	IAPProduct *product		= self.products[productIdentifier];
	if (!product)			return nil;
	
	return product.purchase;
}

/**
 *	returns full path of file storing app purchases information
 */
- (NSString *)purchasesPath
{
	return [[self libraryPath] stringByAppendingPathComponent:IAPHelperPurchasesList];
}

/**
 *	called whenever new purchase is made and saves the array of purchases
 */
- (void)savePurchases
{
	NSString *purchasesPath			= [self purchasesPath];
	NSMutableArray *purchasesArray	= @[].mutableCopy;
	
	//	loops through all products purchased and adds to array
	for (IAPProduct *product in self.products.allValues)
		if (product.purchase)
			[purchasesArray addObject:product.purchase];
	
	//	saves array to plist file
	BOOL success					= [NSKeyedArchiver archiveRootObject:purchasesArray toFile:purchasesPath];
	
	if (!success)
		NSLog(@"Failed to save purchases to %@", purchasesPath);
}

#pragma mark - Receipt Validation

- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction
{
	IAPProduct *product					= self.products[transaction.payment.productIdentifier];
	VerificationController *verifier	= [VerificationController sharedInstance];
	
	[verifier verifyPurchase:transaction completionHandler:^(BOOL success) {
		if (success)
		{
			NSLog(@"Successfully validated the receipt.");
			[self provideContentForTransaction:transaction withProductIdentifier:transaction.payment.productIdentifier];
		}
		
		else
		{
			NSLog(@"Failed to validate receipt.");
			product.purchaseInProgress	= NO;
			[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
		}
	}];
}

#pragma mark - SKPaymentTransactionObserver Methods

- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStateFailed:		[self failedTransaction:transaction];	break;
			case SKPaymentTransactionStatePurchased:	[self completeTransaction:transaction];	break;
			case SKPaymentTransactionStateRestored:		[self restoreTransaction:transaction];	break;
			default:																			break;
		}
	}
}

#pragma mark - SKProductsRequestDelegate Methods

/**
 *	called when the apple app store responds to the product request
 *
 *	@param	request					product request sent to the apple app store
 *	@param	response				detailed information about the list of products
 */
- (void)productsRequest:(SKProductsRequest *)request
	 didReceiveResponse:(SKProductsResponse *)response
{
	//	now response to request has been received we no longer need the request
	_productsRequest		= nil;
	
	//	loop through each store kit product that apple has determined is available ad get associated iapproduct
	NSArray *skProducts		= response.products;
	for (SKProduct* skProduct in skProducts)
	{
		IAPProduct *product	= self.products[skProduct.productIdentifier];
		product.skProduct	= skProduct;
		//	mark the product available for purchase
		[product setAvailableForPurchase:YES];
		
		NSLog(@"Product available for purchase: %@ %@ %0.2f",
			  skProduct.productIdentifier,
			  skProduct.localizedTitle,
			  skProduct.price.floatValue);
	}
	
	//	loop through each unavailable product and mark as such
	for (NSString *invalidProductIdentifier in response.invalidProductIdentifiers)
	{
		IAPProduct *product	= self.products[invalidProductIdentifier];
		[product setAvailableForPurchase:NO];
		
		NSLog(@"Product is invalid and is being removed: %@", invalidProductIdentifier);
	}
	
	//	make array of available producs to pass into completion handler
	NSMutableArray *availableProducts	= @[].mutableCopy;
	for (IAPProduct *product in self.products.allValues)
		if (product.availableForPurchase)
			[availableProducts addObject:product];
	
	//	notify caller of success and pass in the available products then nullify completion handler because it's used
	_completionHandler(YES, availableProducts);
	_completionHandler		= nil;
}

#pragma mark - SKRequestDelegate Methods

/**
 *	called if the request failed to execute
 *
 *	@param	request					request that failed
 *	@param	error					error that caused the request to fail
 */
- (void) request:(SKRequest *)request
didFailWithError:(NSError *)error
{
	NSLog(@"Failed to load the list of products");
	_productsRequest		= nil;
	
	//	notify caller of failure and nullify completion handler becuase it has been used
	_completionHandler(NO, nil);
	_completionHandler		= nil;
}

#pragma mark - Transaction Handling Methods

/**
 *	when a product is successfully purchased, we complete the transaction
 *
 *	@param	transaction			the transaction to handle
 */
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
	NSLog(@"Completing transaction.");
	
	[self validateReceiptForTransaction:transaction];
}

/**
 *	when a product had failed we notify the user
 *
 *	@param	transaction			the transaction to handle
 */
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	NSLog(@"Failed transaction.");
	
	//	if the failure was not due to cancellation then we log the error
	if (transaction.error.code != SKErrorPaymentCancelled)
		NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
	
	//	get the product which failed
	IAPProduct *product			= self.products[transaction.payment.productIdentifier];
	
	//	notify user of the failure and then mark product as no longer in-progress of being purchased
	[self notifyWithStatus:@"Purchase failed." forProductIdentifier:transaction.payment.productIdentifier];
	product.purchaseInProgress	= NO;
	
	//	finish the transaction off
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

/**
 *	used to notify the user about the status of a product
 *
 *	@param	status				the status of the purchase
 *	@param	productIdentifier	product id of product to notify user about
 */
- (void)notifyWithStatus:(NSString *)status
	forProductIdentifier:(NSString *)productIdentifier
{
	IAPProduct *product			= self.products[productIdentifier];
	
	//	call sub-class implementation to handle unique product correctly
	[self notifyWithStatus:status forProduct:product];
}

/**
 *	called to provide content to the user after a successful purchase of a product
 *
 *	@param	transaction			the transaction which ahs taken place to purchase content for user
 *	@param	productIdentifier	the product id of the product we're providing content for
 */
- (void)provideContentForTransaction:(SKPaymentTransaction *)transaction
			   withProductIdentifier:(NSString *)productIdentifier
{
	IAPProduct *product			= self.products[productIdentifier];
	
	//	if the product is a consumable item then we call the method to increment the correct user default
	if (product.info.consumable)
		[self purchaseConsumable:product.info.consumableIdentifier
			forProductIdentifier:productIdentifier
					  withAmount:product.info.consumableAmount];
	
	//	if it's non-consumable we call the method which will unlock the item
	else
	{
		NSURL *bundleURL		= [[NSBundle mainBundle].resourceURL URLByAppendingPathComponent:product.info.bundleDirectory];
		[self purchaseNonConsumableAtURL:bundleURL forProductIdentifier:productIdentifier];
	}
	
	//	notify user that purchase had been completed
	[self notifyWithStatus:@"Purchase complete." forProductIdentifier:productIdentifier];
	
	//	mark product as no longer being purchased and finish the transaction
	product.purchaseInProgress	= NO;
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)purchaseConsumable:(NSString *)consumableIdentifier
	  forProductIdentifier:(NSString *)productIdentifier
				withAmount:(int)consumableAmount
{
	int previousAmount						= [[NSUserDefaults standardUserDefaults] integerForKey:consumableIdentifier];
	int newAmount							= previousAmount + consumableAmount;
	
	[[NSUserDefaults standardUserDefaults] setInteger:newAmount forKey:consumableIdentifier];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	IAPProductPurchase *previousPurchase	= [self purchaseForProductIdentifier:productIdentifier];
	
	//	if there's a previous purchase we record the fact they purchased it again
	if (previousPurchase)
		previousPurchase.timesPurchased++;
	
	//	if this is their first purchase of this product then we create a new purchase and save it
	else
	{
		IAPProductPurchase *purchase		= [[IAPProductPurchase alloc] initWithProductIdentifier:productIdentifier
																					   ifConsumable:YES
																					 timesPurchased:1
																			withLibraryRelativePath:@""
																				  andContentVersion:@""];
		[self addPurchase:purchase forProductIdentifier:productIdentifier];
	}
	
	[self savePurchases];
}

/**
 *	allows the purchase of a non-consumable item
 *
 *	@param	nonLocalURL				the url of the item probably not yet in the library directory
 *	@param	productIdentifier		product identifier of the non-consumable product to be purchased
 */
- (void)purchaseNonConsumableAtURL:(NSURL *)nonLocalURL
			 forProductIdentifier:(NSString *)productIdentifier
{
	NSError *error;
	BOOL success					= FALSE;
	BOOL exists						= FALSE;
	BOOL isDirectory				= FALSE;
	
	//	gets the last part of the url (directory name) and appends to library directory for new location
	NSString *libraryRelativePath	= nonLocalURL.lastPathComponent;
	NSString *localPath				= [[self libraryPath] stringByAppendingPathComponent:libraryRelativePath];
	NSURL *localURL					= [NSURL fileURLWithPath:localPath isDirectory:YES];
	
	//	if directory already exists we delete it
	exists							= [[NSFileManager defaultManager] fileExistsAtPath:localPath isDirectory:&isDirectory];
	
	if (exists)
	{
		success						= [[NSFileManager defaultManager] removeItemAtURL:localURL error:&error];
		
		if (!success)
			NSLog(@"Couldn't delete the directory at %@ due to error: %@", localURL, error.localizedDescription);
		else
			NSLog(@"Deleted the directory at %@", localURL);
	}
	
	NSLog(@"Copying directory from %@ to %@", nonLocalURL, localURL);
	
	//	copies directory from current location (inside app bundle) to library directory
	success							= [[NSFileManager defaultManager] copyItemAtURL:nonLocalURL toURL:localURL error:&error];
	
	if (!success)
	{
		NSLog(@"Failed to copy directory: %@", error.localizedDescription);
		[self notifyWithStatus:@"Copying failed." forProductIdentifier:productIdentifier];
		return;
	}
	
	NSString *contentVersion		= @"";
	
	//	unlocks content for purchase
	[self provideContentWithURL:localURL];
	
	IAPProductPurchase *previousPurchase		= [self purchaseForProductIdentifier:productIdentifier];
	
	//	if there is a previous purchase...
	if (previousPurchase)
	{
		previousPurchase.timesPurchased++;
		
		//	find where old product identifier is saved and remove it
		NSString *oldPath			= [[self libraryPath] stringByAppendingPathComponent:previousPurchase.libraryRelativePath];
		success						= [[NSFileManager defaultManager] removeItemAtPath:oldPath error:&error];
		
		if (!success)
			NSLog(@"Could not remove old purchase at %@", oldPath);
		else
			NSLog(@"Removed old purchase at %@", oldPath);
		
		//	updates purchase info with new directory name and content version
		previousPurchase.libraryRelativePath	= libraryRelativePath;
		previousPurchase.contentVersion			= contentVersion;
		previousPurchase.consumable				= NO;
	}
	
	//	if no previous purchase it records a new one
	else
	{
		IAPProductPurchase *purchase			= [[IAPProductPurchase alloc] initWithProductIdentifier:productIdentifier
																						   ifConsumable:NO
																						 timesPurchased:1
																				withLibraryRelativePath:libraryRelativePath
																					  andContentVersion:contentVersion];
		[self addPurchase:purchase forProductIdentifier:productIdentifier];
	}
	
	[self notifyWithStatus:@"Purchase Complete." forProductIdentifier:productIdentifier];
	
	[self savePurchases];
}

/**
 *	when a product needs to be restored, we provide the content
 *
 *	@param	transaction			the transaction to handle
 */
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	NSLog(@"Restoring transaction.");
	
	[self validateReceiptForTransaction:transaction];
}

#pragma mark - Virtual Methods

/**
 *	a method intended to be subclassed to handle unique notification of user on status of product
 *
 *	@param	status				the status of the purchase
 *	@param	product				the product the user must be notified about
 */
- (void)notifyWithStatus:(NSString *)status
			  forProduct:(IAPProduct *)product
{
}

/**
 *	sub-classes to allow for the provision of specific content pertaining to a non-local url
 *
 *	@param	url					a non-local url which holds the content we want to unlock
 */
- (void)provideContentWithURL:(NSURL *)url
{
}

@end
















































