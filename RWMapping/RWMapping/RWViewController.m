//
//  RWViewController.m
//  RWMapping
//
//  Created by Matt Galloway on 23/06/2012.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RWViewController.h"

@interface RWViewController () <MKMapViewDelegate> {}

typedef NS_ENUM(NSInteger, MapMode)
{
    MapModeNormal = 0,
    MapModeLoading,
    MapModeDirections,
};

@property (nonatomic, weak) IBOutlet	MKMapView	*mapView;
@property (nonatomic, assign)			MapMode	mapMode;

@end

@implementation RWViewController {}

#pragma mark - Autorotation

/**
 *	returns whether the view controller’s contents should auto rotate
 */
- (BOOL)shouldAutorotate
{
	return YES;
}

/**
 *	returns all of the interface orientations that the view controller supports
 */
- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Setter & Getter Methods

- (void)setMapMode:(MapMode)mapMode
{
    _mapMode =							mapMode;
    
    switch (mapMode)
	{
        case MapModeNormal:		self.title = @"Maps";		break;
        case MapModeLoading:	self.title = @"Loading...";	break;
        case MapModeDirections:	self.title = @"Directions";	break;
    }
}

#pragma mark - View Lifecycle

/**
 *	sent to the view controller when the app receives a memory warning
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
