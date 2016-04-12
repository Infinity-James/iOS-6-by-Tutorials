//
//  NoteController.m
//  RichEditor
//
//  Created by James Valaitis on 22/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "ColourController.h"
#import "FontsController.h"
#import "NoteController.h"
#import "NSObject+AutoCoding.h"

@interface NoteController () <ColourControllerDelegate, FontsControllerDelegate, UITextViewDelegate>
{
	IBOutlet UITextView		*_editor;
	IBOutlet UIView			*_toolbar;
	
	CGSize					_screen;
}

@end

@implementation NoteController

#pragma mark - Action & Selector Methods

- (IBAction)backgroundTapped
{
	NSRange selection					= _editor.selectedRange;
	
	if (![self isTextHighlighted:selection withError:YES])	return;
	
	UIColor *backgroundColour			= [_editor.attributedText attribute:NSBackgroundColorAttributeName
																	atIndex:selection.location
															 effectiveRange:nil];
	
	UIColor *newColour;
	
	if (!CGColorGetAlpha(backgroundColour.CGColor))
		newColour						= [UIColor yellowColor];
	else
		newColour						= [UIColor clearColor];
	
	NSDictionary *backgroundStyle		= @{NSBackgroundColorAttributeName : newColour};

	[self applyAttributesToTextArea:backgroundStyle];
}

- (IBAction)colourTapped
{
	ColourController *colourController	= [[ColourController alloc] initWithNibName:@"ColourView" bundle:nil];
	colourController.delegate			= self;
	[self.navigationController pushViewController:colourController animated:YES];
}

- (IBAction)fontTapped
{
	FontsController *fontsController	= [[FontsController alloc] initWithNibName:@"FontsView" bundle:nil];
	fontsController.delegate			= self;
	fontsController.preselectedFont		= _editor.typingAttributes[NSFontAttributeName];

	[self.navigationController pushViewController:fontsController animated:YES];
}

- (IBAction)shadowTapped
{
	NSRange selection					= _editor.selectedRange;
	
	if ([self isTextHighlighted:selection withError:NO])
	{
		NSMutableAttributedString *aString	= [[NSMutableAttributedString alloc] initWithAttributedString:_editor.attributedText];
		
		[_editor.attributedText enumerateAttributesInRange:selection
												   options:kNilOptions
												usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop)
		{
			NSShadow *currentShadow			= attributes[NSShadowAttributeName];
			
			[aString addAttribute:NSShadowAttributeName value:[self newShadowWithCurrentShadow:currentShadow] range:range];
		}];
		
		_editor.attributedText				= aString;
		_editor.selectedRange				= selection;
	}
	
	else
	{
		NSMutableDictionary *pendingAttributes	= _editor.typingAttributes.mutableCopy;
		
		NSShadow *currentShadow				= pendingAttributes[NSShadowAttributeName];
		
		[pendingAttributes setObject:[self newShadowWithCurrentShadow:currentShadow] forKey:NSShadowAttributeName];
		
		_editor.typingAttributes			= pendingAttributes;
	}
}

- (IBAction)saveTapped
{
	[_editor.attributedText writeToFile:self.fileName atomically:YES];
	
	[[[UIAlertView alloc] initWithTitle:@"Success"
								message:@"Your note has been saved."
							   delegate:nil
					  cancelButtonTitle:@"Close"
					  otherButtonTitles:nil] show];
}

#pragma mark - ColourControllerDelegate Methods

- (void)selectedColour:(UIColor *)colour
{
	NSDictionary *attribute				= @{NSForegroundColorAttributeName : colour};
	
	[self applyAttributesToTextArea:attribute];
}

#pragma mark - Convenience Methods

- (void)addButtons
{
	UIBarButtonItem *saveButton			= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																				 target:self
																				 action:@selector(saveTapped)];
	
	[self.navigationItem setRightBarButtonItem:saveButton];
}

- (void)applyAttributesToTextArea:(NSDictionary *)attributes
{
	NSRange selection					= _editor.selectedRange;
	NSMutableAttributedString *aString	= [[NSMutableAttributedString alloc] initWithAttributedString:_editor.attributedText];
	[aString addAttributes:attributes range:selection];
	_editor.attributedText				= aString;
	_editor.selectedRange				= selection;
}

- (BOOL)isTextHighlighted:(NSRange)selection withError:(BOOL)presentError
{
	if (selection.length)	return YES;
	
	if (presentError)
		[[[UIAlertView alloc] initWithTitle:@"Nope"
									message:@"Select text to highlight first."
								   delegate:nil
						  cancelButtonTitle:@"Close"
						  otherButtonTitles:nil] show];
	
	return NO;
}

- (NSShadow *)newShadowWithCurrentShadow:(NSShadow *)currentShadow
{
	NSShadow *newShadow				= [[NSShadow alloc] init];
	
	if (!currentShadow || !currentShadow.shadowBlurRadius)
		newShadow.shadowColor		= [UIColor redColor], newShadow.shadowBlurRadius	= 6.0;
	else
		newShadow.shadowColor		= [UIColor clearColor], newShadow.shadowBlurRadius	= 0.0;
	
	return newShadow;
}

#pragma mark - FontsControllerDelegate Methods

- (void)selectedFontName:(NSString *)fontName
				withSize:(NSNumber *)fontSize
{
	NSDictionary *fontStyle			= @{NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize.floatValue]};
	
	[self applyAttributesToTextArea:fontStyle];
}

#pragma mark - UITextViewDelegate Methods

/**
 *	asks the delegate if editing should begin in the specified text view
 *
 *	@param	textView				text view for which editing is about to begin
 */
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	[UIView animateWithDuration:0.4 animations:
	^{
		_toolbar.center			= CGPointMake(_screen.width / 2, _screen.height - 300);
	}];
	
	return YES;
}

/**
 *	asks the delegate if editing should end in the specified text view
 *
 *	@param	textView				text view for which editing is about to end
 */
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	[UIView animateWithDuration:0.4 animations:
	^{
		 _toolbar.center			= CGPointMake(_screen.width / 2, _screen.height - _toolbar.bounds.size.height / 2);
	}];
	
	return YES;
}

#pragma mark - View Lifecycle

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title						= [self.fileName.lastPathComponent stringByDeletingPathExtension];
	
	[self addButtons];
	
	_screen							= [UIScreen mainScreen].bounds.size;
	_toolbar.center					= CGPointMake(_screen.width / 2, _screen.height - (_toolbar.bounds.size.height / 2));
	
	[_editor setDelegate:self];
	[_editor setAllowsEditingTextAttributes:YES];
	[_editor becomeFirstResponder];
	
	@try
	{
		_editor.attributedText		= [NSAttributedString objectWithContentsOfFile:self.fileName];
	}
	@catch (NSException *exception)
	{
		_editor.attributedText		= [[NSAttributedString alloc] initWithString:@""];
	}
}

@end










































































