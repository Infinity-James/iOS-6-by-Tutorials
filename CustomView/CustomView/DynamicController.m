//
//  DynamicController.m
//  VisualCodeConstraints
//
//  Created by James Valaitis on 05/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "DynamicController.h"

@interface DynamicController ()

@end

@implementation DynamicController

#pragma mark - Autorotation

/**
 *	sent to the view controller before performing a one-step user interface rotation
 *
 *	@param	toInterfaceOrientation		new orientation for the user interface
 *	@param	duration					duration of the pending rotation, measured in seconds
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
										 duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	NSLog(@"Autolayout Trace: %@", [[UIWindow keyWindow] _autolayoutTrace]);
}

#pragma mark - View Lifecycle

/**
 *	notifies the view controller that its view was added to a view hierarchy
 */
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	NSLog(@"Autolayout Trace: %@", [[UIWindow keyWindow] _autolayoutTrace]);
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.myView removeConstraint:self.heightConstraint];
	[self.myView removeConstraint:self.widthConstraint];
}


@end
