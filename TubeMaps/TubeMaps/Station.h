//
//  Station.h
//  TubeMaps
//
//  Created by James Valaitis on 08/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import <MapKit/MapKit.h>

#pragma mark - Station Public Interface

@interface Station : NSObject <MKAnnotation> {}

#pragma mark - Public Methods

@property (nonatomic, copy)		NSString				*title;
@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;

#pragma mark - Public Properties

- (MKMapItem *)mapItem;

@end