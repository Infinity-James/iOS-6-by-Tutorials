//
//  IAPProduct.h
//  Hangman
//
//  Created by James Valaitis on 23/12/2012.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

@class IAPProductInfo;
@class IAPProductPurchase;
@class SKDownload;
@class SKProduct;

@interface IAPProduct : NSObject

@property (nonatomic, assign)	BOOL				availableForPurchase;
@property (nonatomic, strong)	IAPProductInfo		*info;
@property (nonatomic, strong)	NSString			*productIdentifier;
@property (nonatomic, assign)	CGFloat				progress;
@property (nonatomic, strong)	IAPProductPurchase	*purchase;
@property (nonatomic, assign)	BOOL				purchaseInProgress;
@property (nonatomic, strong)	SKDownload			*skDownload;
@property (nonatomic, strong)	SKProduct			*skProduct;

- (id)initWithProductIdentifier:(NSString *)productIdentifier;
- (BOOL)allowedToPurchase;

@end
