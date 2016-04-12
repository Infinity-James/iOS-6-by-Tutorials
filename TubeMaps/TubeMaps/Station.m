//
//  Station.m
//  TubeMaps
//
//  Created by James Valaitis on 08/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "Station.h"

#pragma mark - Station Implementation

@implementation Station {}

#pragma mark - Utility Methods

/**
 *	returns a map item representing this station
 */
- (MKMapItem *)mapItem
{
	//	creates dictionary to describe location
	NSDictionary *addressDictionary		= @{(NSString *)kABPersonAddressCountryKey	: @"UK",
											(NSString *)kABPersonAddressCityKey		: @"London",
											(NSString *)kABPersonAddressStreetKey	: @"10 Downing Street",
											(NSString *)kABPersonAddressZIPKey		: @"SW1A 2AA"};
	
	//	creates placemark use previously defined dictionary and coordinates of station, tells map where to display pin
	MKPlacemark *placemark				= [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDictionary];
	
	//	creates map item using placemark and sets some extra information before returning it
	MKMapItem *mapItem					= [[MKMapItem alloc] initWithPlacemark:placemark];
	mapItem.name						= self.title;
	mapItem.phoneNumber					= @"+44-20-8123-4567";
	mapItem.url							= [NSURL URLWithString:@"http://www.raywenderlich.com"];
	
	return mapItem;
}

@end