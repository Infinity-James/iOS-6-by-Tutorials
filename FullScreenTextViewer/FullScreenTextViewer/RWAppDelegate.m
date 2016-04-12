//
//  RWAppDelegate.m
//  FullScreenImageViewer
//
//  Created by Matt Galloway on 18/07/2012.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "RWAppDelegate.h"

#import "RWViewController.h"

@interface RWAppDelegate ()
@property (nonatomic, strong) RWViewController *viewController;
@end

@implementation RWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.viewController = (RWViewController*)[(UINavigationController*)self.window.rootViewController topViewController];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (url.isFileURL) {
        [self.viewController openTextURL:url];
    } else if ([url.scheme isEqualToString:@"text"]) {
        NSString *urlAsString = url.absoluteString;
        urlAsString = [urlAsString stringByReplacingOccurrencesOfString:@"text://" withString:@"http://"];
        [self.viewController openTextURL:[NSURL URLWithString:urlAsString]];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
