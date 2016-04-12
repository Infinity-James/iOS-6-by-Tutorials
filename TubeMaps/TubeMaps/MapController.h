//
//  MapController.h
//  TubeMaps
//
//  Created by James Valaitis on 08/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#pragma mark - MapController Public Interface

@interface MapController : UIViewController

- (void)routeFromCoordinate:(CLLocationCoordinate2D)startCoord
			   toCoordinate:(CLLocationCoordinate2D)destinationCoord;
- (void)routeFromCurrentLocationToCoordinate:(CLLocationCoordinate2D)destinationCoord;
- (void)routeToCurrentLocationFromCoordinate:(CLLocationCoordinate2D)startCoord;

@end