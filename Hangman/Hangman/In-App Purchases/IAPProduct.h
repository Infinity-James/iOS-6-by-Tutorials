//
//  IAPProduct.h
//  Hangman
//
//  Created by James Valaitis on 23/12/2012.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

@class SKProduct;

@interface IAPProduct : NSObject

@property (nonatomic, assign)	BOOL		availableForPurchase;
@property (nonatomic, strong)	NSString	*productIdentifier;
@property (nonatomic, assign)	BOOL		purchase;
@property (nonatomic, assign)	BOOL		purchaseInProgress;
@property (nonatomic, strong)	SKProduct	*skProduct;

- (id)initWithProductIdentifier:(NSString *)productIdentifier;
- (BOOL)allowedToPurchase;

@end
