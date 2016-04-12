//
//  AppDelegate.m
//  TubeMaps
//
//  Created by James Valaitis on 08/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "MapController.h"

#pragma mark - App Delegate Implementation

@implementation AppDelegate
{
	MapController						*_mapController;
}

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
	
	_mapController						= [[MapController alloc] init];
	UINavigationController *navigation	= [[UINavigationController alloc] initWithRootViewController:_mapController];
	
	self.window.rootViewController		= navigation;
    [self.window makeKeyAndVisible];
	
    return YES;
}

/**
 *	asks the delegate to open a resource identified by url
 *
 *	@param	application					application object
 *	@param	url							object representing a url
 *	@param	sourceApplication			bundle id of the application that is requesting your application to open the url
 *	@param	annotation					property-list object from source application to communicate information to the receiving application
 */
- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation	
{
	//	this app supports directions requests only
	if ([MKDirectionsRequest isDirectionsRequestURL:url])
	{
		//	allocates new directions request object with url (handles decoding of data) and gets the start and end points
		MKDirectionsRequest *request	= [[MKDirectionsRequest alloc] initWithContentsOfURL:url];
		MKMapItem *startItem			= request.source;
		MKMapItem *destinationItem		= request.destination;
		
		//	handles various types of routing then returns yes to signify we handled url
		if (startItem.isCurrentLocation)
			[_mapController routeFromCurrentLocationToCoordinate:destinationItem.placemark.location.coordinate];
		else if (destinationItem.isCurrentLocation)
			[_mapController routeToCurrentLocationFromCoordinate:startItem.placemark.location.coordinate];
		else
			[_mapController routeFromCoordinate:startItem.placemark.location.coordinate toCoordinate:destinationItem.placemark.location.coordinate];
		
			return YES;
	}
	
	return NO;
}

@end