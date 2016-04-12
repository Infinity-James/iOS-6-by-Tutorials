//
//  IAPHelper.h
//  Hangman
//
//  Created by James Valaitis on 22/12/2012.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

@class IAPProduct;

typedef void(^RequestProductsCompletionHandler)(BOOL success, NSArray *products);

@interface IAPHelper : NSObject

@property (nonatomic, strong)	NSMutableDictionary	*products;

- (void)buyProduct:								(IAPProduct *)						product;
- (void)cancelDownloads:						(NSArray *)							downloads;
- (id)	init;
- (void)pauseDownloads:							(NSArray *)							downloads;
- (void)requestProductsWithCompletionHandler:	(RequestProductsCompletionHandler)	completionHandler;
- (void)restoreCompletedTransactions;
- (void)resumeDownloads:						(NSArray *)							downloads;

@end
