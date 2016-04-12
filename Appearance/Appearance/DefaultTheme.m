//
//  BatmanTheme.m
//  Appearance
//
//  Created by James Valaitis on 28/03/2013.
//  Copyright (c) 2013 Adam Burkepile. All rights reserved.
//

#import "DefaultTheme.h"

#pragma mark - Default Theme Implementation

@implementation DefaultTheme {}

#pragma mark - Initialisation

/**
 *	called to initialise a class instance
 */
- (id)init
{
	if (self = [super init])
	{
		_coloursForGradient				= @[@[[UIColor whiteColor], [UIColor grayColor], [UIColor blackColor]],
											@[@0.0f, @0.9f, @1.0f]];
	}
	
	return self;
}

#pragma mark - Theme Methods: Bar Button Item Appearance

/**
 *	returns a dictionary for the various properties associated with bar button items
 */
- (NSDictionary *)barButtonTextDictionary
{
	return @{	UITextAttributeFont				: [UIFont fontWithName:@"Helvetica-Bold" size:12.0f],
				UITextAttributeTextColor		: [UIColor whiteColor],
				UITextAttributeTextShadowColor	: [UIColor blackColor],
				UITextAttributeTextShadowOffset	: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, -1.0f)]};
}

/**
 *	returns an image for 'done' bar button items when they are highlighted & landscape
 */
- (UIImage *)imageForBarButtonDoneHighlightedLandscape
{
	return nil;
}

/**
 *	returns an image for 'done' bar button items when they are highlighted & portrait
 */
- (UIImage *)imageForBarButtonDoneHighlightedPortrait
{
	return nil;
}

/**
 *	returns an image for 'done' bar button items when they are normal & landscape
 */
- (UIImage *)imageForBarButtonDoneNormalLandscape
{
	return nil;
}

/**
 *	returns an image for 'done' bar button items when they are normal & portrait
 */
- (UIImage *)imageForBarButtonDoneNormalPortrait
{
	return nil;
}

/**
 *	returns an image for standard bar button items when they are highlighted & landscape
 */
- (UIImage *)imageForBarButtonHighlightedLandscape
{
	return nil;
}

/**
 *	returns an image for standard bar button items when they are highlighted & portrait
 */
- (UIImage *)imageForBarButtonHighlightedPortrait
{
	return nil;
}

/**
 *	returns an image for standard bar button items when they are normal & landscape
 */
- (UIImage *)imageForBarButtonNormalLandscape
{
	return nil;
}

/**
 *	returns an image for standard bar button items when they are normal & portrait
 */
- (UIImage *)imageForBarButtonNormalPortrait
{
	return nil;
}

#pragma mark - Theme Methods: Button Appearance

/**
 *	returns a dictionary of properties for uibuttons
 */
- (NSDictionary *)buttonTextDictionary
{
	return nil;
}

/**
 *	returns an image for when a button is highlighted
 */
- (UIImage *)imageForButtonHighlighted
{
	return nil;
}

/**
 *	returns an image for when a button is just standard
 */
- (UIImage *)imageForButtonNormal
{
	return nil;
}

#pragma mark - Theme Methods: General Appearance

/**
 *	returns the background colour of the views
 */
- (UIColor *)backgroundColour
{
	return [UIColor whiteColor];
}

#pragma mark - Theme Methods: Label Appearance

/**
 *	returns a dictionary of properties for uilabels
 */
- (NSDictionary *)labelTextDictionary
{
	return nil;
}

#pragma mark - Theme Methods: Navigation Bar Appearance

/**
 *	returns the image for the navigation bar when it is landscape
 */
- (UIImage *)imageForNavigationBarLandscape
{
	return nil;
}

/**
 *	returns the image for the navigation bar when it is portrait
 */
- (UIImage *)imageForNavigationBarPortrait
{
	return nil;
}

/**
 *	returns an image for the shadow of the navigation bar
 */
- (UIImage *)imageForNavigationBarShadow
{
	return nil;
}

/**
 *	returns a dictionary for the navigation bar text font, colour etc.
 */
- (NSDictionary *)navigationBarTextDictionary
{
	return nil;
}

#pragma mark - Theme Methods: Page Control Appearance

/**
 *	tint color for the current page item
 */
- (UIColor *)pageCurrentTintColour
{
	return [UIColor blackColor];
}

/**
 *	tint color for the page items
 */
- (UIColor *)pageTintColour
{
	return [UIColor lightGrayColor];
}

#pragma mark - Theme Methods: Progress Bar Customisation

/**
 *	returns an image to use for the portion of the progress bar that is filled
 */
- (UIImage *)imageForProgressBar
{
	return nil;
}

/**
 *	returns an image to use for the portion of the track that is not filled
 */
- (UIImage *)imageForProgressBarTrack
{
	return nil;
}

/**
 *	returns the colour to tint the portion of the progress bar that is filled
 */
- (UIColor *)progressBarTintColour
{
	return nil;
}

/**
 *	returns the colour shown for the portion of the progress bar that is not filled
 */
- (UIColor *)progressBarTrackTintColour
{
	return nil;	
}

#pragma mark - Theme Methods: Stepper Appearance

/**
 *	returns an image for the decrement icon on the uistepper control
 */
- (UIImage *)imageForStepperDecrement
{
	return nil;
}

/**
 *	returns an image for the increment icon on the uistepper control
 */
- (UIImage *)imageForStepperDividerSelected
{
	return nil;
}

/**
 *	returns an image for the divider of the unselected uistepper control
 */
- (UIImage *)imageForStepperDividerUnselected
{
	return nil;
}

/**
 *	returns an image for the divider of the selected uistepper control
 */
- (UIImage *)imageForStepperIncrement
{
	return nil;
}

/**
 *	returns an image for a selected section of the uistepper control
 */
- (UIImage *)imageForStepperSelected
{
	return nil;
}

/**
 *	returns an image for an unselected section of the uistepper control
 */
- (UIImage *)imageForStepperUnselected
{
	return nil;
}

#pragma mark - Theme Methods: Switch Apperance

/**
 *	returns an image for when the uiswitch is off
 */
- (UIImage *)imageForSwitchOff
{
	return nil;
}

/**
 *	returns an image for when the uiswitch is on
 */
- (UIImage *)imageForSwitchOn
{
	return nil;
}

/**
 *	returns the tint colour for the on side of the switch
 */
- (UIColor *)switchOnTintColour
{
	return nil;
}

/**
 *	returns the tint colour of the 'thumb' (knob) of the switch
 */
- (UIColor *)switchThumbTintColor
{
	return nil;
}

/**
 *	return colour used to tint the appearance when the switch is disabled
 */
- (UIColor *)switchTintColour
{
	return nil;
}

#pragma mark - Theme Methods: Table View Cell Appearance

/**
 *	returns an array of colours for the gradient
 */
- (NSArray *)coloursForGradient
{
	return _coloursForGradient[0];
}

/**
 *	returns the class for the gradient that we want the cell to have
 */
- (Class)gradientLayer
{
	return [GradientLayer class];
}

/**
 *	returns the location of the colours
 */
- (NSArray *)locationsOfColours
{
	return _coloursForGradient[1];
}

/**
 *	returns the number of colours that this gradient will have
 */
- (NSUInteger)numberOfColoursInGradient
{
	return ((NSArray *)_coloursForGradient[0]).count;
}

/**
 *	returns a dictionary of properties for the table view cell
 */
- (NSDictionary *)tableViewCellTextDictionary
{
	return @{	UITextAttributeFont		: [UIFont boldSystemFontOfSize:20.0f]};
}

@end

#pragma mark - Gradient Layer Implementation

@implementation GradientLayer

#pragma mark - Initialisation

/**
 *	called to initialise a class instance
 */
- (id)init
{
	if (self = [super init])
	{
		NSArray *colours				= [ThemeManager sharedTheme].coloursForGradient;
		NSArray *locations				= [ThemeManager sharedTheme].locationsOfColours;
		
		NSAssert(colours.count == locations.count, @"The amount of colours for the gradient does not match the number of locations for those colours.");
		
		NSMutableArray *cgColours		= @[].mutableCopy;
		
		for (NSInteger index = 0; index < [ThemeManager sharedTheme].numberOfColoursInGradient; index++)
			[cgColours addObject:(id)((UIColor *)colours[index]).CGColor];
		
		self.colors						= cgColours;
		self.locations					= locations;
		
		self.startPoint					= CGPointMake(0.5f, 0.0f);
		self.endPoint					= CGPointMake(0.5f, 1.0f);
	}
	
	return self;
}

@end