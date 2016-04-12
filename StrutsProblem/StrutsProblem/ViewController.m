//
//  ViewController.m
//  StrutsProblem
//
//  Created by James Valaitis on 04/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/**
 *	sent to the view controller before performing a one-step user interface rotation
 *
 *	@param	toInterfaceOrientation			new orientation for the user interface
 *	@param	duration						duration of the pending rotation, measured in seconds
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
										 duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	/*if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		CGRect rect				= self.topLeftView.frame;
		rect.size.width			= 210;
		rect.size.height		= 120;
		self.topLeftView.frame	= rect;
		
		rect					= self.topRightView.frame;
		rect.origin.x			= 250;
		rect.size.width			= 210;
		rect.size.height		= 120;
		self.topRightView.frame	= rect;
		
		rect					= self.bottomView.frame;
		rect.origin.y			= 160;
		rect.size.width			= 440;
		rect.size.height		= 120;
		self.bottomView.frame	= rect;
	}
	else
	{
		CGRect rect				= self.topLeftView.frame;
		rect.size.width			= 130;
		rect.size.height		= 200;
		self.topLeftView.frame	= rect;
		
		rect					= self.topRightView.frame;
		rect.origin.x			= 170;
		rect.size.width			= 130;
		rect.size.height		= 200;
		self.topRightView.frame	= rect;
		
		rect					= self.bottomView.frame;
		rect.origin.y			= 240;
		rect.size.width			= 280;
		rect.size.height		= 200;
		self.bottomView.frame	= rect;
	}*/
}

@end
