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

{
	BOOL				_buttonIsVisible;
	UIButton			*_centreButton;
	NSLayoutConstraint	*_centreYConstraint;
	UIButton			*_leftButton;
	UIButton			*_rightButton;
}

#pragma mark - Action & Selector Methods

- (void)leftButtonPressed
{
	_buttonIsVisible		= !_buttonIsVisible;
	
	if (_buttonIsVisible)
	{
		[self.view addSubview:_centreButton], _centreButton.alpha	= 0.0f;
		
		//	make sure centre button starts from correct position
		NSLayoutConstraint *constraint;
		[self centreTheCentreButton:constraint];
		[self.view layoutIfNeeded];
	}
	
	[self.view setNeedsUpdateConstraints];
	
	[UIView animateWithDuration:0.3f animations:
	^{
		[self.view layoutIfNeeded];
		_centreButton.alpha	= _buttonIsVisible ? 1.0f: 0.0f;
	}
	completion:^(BOOL finished)
	{
		if (!_buttonIsVisible)
			[_centreButton removeFromSuperview];
	}];
	
}

- (void)rightButtonPressed
{
	if (_centreYConstraint.constant == 0.0f)
		_centreYConstraint.constant	= 100.0f;
	else
		_centreYConstraint.constant	*= -1.0f;
	
	[UIView animateWithDuration:0.5f animations:
	^{
		[self.view layoutIfNeeded];
	}];
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
 *	called when the view controller’s view needs to update its constraints
 */
- (void)updateViewConstraints
{
	[super updateViewConstraints];
	
	//	remove all constraints
	[self.view removeConstraints:self.view.constraints];
	
	NSLayoutConstraint *constraint;
	NSArray *constraints;
	NSDictionary *viewsDictionary;
	
	viewsDictionary	= NSDictionaryOfVariableBindings(_centreButton, _leftButton, _rightButton);
	
	if (_buttonIsVisible)
	{
		//	place centre button in the centre would you believe
		[self centreTheCentreButton:constraint];
		
		//	sort out other buttons around the centre button
		constraints		= [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_leftButton]-[_centreButton]-[_rightButton]"
															   options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDictionary];
		[self.view addConstraints:constraints];
	}
	else
	{
		//	place centre button in the centre would you believe
		constraint		= [NSLayoutConstraint constraintWithItem:_leftButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
													  toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:-10.0f];
		[self.view addConstraint:constraint];
		constraint		= [NSLayoutConstraint constraintWithItem:_leftButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
													  toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
		[self.view addConstraint:constraint];
		
		//	algin button in centre
		constraints		= [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_leftButton]-(20)-[_rightButton]"
															   options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDictionary];
		[self.view addConstraints:constraints];
		
		_centreYConstraint	= nil;
	}
}

/**
 *	adds the subviews to our main view or to other subviews
 */
- (void)addSubviews
{
	[self.view addSubview:_centreButton];
	[self.view addSubview:_leftButton];
	[self.view addSubview:_rightButton];
}

/**
 *	gets the centre button in the centre
 */
- (void)centreTheCentreButton:(NSLayoutConstraint *)constraint
{
	constraint			= [NSLayoutConstraint constraintWithItem:_centreButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
												  toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
	_centreYConstraint	= constraint;
	[self.view addConstraint:constraint];
	constraint			= [NSLayoutConstraint constraintWithItem:_centreButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
												  toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
	[self.view addConstraint:constraint];
}

/**
 *	initialise subviews to be constrained and then added to our main view
 */
- (void)initialiseSubviews
{
	_centreButton	= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_centreButton setTitle:@"Centre" forState:UIControlStateNormal];
	[_centreButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	_leftButton		= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_leftButton setTitle:@"Left" forState:UIControlStateNormal];
	[_leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	_rightButton	= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_rightButton setTitle:@"Right" forState:UIControlStateNormal];
	[_rightButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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
	
	_buttonIsVisible	= YES;
	
	[self initialiseSubviews];
	[self addSubviews];
	[self.view setNeedsUpdateConstraints];
}


@end
