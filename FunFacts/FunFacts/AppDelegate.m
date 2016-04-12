//
//  AppDelegate.m
//  FunFacts
//
//  Created by James Valaitis on 04/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "AppDelegate.h"
#import "SocialController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{		
    self.window							= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	SocialController *socialController	= [[SocialController alloc] initWithNibName:@"SocialView" bundle:nil];
	
	self.window.rootViewController		= socialController;
	
    self.window.backgroundColor			= [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
    return YES;
}

@end
