//
//  AppDelegate.m
//  PassesPreview
//
//  Created by James Valaitis on 24/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window								= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor				= [UIColor whiteColor];
	
	MainController *mainController			= [[MainController alloc] initWithNibName:@"MainView" bundle:nil];
	
    self.window.rootViewController			= mainController;
    
    [self.window makeKeyAndVisible];
	
    return YES;
}

@end
