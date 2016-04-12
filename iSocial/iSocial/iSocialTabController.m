//
//  iSocialTabController.m
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "FacebookFeedController.h"
#import "FacebookWallController.h"
#import "iSocialTabController.h"
#import "LikeController.h"
#import "ProfileController.h"
#import "TwitterFeedController.h"

@interface iSocialTabController ()

@end

@implementation iSocialTabController

- (id)init
{
	if (self = [super init])
	{
		FacebookFeedController *facebookFeedController		= [[FacebookFeedController alloc] initWithNibName:@"FacebookFeedView" bundle:nil];
		FacebookWallController *facebookWallController		= [[FacebookWallController alloc] initWithNibName:@"FacebookWallView" bundle:nil];
		LikeController *likeController						= [[LikeController alloc] initWithNibName:@"LikeView" bundle:nil];
		ProfileController *profileController				= [[ProfileController alloc] initWithNibName:@"ProfileView" bundle:nil];
		TwitterFeedController *twitterController			= [[TwitterFeedController alloc] initWithNibName:@"TwitterFeedView" bundle:nil];
		
		facebookFeedController.tabBarItem					= [[UITabBarItem alloc] initWithTitle:@"Feed" image:[UIImage imageNamed:@"F"] tag:0];
		facebookWallController.tabBarItem					= [[UITabBarItem alloc] initWithTitle:@"Wall" image:[UIImage imageNamed:@"W"] tag:1];
		likeController.tabBarItem							= [[UITabBarItem alloc] initWithTitle:@"Like" image:[UIImage imageNamed:@"L"] tag:2];
		profileController.tabBarItem						= [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"P"] tag:3];
		twitterController.tabBarItem						= [[UITabBarItem alloc] initWithTitle:@"Tweets" image:[UIImage imageNamed:@"T"] tag:4];
		
		UINavigationController *feedNavigationController	= [[UINavigationController alloc] initWithRootViewController:facebookFeedController];
		UINavigationController *wallNavigationController	= [[UINavigationController alloc] initWithRootViewController:facebookWallController];
		
		self.viewControllers								= @[feedNavigationController, wallNavigationController, likeController,
																profileController, twitterController];
	}
	
	return self;
}


@end
