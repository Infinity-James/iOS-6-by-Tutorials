//
//  IAPProductInfo.h
//  Hangman
//
//  Created by James Valaitis on 02/01/2013.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

@interface IAPProductInfo : NSObject

@property (nonatomic, strong)	NSString	*bundleDirectory;
@property (nonatomic, assign)	BOOL		consumable;
@property (nonatomic, assign)	int			consumableAmount;
@property (nonatomic, strong)	NSString	*consumableIdentifier;
@property (nonatomic, strong)	NSString	*icon;
@property (nonatomic, strong)	NSString	*productIdentifier;

- (id)initFromDictionary:(NSDictionary *)dictionary;

@end
