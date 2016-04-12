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
#import "VerificationController.h"

@interface IAPHelper () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@end

@implementation IAPHelper
{
	SKProductsRequest					*_productsRequest;
	RequestProductsCompletionHandler	_completionHandler;
}

#pragma mark - Convenience Methods

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
- (id)initWithProducts:(NSMutableDictionary *)products
{
	if (self = [super init])
	{
		self.products				= products;
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	
	return self;
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
	
	//	loop through each unavailable product and mark as asuch
	for (NSString *invalidProductIdentifier in response.invalidProductIdentifiers)
	{
		IAPProduct *product	= self.products[invalidProductIdentifier];
		[product setAvailableForPurchase:NO];
		
		NSLog(@"Product is invalid and is being removed: %@", invalidProductIdentifier);
	}
	
	//	make array of available producstpass into completion handler
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
	
	//	call sub-class implementation to handle unique product correctly
	[self provideContentForProductIdentifier:productIdentifier];
	
	//	notify user that purchase had been completed
	[self notifyWithStatus:@"Purchase complete." forProductIdentifier:productIdentifier];
	
	//	mark product as no longer being purchased and finish the transaction
	product.purchaseInProgress	= NO;
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
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
 *	a method intended to be sub-classed to provide user the correct unique content for a specific product
 *
 *	@param	productIdentifier	the product id of the product we're providing content for
 */
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier
{
}

@end
















































