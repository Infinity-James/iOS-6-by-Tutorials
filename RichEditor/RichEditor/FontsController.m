//
//  FontsController.m
//  RichEditor
//
//  Created by James Valaitis on 22/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "FontsController.h"

@interface FontsController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
	IBOutlet UIButton		*_applyButton;
	CGFloat					_delta;
	IBOutlet UIPickerView	*_fontPicker;
	NSArray					*_fontsDataSource;
	NSShadow				*_shadow;
	NSTimer					*_timer;
}

@end

@implementation FontsController

#pragma mark - Action & Selector Methods

- (IBAction)doneTapped
{
	NSInteger selectedFontSizeIndex	= [_fontPicker selectedRowInComponent:0];
	NSInteger selectedFontNameIndex	= [_fontPicker selectedRowInComponent:1];
	
	NSNumber *fontSize				= ((NSArray *)_fontsDataSource[0])[selectedFontSizeIndex];
	NSString *fontName				= ((NSArray *)_fontsDataSource[1])[selectedFontNameIndex];
	
	[self.delegate selectedFontName:fontName withSize:fontSize];
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)glow:(NSTimer *)timer
{
	_shadow.shadowBlurRadius		+= _delta;
	
	if (_shadow.shadowBlurRadius > 6)	_delta	= -0.2;
	if (_shadow.shadowBlurRadius < 0)	_delta	= 0.2;
	
	dispatch_async(dispatch_get_main_queue(),
	^{
		NSAttributedString *title	= [[NSAttributedString alloc] initWithString:@" Apply " attributes:@{NSShadowAttributeName : _shadow}];
		
		[_applyButton setAttributedTitle:title forState:UIControlStateNormal];
	});
}

#pragma mark - UIPickerViewDataSource Methods

/**
 *	called by the picker view when it needs the number of components
 *
 *	@param	pickerView				picker view requesting the data
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return _fontsDataSource.count;
}

/**
 *	called by the picker view when it needs the number of rows for a specified component
 *
 *	@param	pickerView				picker view requesting the data
 *	@param	component				zero-indexed number identifying a component of pickerview
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
	return ((NSArray *)_fontsDataSource[component]).count;
}

#pragma mark - UIPickerViewDelegate Methods

/**
 *	called when the picker needs the styled title to use for a given row in a given component
 *
 *	@param	pickerView				picker view requesting the data
 *	@param	row						zero-indexed number identifying a row of component
 *	@param	component				zero-indexed number identifying a component of pickerview
 */
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
			 attributedTitleForRow:(NSInteger)row
					  forComponent:(NSInteger)component
{
	id data							= ((NSArray *)_fontsDataSource[component])[row];
	
	NSMutableAttributedString *title= [[NSMutableAttributedString alloc] initWithString:[data description]];
	
	NSDictionary *attributes;
	
	if (component == 0)
	{
		float pointSize				= [(NSNumber *)data floatValue];
		attributes					= @{NSFontAttributeName : [UIFont fontWithName:@"Arial" size:pointSize]};
	}
	
	else if (component == 1)
		attributes					= @{NSFontAttributeName : [UIFont fontWithName:data size:16.0]};
	
	[title setAttributes:attributes range:NSMakeRange(0, title.length)];
	
	return title;
}

#pragma mark - View Lifecycle

/**
 *	notifies the view controller that its view was added to a view hierarchy
 */
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	NSArray *fontSizes				= _fontsDataSource[0];
	NSArray *fontNames				= _fontsDataSource[1];
	
	for (int i = 0; i < fontSizes.count; i++)
	{
		NSNumber *size				= fontSizes[i];
		if (size.floatValue == self.preselectedFont.pointSize)
		{
			[_fontPicker selectRow:i inComponent:0 animated:YES];
			break;
		}
	}
	
	for (int i = 0; i < fontNames.count; i++)
	{
		NSString *name				= fontNames[i];
		if ([name compare:self.preselectedFont.fontName] == NSOrderedSame)
		{
			[_fontPicker selectRow:i inComponent:1 animated:YES];
			break;
		}
	}
	
	//	sets up initial shadow as a green glow
	_shadow							= [[NSShadow alloc] init];
	_shadow.shadowColor				= [UIColor colorWithRed:0.0 green:0.42 blue:0.039 alpha:1.0];
	_shadow.shadowBlurRadius		= 0.0;
	
	//	initialise timer for updating ui
	_delta							= 0.2;
	_timer							= [NSTimer scheduledTimerWithTimeInterval:0.01
																	   target:self
																	 selector:@selector(glow:)
																	 userInfo:nil
																	  repeats:YES];
}

/**
 *	notifies the view controller that its view was removed from a view hierarchy
 */
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[_timer invalidate];
	_timer							= nil;
}

/**
 *	notifies the view controller that its view is about to be added to a view hierarchy
 *
 *	@param	animated					whether the view needs to be added to the window with an animation
 */
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	_fontsDataSource				= @[@[@12, @14, @18, @24],
										@[@"Arial", @"AmericanTypewriter", @"Comfortaa", @"Helvetica", @"Zapfino"]];
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[_fontPicker setDataSource:self];
	[_fontPicker setDelegate:self];
	
	self.title				= @"Font Picker";
}

@end









































































