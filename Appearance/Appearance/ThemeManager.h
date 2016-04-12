//
//  Theme.h
//  Appearance
//
//  Created by James Valaitis on 28/03/2013.
//  Copyright (c) 2013 Adam Burkepile. All rights reserved.
//

#pragma mark - Theme Protocol Definition

@protocol Theme <NSObject>

@optional

#pragma mark - Bar Button Item Appearance

- (NSDictionary *)barButtonTextDictionary;
- (UIImage *)imageForBarButtonDoneHighlightedLandscape;
- (UIImage *)imageForBarButtonDoneHighlightedPortrait;
- (UIImage *)imageForBarButtonDoneNormalLandscape;
- (UIImage *)imageForBarButtonDoneNormalPortrait;
- (UIImage *)imageForBarButtonHighlightedLandscape;
- (UIImage *)imageForBarButtonHighlightedPortrait;
- (UIImage *)imageForBarButtonNormalLandscape;
- (UIImage *)imageForBarButtonNormalPortrait;

#pragma mark - Button Appearance

- (NSDictionary *)buttonTextDictionary;
- (UIImage *)imageForButtonHighlighted;
- (UIImage *)imageForButtonNormal;

#pragma mark - General Appearance

- (UIColor *)backgroundColour;

#pragma mark - Label Appearance

- (NSDictionary *)labelTextDictionary;

#pragma mark - Navigation Bar Appearance

- (UIImage *)imageForNavigationBarLandscape;
- (UIImage *)imageForNavigationBarPortrait;
- (UIImage *)imageForNavigationBarShadow;
- (NSDictionary *)navigationBarTextDictionary;

#pragma mark - Page Control Appearance

- (UIColor *)pageCurrentTintColour;
- (UIColor *)pageTintColour;

#pragma mark - Progress Bar Customisation

- (UIImage *)imageForProgressBar;
- (UIImage *)imageForProgressBarTrack;
- (UIColor *)progressBarTintColour;
- (UIColor *)progressBarTrackTintColour;

#pragma mark - Stepper Appearance

- (UIImage *)imageForStepperDecrement;
- (UIImage *)imageForStepperDividerSelected;
- (UIImage *)imageForStepperDividerUnselected;
- (UIImage *)imageForStepperIncrement;
- (UIImage *)imageForStepperSelected;
- (UIImage *)imageForStepperUnselected;

#pragma mark - Switch Apperance

- (UIImage *)imageForSwitchOff;
- (UIImage *)imageForSwitchOn;
- (UIColor *)switchOnTintColour;
- (UIColor *)switchThumbTintColor;
- (UIColor *)switchTintColour;

#pragma mark - Table View Cell Appearance

- (NSArray *)coloursForGradient;
- (Class)gradientLayer;
- (NSArray *)locationsOfColours;
- (NSUInteger)numberOfColoursInGradient;
- (NSDictionary *)tableViewCellTextDictionary;

@end

#pragma mark - Theme Manager Public Interface

@interface ThemeManager : NSObject

#pragma mark - Class Public Methods

+ (void)applyTheme;
+ (void)customiseBarButtonItem:(UIBarButtonItem *)barButton;
+ (void)customiseButton:(UIButton *)button;
+ (void)customiseNavigationBar:(UINavigationBar *)navigationBar;
+ (void)customisePageControl:(UIPageControl *)pageControl;
+ (void)customiseProgressBar:(UIProgressView *)progressBar;
+ (void)customiseStepper:(UIStepper *)stepper;
+ (void)customiseTableViewCell:(UITableViewCell *)tableViewCell;
+ (void)customiseView:(UIView *)view;
+ (void)setSharedTheme:(id<Theme>)theme;
+ (id<Theme>)sharedTheme;

@end