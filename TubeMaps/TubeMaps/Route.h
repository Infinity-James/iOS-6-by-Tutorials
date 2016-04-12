//
//  Route.h
//  TubeMaps
//
//  Created by James Valaitis on 19/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import <MapKit/MapKit.h>

@class  Station;

@interface Route : NSObject

@property (nonatomic, strong)	Station		*destinationStation;
@property (nonatomic, strong)	MKPolyline	*mapPolyline;
@property (nonatomic, strong)	Station		*startStation;

@end