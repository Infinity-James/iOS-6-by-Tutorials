//
//  AppDelegate.m
//  SingleUIImageProject
//
//  Created by Jake Gundersen on 7/9/12.
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
    self.window								= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.viewController						= [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end