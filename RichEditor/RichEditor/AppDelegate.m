//
//  AppDelegate.m
//  RichEditor
//
//  Created by James Valaitis on 22/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "AppDelegate.h"
#import "FileController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window								= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor				= [UIColor whiteColor];
	
	FileController *fileController			= [[FileController alloc] initWithNibName:@"FileView" bundle:nil];
	UINavigationController *navController	= [[UINavigationController alloc] initWithRootViewController:fileController];
	
	self.window.rootViewController			= navController;
    [self.window makeKeyAndVisible];
	
    return YES;
}

@end
