//
//  ServingsController.m
//  RecipesKit
//
//  Created by James Valaitis on 26/03/2013.
//  Copyright (c) 2013 Felipe Last Marsetti. All rights reserved.
//

#import "ServingsController.h"

@interface ServingsController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation ServingsController

#pragma mark - Autorotation

/**
 *	returns all of the interface orientations that the view controller supports
 */
- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - UIPickerViewDelegate Methods

/**
 *	called by the picker view when it needs the number of components
 *
 *	@param	pickerView					picker view requesting the data
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

/**
 *	called when the picker needs the styled title to use for a given row in a given component
 *
 *	@param	pickerView					picker view requesting the data
 *	@param	row							zero-indexed number identifying a row of component
 *	@param	component					zero-indexed number identifying a component of pickerview
 */
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
			 attributedTitleForRow:(NSInteger)row
					  forComponent:(NSInteger)component
{
	NSMutableAttributedString *title	= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", row + 1]];
	
	return title;
}

/**
 *	called by the picker view when it needs the number of rows for a specified component
 *
 *	@param	pickerView					picker view requesting the data
 *	@param	component					zero-indexed number identifying a component of the picker view
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
	return 10;
}

#pragma mark - View Lifecycle

/**
 *	sent to the view controller when the app receives a memory warning
 */
- (void)didReceiveMemoryWarning
{
	if (!self.view.window)
	{
		self.pickerView					= nil;
		self.view						= nil;
	}
	
	[super didReceiveMemoryWarning];
}

@end