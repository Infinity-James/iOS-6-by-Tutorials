//
//  MainController.m
//  AttributedText
//
//  Created by James Valaitis on 22/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "MainController.h"

@interface MainController ()
{
	IBOutlet UILabel		*_label;
}

@end

@implementation MainController

#pragma mark - Action & Selector Methods

- (IBAction)changePressed
{
	[self changeTheLabel];
}

#pragma mark - Convenience Methods

- (NSMutableParagraphStyle *)customParagraph
{
	NSMutableParagraphStyle *paragraph	= [[NSMutableParagraphStyle alloc] init];
	paragraph.alignment					= NSTextAlignmentJustified;
	paragraph.firstLineHeadIndent		= 20.0;
	paragraph.paragraphSpacingBefore	= 16.0;
	paragraph.lineSpacing				= 4.0;
	paragraph.hyphenationFactor			= 1.0;
	
	return paragraph;
}

- (NSShadow *)customShadow
{
	NSShadow *myShadow				= [[NSShadow alloc] init];
	myShadow.shadowColor			= [UIColor grayColor];
	myShadow.shadowBlurRadius		= 2.0;
	myShadow.shadowOffset			= CGSizeMake(1.0, 1.0);
	
	return myShadow;
}

#pragma mark - View Alteration Methods

- (void)changeTheLabel
{
	NSDictionary *redAttributes		= @{NSForegroundColorAttributeName	: [UIColor redColor]};
	NSDictionary *greenAttributes	= @{NSForegroundColorAttributeName	: [UIColor greenColor]};
	
	NSMutableAttributedString *text	= [[NSMutableAttributedString alloc] initWithString:@"Red & Green Text."];
	[text setAttributes:redAttributes range:NSMakeRange(0, 3)];
	[text setAttributes:greenAttributes range:NSMakeRange(6, 5)];
	
	_label.attributedText			= text;
}

- (void)initialTextSetting
{
	NSDictionary *attributes		= @{NSForegroundColorAttributeName	: [UIColor colorWithRed:0.2 green:0.239 blue:0.451 alpha:1.0],
										NSParagraphStyleAttributeName	: [self customParagraph],
										NSShadowAttributeName			: [self customShadow]};
	
	NSString *text					= @"(UIFont*) Sets the font to render the text. If you want bold or italic text provide the "
										"correct name for each given font. These vary depending on the font family.\nFor example for "
										"the \"Helvetica Neue\" font you need to provide \"HelveticaNeue-Bold\" name for a bolded font, "
										"and \"HelveticaNeue-Italic\" for italic font.\nHowever, if you would like to use \"Courier New\", "
										"the font names are: \"CourierNewPS- ItalicMT\" for italic and \"CourierNewPS-BoldMT\" for bold.";
	
	NSAttributedString *aString		= [[NSAttributedString alloc] initWithString:text attributes:attributes];
	
	_label.attributedText			= aString;
}

#pragma mark - View Lifecycle

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self initialTextSetting];
}

@end
