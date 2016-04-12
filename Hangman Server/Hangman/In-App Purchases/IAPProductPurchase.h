//
//  IAPProductPurchase.h
//  Hangman
//
//  Created by James Valaitis on 02/01/2013.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

@interface IAPProductPurchase : NSObject <NSCoding>

@property (nonatomic, assign)	BOOL		consumable;
@property (nonatomic, strong)	NSString	*contentVersion;
@property (nonatomic, strong)	NSString	*libraryRelativePath;
@property (nonatomic, strong)	NSString	*productIdentifier;
@property (nonatomic, assign)	int			timesPurchased;

- (id)initWithProductIdentifier:(NSString *)productIdentifier
				   ifConsumable:(BOOL)consumable
				 timesPurchased:(int)timesPurchased
		withLibraryRelativePath:(NSString *)libraryRelativePath
			  andContentVersion:(NSString *)contentVersion;

@end
