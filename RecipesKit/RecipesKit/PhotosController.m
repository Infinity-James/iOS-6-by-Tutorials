//
//  PhotosController.m
//  RecipesKit
//
//  Created by James Valaitis on 26/03/2013.
//  Copyright (c) 2013 Felipe Last Marsetti. All rights reserved.
//

#import "PhotosController.h"

@interface PhotosController ()

@property (nonatomic, weak) IBOutlet	UIImageView		*imageView;

@end

@implementation PhotosController

#pragma mark - Autorotation

/**
 *	returns all of the interface orientations that the view controller supports
 */
- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - View Lifecycle

/**
 *	sent to the view controller when the app receives a memory warning
 */
- (void)didReceiveMemoryWarning
{
	if (!self.view.window)
	{
		self.image						= nil;
		self.imageView					= nil;
		self.view						= nil;
	}
	
	[super didReceiveMemoryWarning];
}


/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.imageView.image				= self.image;
	
	self.view.backgroundColor			= [UIColor clearColor];
}

@end