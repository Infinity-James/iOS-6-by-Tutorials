//
//  MainController.m
//  VisualCodeConstraints
//
//  Created by James Valaitis on 05/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "MainController.h"

@interface MainController ()

@end

@implementation MainController
{
	UIButton	*_cancelButton;
	UIButton	*_deleteButton;
	UIButton	*_nextButton;
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
	NSDictionary *viewsDictionary;
	NSArray *constraints;
	
	//	the views we are going to be applying constraints to
	viewsDictionary	= NSDictionaryOfVariableBindings(_deleteButton, _cancelButton, _nextButton);
	
	//	delete button set to be standard distance from left of superview
	constraints		= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_deleteButton]-(>=8)-[_cancelButton(==_deleteButton@700)]-[_nextButton(==_deleteButton@700)]-|"
															  options:NSLayoutFormatAlignAllBaseline
															  metrics:nil
																views:viewsDictionary];
	[self.view addConstraints:constraints];
	
	//	delete, cancel and next buttons all need to be along the bottom of the superview
	constraints		= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_deleteButton]-|"
															  options:kNilOptions
															  metrics:nil
																views:viewsDictionary];
	[self.view addConstraints:constraints];
}

/**
 *	adds the subviews to our main view or to other subviews
 */
- (void)addSubviews
{
	[self.view addSubview:_deleteButton];
	[self.view addSubview:_cancelButton];
	[self.view addSubview:_nextButton];
}

/**
 *	initialise subviews to be constrained and then added to our main view
 */
- (void)initialiseSubviews
{
	_deleteButton		= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
	[_deleteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	_cancelButton		= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[_cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	_nextButton		= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_nextButton setTitle:@"Next" forState:UIControlStateNormal];
	[_nextButton setTranslatesAutoresizingMaskIntoConstraints:NO];
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
	[self addSubviews];
	[self addSubviewConstraints];
}

@end
