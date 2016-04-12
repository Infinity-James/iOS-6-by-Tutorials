//
//  AppDelegate.m
//  FilterMe
//
//  Created by Jake Gundersen on 9/5/12.
//  Copyright (c) 2012 Jake Gundersen. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

#pragma mark - UIApplicationDelegate Methods

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
	
	NSLog(@"Window Bounds: (%f, %f)", self.window.bounds.size.width, self.window.bounds.size.height);
	
	ViewController *viewController		= [[ViewController alloc] init];
	UINavigationController *navigation	= [[UINavigationController alloc] initWithRootViewController:viewController];
	
	self.window.rootViewController		= navigation;
	
    [self.window makeKeyAndVisible];
	
    return YES;
}

@end