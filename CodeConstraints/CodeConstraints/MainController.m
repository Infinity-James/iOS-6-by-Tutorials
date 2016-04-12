//
//  MainController.m
//  CodeConstraints
//
//  Created by James Valaitis on 05/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "MainController.h"

@interface MainController ()

@end

@implementation MainController
{
	UIButton		*_button1;
	UIButton		*_button2;
}

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

#pragma mark - Convenience Methods

/**
 *	adds the constraints to the subviews
 */
- (void)addSubviewConstraints
{
	//	place button 1 in horizontal centre of screen
	NSLayoutConstraint *constraint	= [NSLayoutConstraint constraintWithItem:_button1
																   attribute:NSLayoutAttributeCenterX
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self.view
																   attribute:NSLayoutAttributeCenterX
																  multiplier:1.0f
																    constant:0.0f];
	
	
	[self.view addConstraint:constraint];
	
	//	place button 1 20 points from bottom of screen
	constraint						= [NSLayoutConstraint constraintWithItem:_button1
																   attribute:NSLayoutAttributeBottom
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self.view
																   attribute:NSLayoutAttributeBottom
																  multiplier:1.0f
																    constant:-20.0f];
	
	[self.view addConstraint:constraint];
	
	//	apply button 1 constraint to be at least 200 points wide
	constraint						= [NSLayoutConstraint constraintWithItem:_button1
																   attribute:NSLayoutAttributeWidth
																   relatedBy:NSLayoutRelationGreaterThanOrEqual
																	  toItem:nil
																   attribute:NSLayoutAttributeNotAnAttribute
																  multiplier:1.0f
																	constant:200.0f];
	
	[_button1 addConstraint:constraint];
	
	//	make sure button 1 is never larger than 300 points wide
	constraint						= [NSLayoutConstraint constraintWithItem:_button1
																   attribute:NSLayoutAttributeWidth
																   relatedBy:NSLayoutRelationEqual
																	  toItem:nil
																   attribute:NSLayoutAttributeNotAnAttribute
																  multiplier:1.0f
																	constant:300.0f];
	constraint.priority				= 950;
	
	[_button1 addConstraint:constraint];
	
	//	make button 1 a square unless this means it would be too tall
	constraint						= [NSLayoutConstraint constraintWithItem:_button1
																   attribute:NSLayoutAttributeHeight
																   relatedBy:NSLayoutRelationEqual
																	  toItem:_button1
																   attribute:NSLayoutAttributeWidth
																  multiplier:0.5f
																	constant:0.0f];
	
	constraint.priority				= 950;
	
	[_button1 addConstraint:constraint];
	
	//	always make sure button 1 is never too tall for the screen
	constraint						= [NSLayoutConstraint constraintWithItem:_button1
																   attribute:NSLayoutAttributeTop
																   relatedBy:NSLayoutRelationGreaterThanOrEqual
																	  toItem:self.view
																   attribute:NSLayoutAttributeTop
																  multiplier:1.0f
																	constant:20.0f];
	
	[self.view addConstraint:constraint];
	
	//	make sure button 1 is always greater than 60 points from the leading side of the view
	constraint						= [NSLayoutConstraint constraintWithItem:_button1
																   attribute:NSLayoutAttributeLeading
																   relatedBy:NSLayoutRelationGreaterThanOrEqual
																	  toItem:self.view
																   attribute:NSLayoutAttributeLeading
																  multiplier:1.0f
																	constant:60.0f];
	
	[self.view addConstraint:constraint];
	
	//	place button 2 above button 1 by 8 points
	constraint						= [NSLayoutConstraint constraintWithItem:_button2
																   attribute:NSLayoutAttributeBottom
																   relatedBy:NSLayoutRelationEqual
																	  toItem:_button1
																   attribute:NSLayoutAttributeTop
																  multiplier:1.0
																	constant:-8.0f];
	
	[self.view addConstraint:constraint];
}

/**
 *	adds the subviews to our main view or to other subviews
 */
- (void)addSubviews
{
	[self.view addSubview:_button1];
	[self.view addSubview:_button2];
}

/**
 *	initialise subviews to be constrained and then added to our main view
 */
- (void)initialiseSubviews
{
	_button1			= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_button1 setTitle:@"Button 1" forState:UIControlStateNormal];
	[_button1 sizeToFit];
	[_button1 setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	_button2			= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_button2 setTitle:@"Button 2" forState:UIControlStateNormal];
	[_button2 setTranslatesAutoresizingMaskIntoConstraints:NO];
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
	
	[self initialiseSubviews];
	[self addSubviewConstraints];
	[self addSubviews];
}

@end
