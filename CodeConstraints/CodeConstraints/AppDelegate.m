//
//  AppDelegate.m
//  CodeConstraints
//
//  Created by James Valaitis on 05/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window							= [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor			= [UIColor whiteColor];
	
	MainController *mainController		= [[MainController alloc] initWithNibName:@"MainView" bundle:nil];
	
	self.window.rootViewController		= mainController;
    [self.window makeKeyAndVisible];
	
    return YES;
}

@end
