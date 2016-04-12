//
//  PrettyInPinkTheme.m
//  Appearance
//
//  Created by James Valaitis on 02/04/2013.
//  Copyright (c) 2013 Adam Burkepile. All rights reserved.
//

#import "PrettyInPinkTheme.h"

@implementation PrettyInPinkTheme

#pragma mark - Initialisation

/**
 *	called to initialise a class instance
 */
- (id)init
{
	if (self = [super init])
	{
		_coloursForGradient				= @[@[	[UIColor colorWithRed:0.961f green:0.878f blue:0.961f alpha:1.000f],
												[UIColor colorWithRed:0.871f green:0.741f blue:0.878f alpha:1.000f],
												[UIColor colorWithRed:0.906f green:0.827f blue:0.906f alpha:1.000f]],
												@[@0.0f, @0.98f, @1.0f]];
	}
	
	return self;
}

#pragma mark - Theme Methods: Bar Button Item Appearance

/**
 *	returns a dictionary for the various properties associated with bar button items
 */
- (NSDictionary *)barButtonTextDictionary
{
	return @{	UITextAttributeFont				: [UIFont fontWithName:@"Optima" size:18.0f],
		   UITextAttributeTextColor		: [UIColor colorWithRed:0.965f green:0.976f blue:0.875f alpha:1.000f],
		   UITextAttributeTextShadowColor	: [UIColor colorWithRed:0.224f green:0.173f blue:0.114f alpha:1.000f],
		   UITextAttributeTextShadowOffset	: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]};
}

/**
 *	returns an image for 'done' bar button items when they are highlighted & landscape
 */
- (UIImage *)imageForBarButtonDoneHighlightedLandscape
{
	return [[UIImage imageNamed:@"barbutton_forest_done_landscape_sel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
}

/**
 *	returns an image for 'done' bar button items when they are highlighted & portrait
 */
- (UIImage *)imageForBarButtonDoneHighlightedPortrait
{
	return [[UIImage imageNamed:@"barbutton_forest_done_sel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
}

/**
 *	returns an image for 'done' bar button items when they are normal & landscape
 */
- (UIImage *)imageForBarButtonDoneNormalLandscape
{
	return [[UIImage imageNamed:@"barbutton_forest_done_landscape_uns.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
}

/**
 *	returns an image for 'done' bar button items when they are normal & portrait
 */
- (UIImage *)imageForBarButtonDoneNormalPortrait
{
	return [[UIImage imageNamed:@"barbutton_forest_done_uns.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
}

/**
 *	returns an image for standard bar button items when they are highlighted & landscape
 */
- (UIImage *)imageForBarButtonHighlightedLandscape
{
	return [[UIImage imageNamed:@"barbutton_forest_landscape_sel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
}

/**
 *	returns an image for standard bar button items when they are highlighted & portrait
 */
- (UIImage *)imageForBarButtonHighlightedPortrait
{
	return [[UIImage imageNamed:@"barbutton_forest_sel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
}

/**
 *	returns an image for standard bar button items when they are normal & landscape
 */
- (UIImage *)imageForBarButtonNormalLandscape
{
	return [[UIImage imageNamed:@"barbutton_forest_landscape_uns.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
}

/**
 *	returns an image for standard bar button items when they are normal & portrait
 */
- (UIImage *)imageForBarButtonNormalPortrait
{
	return [[UIImage imageNamed:@"barbutton_forest_uns.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
}

#pragma mark - Theme Methods: Button Appearance

/**
 *	returns a dictionary of properties for uibuttons
 */
- (NSDictionary *)buttonTextDictionary
{
	return @{	UITextAttributeFont				: [UIFont fontWithName:@"Optima" size:15.0f],
		   UITextAttributeTextColor		: [UIColor colorWithRed:0.965f green:0.976f blue:0.875f alpha:1.000f],
		   UITextAttributeTextShadowColor	: [UIColor colorWithRed:0.212 green:0.263f blue:0.208f alpha:1.000f],
		   UITextAttributeTextShadowOffset	: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, -1.0f)]};
}

/**
 *	returns an image for when a button is highlighted
 */
- (UIImage *)imageForButtonHighlighted
{
	return [[UIImage imageNamed:@"button_forest_sel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)];
}

/**
 *	returns an image for when a button is just standard
 */
- (UIImage *)imageForButtonNormal
{
	return [[UIImage imageNamed:@"button_forest_uns.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)];
}

#pragma mark - Theme Methods: General Appearance

/**
 *	returns the background colour of the views
 */
- (UIColor *)backgroundColour
{
	return [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_prettyinpink.png"]];
}

#pragma mark - Theme Methods: Label Appearance

/**
 *	returns a dictionary of properties for uilabels
 */
- (NSDictionary *)labelTextDictionary
{
	return @{	UITextAttributeFont				: [UIFont fontWithName:@"Optima" size:18.0f],
		   UITextAttributeTextColor		: [UIColor colorWithRed:0.965f green:0.976f blue:0.875f alpha:1.000f],
		   UITextAttributeTextShadowColor	: [UIColor colorWithRed:0.212f green:0.263f blue:0.208f alpha:1.000f],
		   UITextAttributeTextShadowOffset	: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]};
}

#pragma mark - Theme Methods: Navigation Bar Appearance

/**
 *	returns the image for the navigation bar when it is landscape
 */
- (UIImage *)imageForNavigationBarLandscape
{
	return [[UIImage imageNamed:@"nav_forest_landscape.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 100.0f, 0.0f, 100.0f)];
}

/**
 *	returns the image for the navigation bar when it is portrait
 */
- (UIImage *)imageForNavigationBarPortrait
{
	return [[UIImage imageNamed:@"nav_forest_portrait.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 100.0f, 0.0f, 100.0f)];
}

/**
 *	returns an image for the shadow of the navigation bar
 */
- (UIImage *)imageForNavigationBarShadow
{
	return [UIImage imageNamed:@"topShadow_forest.png"];
}

/**
 *	returns a dictionary for the navigation bar text font, colour etc.
 */
- (NSDictionary *)navigationBarTextDictionary
{
	return @{	UITextAttributeFont				: [UIFont fontWithName:@"Optima" size:24.0f],
		   UITextAttributeTextColor		: [UIColor colorWithRed:0.910f green:0.914f blue:0.824f alpha:1.000f],
		   UITextAttributeTextShadowColor	: [UIColor colorWithRed:0.224f green:0.173f blue:0.114f alpha:1.000f],
		   UITextAttributeTextShadowOffset	: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)]};
}

#pragma mark - Theme Methods: Page Appearance

/**
 *	tint color for the current page item
 */
- (UIColor *)pageCurrentTintColour
{
	return [UIColor colorWithRed:0.973f green:0.984f blue:0.875f alpha:1.000f];
}

/**
 *	tint color for the page items
 */
- (UIColor *)pageTintColour
{
	return [UIColor colorWithRed:0.063f green:0.169f blue:0.071f alpha:1.000f];
}

#pragma mark - Theme Methods: Progress Bar Customisation

/**
 *	returns the colour to tint the portion of the progress bar that is filled
 */
- (UIColor *)progressBarTintColour
{
	return [UIColor colorWithRed:0.600f green:0.416f blue:0.612f alpha:1.000f];
}

/**
 *	returns the colour shown for the portion of the progress bar that is not filled
 */
- (UIColor *)progressBarTrackTintColour
{
	return [UIColor colorWithRed:0.749f green:0.561f blue:0.757f alpha:1.000f];
}

#pragma mark - Theme Methods: Stepper Appearance

/**
 *	returns an image for the decrement icon on the uistepper control
 */
- (UIImage *)imageForStepperDecrement
{
	return [UIImage imageNamed:@"stepper_forest_decrement.png"];
}

/**
 *	returns an image for the increment icon on the uistepper control
 */
- (UIImage *)imageForStepperDividerSelected
{
	return [UIImage imageNamed:@"stepper_forest_divider_sel.png"];
}

/**
 *	returns an image for the divider of the unselected uistepper control
 */
- (UIImage *)imageForStepperDividerUnselected
{
	return [UIImage imageNamed:@"stepper_forest_divider_uns.png"];
}

/**
 *	returns an image for the divider of the selected uistepper control
 */
- (UIImage *)imageForStepperIncrement
{
	return [UIImage imageNamed:@"stepper_forest_increment.png"];
}

/**
 *	returns an image for a selected section of the uistepper control
 */
- (UIImage *)imageForStepperSelected
{
	return [UIImage imageNamed:@"stepper_forest_bg_sel.png"];
}

/**
 *	returns an image for an unselected section of the uistepper control
 */
- (UIImage *)imageForStepperUnselected
{
	return [UIImage imageNamed:@"stepper_forest_bg_uns.png"];
}

#pragma mark - Theme Methods: Switch Apperance

/**
 *	returns an image for when the uiswitch is off
 */
- (UIImage *)imageForSwitchOff
{
	return [UIImage imageNamed:@"tree_off.png"];
}

/**
 *	returns an image for when the uiswitch is on
 */
- (UIImage *)imageForSwitchOn
{
	return [UIImage imageNamed:@"tree_on.png"];
}

/**
 *	returns the tint colour for the on side of the switch
 */
- (UIColor *)switchOnTintColour
{
	return [UIColor colorWithRed:0.749f green:0.561f blue:0.757f alpha:1.000f];
}

/**
 *	returns the tint colour of the 'thumb' (knob) of the switch
 */
- (UIColor *)switchThumbTintColor
{
	return [UIColor colorWithRed:0.918f green:0.839f blue:0.922f alpha:1.000f];
}

/**
 *	return colour used to tint the appearance when the switch is disabled
 */
- (UIColor *)switchTintColour
{
	return [UIColor colorWithRed:0.992f green:0.804f blue:1.000f alpha:1.000f];
}

#pragma mark - Theme Methods: Table View Cell Appearance

/**
 *	returns a dictionary of properties for the table view cell
 */
- (NSDictionary *)tableViewCellTextDictionary
{
	return @{	UITextAttributeFont				: [UIFont fontWithName:@"Optima" size:24.0f],
		   UITextAttributeTextColor		: [UIColor colorWithRed:0.169f green:0.169f blue:0.153f alpha:1.000f],
		   UITextAttributeTextShadowColor	: [UIColor colorWithWhite:1.0f alpha:1.0f],
		   UITextAttributeTextShadowOffset	: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]};
}

@end
