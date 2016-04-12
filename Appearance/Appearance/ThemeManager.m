//
//  Theme.m
//  Appearance
//
//  Created by James Valaitis on 28/03/2013.
//  Copyright (c) 2013 Adam Burkepile. All rights reserved.
//

#import "ThemeManager.h"

#pragma mark - Theme Manager Implementation

@implementation ThemeManager {}

#pragma mark - Static Variables
	
static id<Theme> _theme					= nil;

#pragma mark - Setter & Getter Methods

/**
 *	accepts a theme and applies it
 *
 *	@param	theme						theme to apply
 */
+ (void)setSharedTheme:(id<Theme>)theme
{
	_theme								= theme;
	[self applyTheme];
}

#pragma mark - Singleton Methods

/**
 *	returns the theme
 */
+ (id<Theme>)sharedTheme
{
	return _theme;
}

#pragma mark - Theme General Customisation Methods

/**
 *	applies the theme
 */
+ (void)applyTheme
{	
	//	use the navigation bar appearance proxy to change all of the navigation bars and then post the notification
	[self customiseNavigationBar:[UINavigationBar appearance]];
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kThemeChanged object:nil]];
	
	//	use the bar button item appearance proxy to customise all bar button items
	[self customiseBarButtonItem:[UIBarButtonItem appearance]];
	
	//	use the page control proxy to customise all page controls
	[self customisePageControl:[UIPageControl appearance]];
	
	//	use the uistepper proxy to customise all uisteppers
	[self customiseStepper:[UIStepper appearance]];
	
	//	use uiswitch proxy to customise all switches
	[self customiseSwitch:[UISwitch appearance]];
	
	//	use progress view proxy to customise them all
	[self customiseProgressBar:[UIProgressView appearance]];
	
	//	use uilabel proxy to customise all of them
	[self customiseLabel:[UILabel appearance]];
	
	//	use uibutton to customise all buttons
	//	[self customiseButton:[UIButton appearance]];
	//	this should not be done because stuff goes crazy
}

#pragma mark - Theme Specific Customisation Methods

/**
 *	customises a specific bar button item
 *
 *	@param	barButton					the bar button item to customise
 */
+ (void)customiseBarButtonItem:(UIBarButtonItem *)barButton
{
	//	get the chosen theme
	id<Theme> theme						= self.sharedTheme;
	
	//	customise the normal bar button item
	[barButton setBackgroundImage:[theme imageForBarButtonNormalPortrait] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[barButton setBackgroundImage:[theme imageForBarButtonNormalLandscape] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
	[barButton setBackgroundImage:[theme imageForBarButtonHighlightedPortrait] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
	[barButton setBackgroundImage:[theme imageForBarButtonHighlightedLandscape] forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
	
	//	customise the 'done' bar button item
	[barButton setBackgroundImage:[theme imageForBarButtonDoneNormalPortrait]
						 forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
	[barButton setBackgroundImage:[theme imageForBarButtonDoneNormalLandscape]
						 forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsLandscapePhone];
	[barButton setBackgroundImage:[theme imageForBarButtonDoneHighlightedPortrait]
						 forState:UIControlStateHighlighted style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
	[barButton setBackgroundImage:[theme imageForBarButtonDoneHighlightedLandscape]
						 forState:UIControlStateHighlighted style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsLandscapePhone];
	
	//	set the title text attributes for the bar button item
	[barButton setTitleTextAttributes:[theme barButtonTextDictionary] forState:UIControlStateNormal];
}

/**
 *	customises a uibutton with the set theme
 *
 *	@param	button						the uibutton to customise
 */
+ (void)customiseButton:(UIButton *)button
{
	//	get the chosen theme
	id<Theme> theme						= self.sharedTheme;
	
	//	customise the button properties
	button.titleLabel.font				= [theme buttonTextDictionary][UITextAttributeFont];
	[button setTitleColor:[theme buttonTextDictionary][UITextAttributeTextColor] forState:UIControlStateNormal];
	//button.titleLabel.textColor			= [theme buttonTextDictionary][UITextAttributeTextColor];
	//button.titleLabel.shadowColor		= [theme buttonTextDictionary][UITextAttributeTextShadowColor];
	[button setTitleShadowColor:[theme buttonTextDictionary][UITextAttributeTextShadowColor] forState:UIControlStateNormal];
	button.titleLabel.shadowOffset		= ((NSValue *)[theme buttonTextDictionary][UITextAttributeTextShadowOffset]).CGSizeValue;
	
	//	set the background images for the button
	[button setBackgroundImage:[theme imageForButtonNormal] forState:UIControlStateNormal];
	[button setBackgroundImage:[theme imageForButtonHighlighted] forState:UIControlStateHighlighted];
}

/**
 *	customises a specific uilabel
 *
 *	@param	label					the label to customise
 */
+ (void)customiseLabel:(UILabel *)label
{
	//	get the chosen theme
	id<Theme> theme						= self.sharedTheme;
	
	//	customise the uilabel
	label.font							= [theme labelTextDictionary][UITextAttributeFont];
	label.textColor						= [theme labelTextDictionary][UITextAttributeTextColor];
	label.shadowColor					= [theme labelTextDictionary][UITextAttributeTextShadowColor];
	label.shadowOffset					= ((NSValue *)[theme labelTextDictionary][UITextAttributeTextShadowOffset]).CGSizeValue;
}

/**
 *	customises a specific navigation bar
 *
 *	@param	navigationBar				the navigation bar to customise
 */
+ (void)customiseNavigationBar:(UINavigationBar *)navigationBar
{
	//	get the chosen theme
	id<Theme> theme						= self.sharedTheme;
	
	//	customise the navigation bar
	[navigationBar setBackgroundImage:[theme imageForNavigationBarPortrait] forBarMetrics:UIBarMetricsDefault];
	[navigationBar setBackgroundImage:[theme imageForNavigationBarLandscape] forBarMetrics:UIBarMetricsLandscapePhone];
	[navigationBar setShadowImage:[theme imageForNavigationBarShadow]];
	[navigationBar setTitleTextAttributes:[theme navigationBarTextDictionary]];
}

/**
 *	customises a uipagecontrol
 *
 *	@param	pageControl					the page control to customise
 */
+ (void)customisePageControl:(UIPageControl *)pageControl
{
	//	get the chosen theme
	id<Theme> theme						= self.sharedTheme;
	
	//	customise the look of the page control
	[pageControl setCurrentPageIndicatorTintColor:[theme pageCurrentTintColour]];
	[pageControl setPageIndicatorTintColor:[theme pageTintColour]];
}

/**
 *	customises a progress view
 *
 *	@param	progressBar					the progress bar to customise
 */
+ (void)customiseProgressBar:(UIProgressView *)progressBar
{
	//	get the chosen theme
	id<Theme> theme						= self.sharedTheme;
	
	//	customise the tint colours of the progress bar
	[progressBar setProgressTintColor:[theme progressBarTintColour]];
	[progressBar setTrackTintColor:[theme progressBarTrackTintColour]];
	
	//	use images for the progress bar
	[progressBar setProgressImage:[theme imageForProgressBar]];
	[progressBar setTrackImage:[theme imageForProgressBarTrack]];
}

/**
 *	customises a uistepper
 *
 *	@param	stepper						the uistepper to customise
 */
+ (void)customiseStepper:(UIStepper *)stepper
{
	//	get the chosen theme
	id<Theme> theme						= self.sharedTheme;
	
	//	customise the actual stepper buttons
	[stepper setBackgroundImage:[theme imageForStepperUnselected] forState:UIControlStateNormal];
	[stepper setBackgroundImage:[theme imageForStepperSelected] forState:UIControlStateHighlighted];
	
	//	customise the dividers of the stepper
	[stepper setDividerImage:[theme imageForStepperDividerUnselected] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal];
	[stepper setDividerImage:[theme imageForStepperDividerSelected] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected];
	[stepper setDividerImage:[theme imageForStepperDividerSelected] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal];
	[stepper setDividerImage:[theme imageForStepperDividerSelected] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected];
	
	//	customise the increment and decrement icons
	[stepper setDecrementImage:[theme imageForStepperDecrement] forState:UIControlStateNormal];
	[stepper setIncrementImage:[theme imageForStepperIncrement] forState:UIControlStateNormal];
}

/**
 *	customises a uiswitch
 *
 *	@param	switchControl				the uiswitch to customise
 */
+ (void)customiseSwitch:(UISwitch *)switchControl
{
	//	get the chosen theme
	id<Theme> theme						= self.sharedTheme;
	
	//	customise the tint colour of the switch
	[switchControl setTintColor:[theme switchTintColour]];
	[switchControl setThumbTintColor:[theme switchThumbTintColor]];
	[switchControl setOnTintColor:[theme switchOnTintColour]];
	[switchControl setOnImage:[theme imageForSwitchOn]];
	[switchControl setOffImage:[theme imageForSwitchOff]];
}

/**
 *	customises a uiswitch
 *
 *	@param	switchControl				the uiswitch to customise
 */
+ (void)customiseTableViewCell:(UITableViewCell *)tableViewCell
{
	//	get the chosen theme
	id<Theme> theme						= self.sharedTheme;
	
	//	customise the table view cell's text properties
	tableViewCell.textLabel.font		= theme.tableViewCellTextDictionary[UITextAttributeFont];
	tableViewCell.textLabel.textColor	= theme.tableViewCellTextDictionary[UITextAttributeTextColor];
	//[tableViewCell.textLabel setTextColor:theme.tableViewCellTextDictionary[UITextAttributeTextColor]];
	tableViewCell.textLabel.shadowColor	= theme.tableViewCellTextDictionary[UITextAttributeTextShadowColor];
	tableViewCell.textLabel.shadowOffset= ((NSValue *)theme.tableViewCellTextDictionary[UITextAttributeTextShadowOffset]).CGSizeValue;
}

/**
 *	customise a specific view
 *
 *	@param	view						the view to customise
 */
+ (void)customiseView:(UIView *)view
{
	//	get the chosen theme
	id<Theme> theme						= self.sharedTheme;
	
	//	set the view's background colour
	UIColor *backgroundColour			= [theme backgroundColour];
	[view setBackgroundColor:backgroundColour];
}

@end