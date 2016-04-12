//
//  BTAppDelegate.m
//  AppearanceChapter
//
//  Created by Adam Burkepile on 7/16/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import "DefaultTheme.h"
#import "BTAppDelegate.h"
#import "ThemeManager.h"

@implementation BTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[ThemeManager setSharedTheme:[DefaultTheme new]];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:kThemeChanged
													  object:nil
													   queue:[NSOperationQueue mainQueue]
												  usingBlock:^(NSNotification *notification)
	{
		UINavigationController *navigationController	= (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
		[ThemeManager customiseNavigationBar:navigationController.navigationBar];
	}];
	
    return YES;
}

@end
