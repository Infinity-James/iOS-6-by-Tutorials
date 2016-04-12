//
//  FacebookWallController.m
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "FacebookWallController.h"

@interface FacebookWallController ()

@end

@implementation FacebookWallController

- (NSString *)feedString
{
	return @"https://graph.facebook.com/me/feed";
}

- (NSString *)titleString
{
	return @"Wall";
}

@end
