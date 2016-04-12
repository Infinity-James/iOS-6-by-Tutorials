//
//  FunActivity.m
//  FunFacts
//
//  Created by James Valaitis on 07/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "FunActivity.h"

@interface FunActivity ()

@property (nonatomic, strong)	UIImage		*authorImage;
@property (nonatomic, strong)	NSString	*funFactText;

@end

@implementation FunActivity

#pragma mark - UIActivity Methods

/**
 *	returns an image identifying the service to the user
 */
- (UIImage *)activityImage
{
	return [UIImage imageNamed:@"activity.png"];
}

/**
 *	a user readable string describing the service
 */
- (NSString *)activityTitle
{
	return @"Save Quote to Photos";
}

/**
 *	an identifier for the type of service being provided
 */
- (NSString *)activityType
{
	return @"com.andbeyond.jamesvalaitis.FunFacts.quoteView";
}

/**
 *	returns whether the service can act on the specified data items
 *
 *	@param	activityItems		array of specific objects on which we are being asked if we can act on
 */
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
	for (id item in activityItems)
	{
		//	if the items are images and strings that's fine
		if ([item class] == [UIImage class] || [item isKindOfClass:[NSString class]])	continue;
		
		//	if the items are something else, we return no
		else
			return NO;
	}
	
	//	we can do all of the items
	return YES;
}

/**
 *	the user has selected this service and we must now execute activity using items previously received
 */
- (void)performActivity
{
	//	get the size of the device
	CGSize quoteSize				= [UIScreen mainScreen].bounds.size;
	
	//	start the image context
	UIGraphicsBeginImageContext(quoteSize);
	
	//	use the size of the device to create a black view covering the context
	UIView *quoteView				= [[UIView alloc] initWithFrame:CGRectMake(0, 0, quoteSize.width, quoteSize.height)];
	quoteView.backgroundColor		= [UIColor blackColor];
	
	//	add the author image view to the main view in the context
	UIImageView *imageView			= [[UIImageView alloc] initWithImage:self.authorImage];
	imageView.frame					= CGRectMake(20, 20, quoteSize.width - 40, quoteSize.height / 3);
	imageView.backgroundColor		= [UIColor clearColor];
	imageView.contentMode			= UIViewContentModeScaleAspectFit;
	
	[quoteView addSubview:imageView];
	
	//	add the fact text to main view in the context
	UILabel *factLabel				= [[UILabel alloc] initWithFrame:CGRectMake(20, (quoteSize.height / 3) + 40,
																				quoteSize.width - 40, ((quoteSize.height / 3) * 2) - 40)];
	factLabel.backgroundColor		= [UIColor clearColor];
	factLabel.numberOfLines			= 10;
	factLabel.font					= [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
	factLabel.textColor				= [UIColor whiteColor];
	factLabel.text					= self.funFactText;
	factLabel.textAlignment			= NSTextAlignmentCenter;
	
	[quoteView addSubview:factLabel];
	
	//	render the image to the context
	[quoteView.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	//	get the image and end the context
	UIImage *imageToSave			= UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	//	save the image to the user's photo album
	UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil);
	
	//	confirm we have finished out activity
	[self activityDidFinish:YES];
}

/**
 *	prepares this service to act on the specified data
 *
 *	@param	activityItems		array of specific objects on which we muct now act on
 */
 - (void)prepareWithActivityItems:(NSArray *)activityItems
{
	for (id item in activityItems)
	{
		if ([item class] == [UIImage class])
			self.authorImage		= item;
		else if ([item isKindOfClass:[NSString class]])
			self.funFactText		= item;
	}
}

@end







































