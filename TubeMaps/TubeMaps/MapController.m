//
//  MapController.m
//  TubeMaps
//
//  Created by James Valaitis on 08/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapController.h"
#import "Route.h"
#import "Station.h"

typedef void(^LocationCallback)(CLLocationCoordinate2D coordinate);

#pragma mark - MapController Private Interface

@interface MapController () <MKMapViewDelegate, UIActionSheetDelegate>
{
	Route								*_currentRoute;
	Station								*_droppedPin;
	LocationCallback					_foundLocationCallback;
	MKPolyline							*_mapPolyline;
	Station								*_selectedStation;
	NSMutableArray						*_stations;
}

#pragma mark - Private Typedefs

typedef NS_ENUM(NSInteger, MapMode)
{
    MapModeNormal = 0,
    MapModeLoading,
    MapModeDirections,
};

#pragma mark - Private Properties

@property (nonatomic, strong)		MKMapView	*mapView;
@property (nonatomic, assign)		MapMode		mapMode;

@end

#pragma mark - MapController Implementation

@implementation MapController {}

#pragma mark - Action & Selector Methods

/**
 *
 */
- (void)clearDirections
{
	self.mapMode						= MapModeNormal;
}

/**
 *
 */
- (void)handleLongPress:(UIGestureRecognizer *)recogniser
{
	//	only drop pin when long press begins
	if (recogniser.state == UIGestureRecognizerStateBegan)
	{
		//	if there's already a pin we remove it
		if (_droppedPin)
			[self.mapView removeAnnotation:_droppedPin], _droppedPin	= nil;
	
		//	finds long press point within map view and the matched coordinates of where it occured
		CGPoint touchPoint				= [recogniser locationInView:self.mapView];
		CLLocationCoordinate2D touchMapCoordinate	= [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
		
		//	creates new station onject to represent the coordinate of touch then adds it to the map
		_droppedPin						= [[Station alloc] init];
		_droppedPin.coordinate			= touchMapCoordinate;
		_droppedPin.title				= @"Dropped Pin";
		
		[self.mapView addAnnotation:_droppedPin];
	}
	
}

/**
 *	accepts a block to perform when the user location is found
 *
 *	@param	callback					to be performed when user location found
 */
- (void)performAfterFindingLocation:(LocationCallback)callback
{
	if (self.mapView.userLocation)
	{
		if (callback)
			callback(self.mapView.userLocation.coordinate);
		else
			_foundLocationCallback		= [callback copy];
	}
	
}

/**
 *	send the current route to maps.app
 */
- (void)routeInMaps
{
	if (_currentRoute)
	{
		NSArray *mapItems				= @[_currentRoute.startStation.mapItem, _currentRoute.destinationStation.mapItem];
		NSDictionary *launchOptions		= @{MKLaunchOptionsDirectionsModeKey	: MKLaunchOptionsDirectionsModeDriving};
		[MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
	}
}

/**
 *	opens the current view in maps.app
 */
- (void)showInMaps
{
	//	create array of map items (for each station) and the current location
	NSMutableArray *mapItems			= @[].mutableCopy;
	
	for (Station *station in _stations)
		[mapItems addObject:station.mapItem];
	
	[mapItems addObject:[MKMapItem mapItemForCurrentLocation]];
	
	//	gets boundign box of map points and converts into coordinate region
	MKMapRect boundingBox				= _mapPolyline.boundingMapRect;
	MKCoordinateRegion boundingBoxRegion= MKCoordinateRegionForMapRect(boundingBox);
	
	//	wraps centre and span in nsvalue objects
	NSValue *centreAsValue				= [NSValue valueWithMKCoordinate:boundingBoxRegion.center];
	NSValue *spanAsValue				= [NSValue valueWithMKCoordinateSpan:boundingBoxRegion.span];
	
	//	creates launch dictionary with relevant values and sets the map to be a hybrid view
	NSDictionary *launchOptions			= @{MKLaunchOptionsMapTypeKey	: @(MKMapTypeHybrid),
											MKLaunchOptionsMapCenterKey	: centreAsValue,
											MKLaunchOptionsMapSpanKey	: spanAsValue};
	
	//	opens the maps.app with the items and options
	[MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
}

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

#pragma mark - Convenience & Helper Methods

/**
 *	adds any gestures needed for this view and subviews
 */
- (void)addGestures
{
	//	create a long press gesture recogniser, set up time and add it to the map view
	UILongPressGestureRecognizer *longPressRecogniser	= [[UILongPressGestureRecognizer alloc] initWithTarget:self
																										action:@selector(handleLongPress:)];
	
	longPressRecogniser.minimumPressDuration			= 1.0f;
	
	[self.mapView addGestureRecognizer:longPressRecogniser];
}

/**
 *	loads the json data detailing points on map
 */
- (void)loadData
{
	//	read json file of coordinates into array and store count
	NSData *data						= [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"victoria_line" ofType:@"json"]];
	NSArray *stationData				= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
	NSUInteger stationCount				= stationData.count;
	
	//	create c array of correct size  and initialise internal stations array or correct size
	NSInteger index						= 0;
	CLLocationCoordinate2D *polylines	= malloc(sizeof(CLLocationCoordinate2D) * stationCount);
	_stations							= [[NSMutableArray alloc] initWithCapacity:stationCount];
	
	//	loop over each station json data and read the latitude and longitude to create coordinates for polyline array
	for (NSDictionary *stationDictionary in stationData)
	{
		CLLocationDegrees latitude		= [[stationDictionary objectForKey:@"latitude"] doubleValue];
		CLLocationDegrees longitude		= [[stationDictionary objectForKey:@"longitude"] doubleValue];
		CLLocationCoordinate2D coord	= CLLocationCoordinate2DMake(latitude, longitude);
		polylines[index]				= coord;
		
		//	create new station object with pair of coordinates and station name then implement index for c array
		Station *station				= [[Station alloc] init];
		station.title					= [stationDictionary objectForKey:@"name"];
		station.coordinate				= coord;
		[_stations addObject:station];
		
		index++;
	}
	
	//	create polyline with coordinates and give count (c-style array) then free the array
	_mapPolyline						= [MKPolyline polylineWithCoordinates:polylines count:stationCount];
	free(polylines);
}

/**
 *	returns nearest station to a specified coordinate
 *
 *	@param	coordinate					coordinate of position to find closest station for
 */
- (Station *)nearestStationToCoordinate:(CLLocationCoordinate2D)coordinate
{
	//	create temporary variables to hold nearest station and nearest distance that can be used in the block
	__block Station *nearestStation;
	__block CLLocationDistance nearestDistance	= DBL_MAX;
	CLLocation *coordinateLocation		= [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
	
	//	iterates through each station
	[_stations enumerateObjectsUsingBlock:^(Station *station, NSUInteger idx, BOOL *stop)
	{
		//	creates temp location object with current coordinates then finds station distance from that location
		CLLocation *thisLocation		= [[CLLocation alloc] initWithLatitude:station.coordinate.latitude longitude:station.coordinate.longitude];
		CLLocationDistance thisDistance	= [coordinateLocation distanceFromLocation:thisLocation];
		
		//	if this station is closer to the user we store it and the nearest station
		if (thisDistance < nearestDistance)
			nearestDistance = thisDistance, nearestStation = station;
	}];
	
	//	return the station found closest to the target coordinate
	return nearestStation;
}

/**
 *	calculates a route from the given start coordinate to the given destination coordinate
 *
 *	@param	startCoord					the starting position of the route
 *	@param	destinationCoord			the final destination of the route
 */
- (void)routeFromCoordinate:(CLLocationCoordinate2D)startCoord
			   toCoordinate:(CLLocationCoordinate2D)destinationCoord
{
	//	find which stations are closest to start and destination points
	Station *startStation				= [self nearestStationToCoordinate:startCoord];
	Station *destinationStation			= [self nearestStationToCoordinate:destinationCoord];
	
	//	gets the index of these stations within our array
	NSUInteger startStationIndex		= [_stations indexOfObject:startStation];
	NSUInteger destinationStationIndex	= [_stations indexOfObject:destinationStation];
	
	//	determines whether the directions increments through array or decrement
	BOOL goingForwards					= destinationStationIndex > startStationIndex;
	
	//	work out how many stations the train will pass through along route
	NSUInteger stationCount;
	
	if (goingForwards)
		stationCount					= destinationStationIndex - startStationIndex + 1;
	else
		stationCount					= startStationIndex - destinationStationIndex + 1;
	
	//	creates c-style array to hold each station that is along the route
	CLLocationCoordinate2D *polyLineCoordinates	= malloc(sizeof(CLLocationCoordinate2D) * stationCount);
	
	for (NSUInteger i = 0; i < stationCount; i++)
	{
		NSUInteger stationIndex;
		
		if (goingForwards)
			stationIndex				= startStationIndex + i;
		else
			stationIndex				= startStationIndex - i;
		
		Station *thisStation			= _stations[stationIndex];
		polyLineCoordinates[i]			= thisStation.coordinate;
	}
	
	//	create new route holding the gathered data
	Route *newRoute						= [[Route alloc] init];
	newRoute.startStation				= startStation;
	newRoute.destinationStation			= destinationStation;
	newRoute.mapPolyline				= [MKPolyline polylineWithCoordinates:polyLineCoordinates count:stationCount];
	_currentRoute						= newRoute;
	
	//	clean up c-style array and set the map mode accordingly
	free(polyLineCoordinates);
	
	self.mapMode						= MapModeDirections;
}

/**
 *
 *
 *
 */
- (void)routeFromCurrentLocationToCoordinate:(CLLocationCoordinate2D)destinationCoord
{
	self.mapMode						= MapModeLoading;
	[self performAfterFindingLocation:^(CLLocationCoordinate2D coordinate)
	{
		[self routeFromCoordinate:coordinate toCoordinate:destinationCoord];
	}];
}

/**
 *
 *
 *
 */
- (void)routeToCurrentLocationFromCoordinate:(CLLocationCoordinate2D)startCoord
{
	self.mapMode						= MapModeLoading;
	[self performAfterFindingLocation:^(CLLocationCoordinate2D coordinate)
	{
		[self routeFromCoordinate:startCoord toCoordinate:coordinate];
	}];
}

/**
 *
 */
- (void)setUpMapView
{
	self.mapView						= [[MKMapView alloc] initWithFrame:self.view.frame];
	self.mapView.delegate				= self;
	self.mapView.showsUserLocation		= YES;
	[self.view addSubview:self.mapView];
	
	self.mapMode						= MapModeNormal;
	
	CLLocationCoordinate2D centre		= CLLocationCoordinate2DMake(51.525635, -0.081985);
	MKCoordinateSpan span				= MKCoordinateSpanMake(0.12649, 0.12404);
	MKCoordinateRegion regionToDisplay	= MKCoordinateRegionMake(centre, span);
	
	[self.mapView setRegion:regionToDisplay animated:NO];
}

#pragma mark - Map Mode Set Up

/**
 *	selected when the user wants direcions from their position to a selected station
 */
- (void)mapModeDirectionsSelected
{
	//	set appropriate titles and we don't need any buttons
	self.title								= @"Directions";
	self.navigationItem.leftBarButtonItem	= [[UIBarButtonItem alloc] initWithTitle:@"Clear"
																			 style:UIBarButtonItemStyleBordered
																			target:self
																			action:@selector(clearDirections)];
	self.navigationItem.rightBarButtonItem	= [[UIBarButtonItem alloc] initWithTitle:@"Route In Maps"
																			  style:UIBarButtonItemStyleBordered
																			 target:self
																			 action:@selector(routeInMaps)];
	
	//	whilst displaying a route we don't need to show every station or the dropped pin
	[self.mapView removeAnnotations:_stations];
	[self.mapView removeOverlay:_mapPolyline];
	if (_droppedPin)
		[self.mapView removeAnnotation:_droppedPin];
	
	//	add annotations and overlay for current route
	[self.mapView addAnnotation:_currentRoute.startStation];
	[self.mapView addAnnotation:_currentRoute.destinationStation];
	[self.mapView addOverlay:_currentRoute.mapPolyline];
}

/**
 *	this mode is used for when the user's position is being loaded
 */
- (void)mapModeLoadingSelected
{
	//	set an appropriate title whilst loading and remove the buttons
	self.title								= @"Loading...";
	self.navigationItem.leftBarButtonItem	= nil;
	self.navigationItem.rightBarButtonItem	= nil;
	
	//	whilst loading nothing should be shown
	if (_currentRoute)
	{
		[self.mapView removeAnnotation:_currentRoute.startStation];
		[self.mapView removeAnnotation:_currentRoute.destinationStation];
		[self.mapView removeOverlay:_currentRoute.mapPolyline];
		_currentRoute						= nil;
	}
	
	[self.mapView removeAnnotations:_stations];
	[self.mapView removeOverlay:_mapPolyline];
	if (_droppedPin)
		[self.mapView removeAnnotation:_droppedPin];
}

/**
 *	when the normal map mode is selected we perform relevant set up
 */
- (void)mapModeNormalSelected
{
	//	set the title and add buttons for locating user and showing the items in the maps.app
	self.title = @"Maps";
	
	self.navigationItem.leftBarButtonItem	= [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
	self.navigationItem.rightBarButtonItem	= [[UIBarButtonItem alloc] initWithTitle:@"Show In Maps"
																			  style:UIBarButtonItemStyleBordered
																			 target:self
																			 action:@selector(showInMaps)];
	
	//	if there's a current route we have to remove those annotations and the overlay
	if (_currentRoute)
	{
		[self.mapView removeAnnotation:_currentRoute.startStation];
		[self.mapView removeAnnotation:_currentRoute.destinationStation];
		[self.mapView removeOverlay:_currentRoute.mapPolyline];
		_currentRoute						= nil;
	}
	
	//	if there's a dropped pin then we should add it back
	if (_droppedPin)
		[self.mapView addAnnotation:_droppedPin];
	
	//	add the stations and the polyline of the stations
	[self.mapView addAnnotations:_stations];
	[self.mapView addOverlay:_mapPolyline];
}

#pragma mark - MKMapViewDelegate Methods

/**
 *	tells the delegate that the user tapped one of the annotation view’s accessory buttons
 *
 *	@param	mapView						map view containing the specified annotation view
 *	@param	view						annotation view whose button was tapped
 *	@param	control						control that was tapped
 */
- (void)			  mapView:(MKMapView *)mapView
			   annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
	_selectedStation					= (Station *)view.annotation;
	
	//	creates action sheet with two buttons that are available for every pin
	UIActionSheet *actionSheet			= [[UIActionSheet alloc] initWithTitle:@""
															   delegate:self
													  cancelButtonTitle:nil
												 destructiveButtonTitle:nil
													  otherButtonTitles:@"Show In Maps", @"Route From Current Location", nil];
	
	//	if there is a dropped pin and it isn't this annotation then we offer route from it
	if (_droppedPin && view.annotation != _droppedPin)
		[actionSheet addButtonWithTitle:@"Route From Dropped Pin"];
	
	//	adds cancel button and store which button it is
	[actionSheet addButtonWithTitle:@"Cancel"];
	actionSheet.cancelButtonIndex		= actionSheet.numberOfButtons - 1;
	
	//	show action sheet in current view
	[actionSheet showInView:self.view];
}

/**
 *	tells the delegate that the location of the user was updated
 *
 *	@param	mapView						map view that is tracking the user’s location
 *	@param	userLocation				location object representing the user’s latest location
 */
- (void)	  mapView:(MKMapView *)mapView 
didUpdateUserLocation:(MKUserLocation *)userLocation
{
	if (_foundLocationCallback)
		_foundLocationCallback(userLocation.coordinate);
	
	_foundLocationCallback				= nil;
}

/**
 *	tells the delegate that the region displayed by the map view just changed
 *
 *	@param	mapView						map view whose visible region changed
 *	@param	annotation					whether the change to the new region was animated
 */
- (void)		mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated
{
	NSLog(@"Region Did Change");
}

/**
 *	returns the view associated with the specified annotation object
 *
 *	@param	mapView						map view that requested the annotation view
 *	@param	annotation					object representing the annotation that is about to be displayed
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView
			viewForAnnotation:(id<MKAnnotation>)annotation
{
	//	if this is a station annotation we create a pin annotation view
	if ([annotation isKindOfClass:[Station class]])
	{
		static NSString *const kPinIdentifier	= @"Station";
		MKPinAnnotationView *view		= (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kPinIdentifier];
		
		//	if there is no view in reuse pool we create one with a callout
		if (!view)
		{
			view						= [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinIdentifier];
			view.canShowCallout			= YES;
			view.calloutOffset			= CGPointMake(-5, 5);
			view.animatesDrop			= NO;
		}
		
		if (annotation == _droppedPin)
			view.pinColor = MKPinAnnotationColorPurple, view.draggable = YES;
		else
			view.pinColor = MKPinAnnotationColorRed, view.draggable = NO;
		
		if (self.mapMode == MapModeNormal)
			view.rightCalloutAccessoryView	= [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		else
			view.rightCalloutAccessoryView	= nil;
		
		return view;
	}
	
	return nil;
}

/**
 *	asks the delegate for the overlay view to use when displaying the specified overlay object
 *
 *	@param	mapView						map view that requested the overlay view
 *	@param	overlay						object representing the overlay that is about to be displayed
 */
- (MKOverlayView *)mapView:(MKMapView *)mapView
			viewForOverlay:(id<MKOverlay>)overlay
{
	//	creates view for polyline we created earlier
	MKPolylineView *overlayView			= [[MKPolylineView alloc] initWithPolyline:overlay];
	overlayView.lineWidth				= 10.0f;
	
	if (overlay == _mapPolyline)
		overlayView.strokeColor				= [UIColor blueColor];
	else if (overlay == _currentRoute.mapPolyline)
		overlayView.strokeColor				= [UIColor greenColor];
	
	return overlayView;
}

#pragma mark - Setter & Getter Methods

- (void)setMapMode:(MapMode)mapMode
{
    _mapMode							= mapMode;
    
    switch (mapMode)
	{
        case MapModeNormal:		[self mapModeNormalSelected];			break;
        case MapModeLoading:	[self mapModeLoadingSelected];			break;
        case MapModeDirections:	[self mapModeDirectionsSelected];		break;
    }
}

#pragma mark - UIActionSheetDelegate Methods

/**
 *	sent to the delegate after an action sheet is dismissed from the screen
 *
 *	@param	actionSheet					action sheet that was dismissed
 *	@param	buttonIndex					index of the button that was clicked
 */
- (void)	  actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != actionSheet.cancelButtonIndex)
	{
		switch (buttonIndex)
		{
			//	this means that the maps app chould be opened with the selected station and walkign direction
			case 0:
			{
				MKMapItem *mapItem			= _selectedStation.mapItem;
				NSDictionary *launchOptions	= @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
				[mapItem openInMapsWithLaunchOptions:launchOptions];
			}		break;
				
			//	user has requested route to selected station from their current location
			case 1:	[self routeFromCurrentLocationToCoordinate:_selectedStation.coordinate];	break;
			
			//	user had requested durections to this station from the dropped pin
			case 2: [self routeFromCoordinate:_droppedPin.coordinate toCoordinate:_selectedStation.coordinate];	break;
		}
	}
	
	//	selected station is reset and ready for re-use
	_selectedStation					= nil;
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
	
	self.title							= @"London Tubes";
	
	[self loadData];
}

/**
 *	notifies the view controller that its view is about to be added to a view hierarchy
 *
 *	@param	animated					whether the view needs to be added to the window with an animation
 */
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self setUpMapView];

	[self addGestures];
}

@end