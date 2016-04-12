//
//  AppDelegate.m
//  CustomView
//
//  Created by James Valaitis on 05/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "AppDelegate.h"
#import "DynamicController.h"

@implementation AppDelegate

/**
 *	tells the delegate that the launch process is almost done and the app is almost ready to run
 *
 *	@param	application					the delegating application object
 *	@param	launchOptions				dictionary indicating the reason the application was launched (if any)
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window							= [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor			= [UIColor whiteColor];
	
	DynamicController *dynamicController= [[DynamicController alloc] initWithNibName:@"DynamicView" bundle:nil];
	
	self.window.rootViewController		= dynamicController;
    [self.window makeKeyAndVisible];
	
    return YES;
}


@end
