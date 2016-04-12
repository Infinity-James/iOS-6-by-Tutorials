//
//  SocialController.m
//  FunFacts
//
//  Created by James Valaitis on 04/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "FunActivity.h"
#import "SocialController.h"

#define AuthorFactsKey		@"facts"
#define AuthorImageKey		@"image"
#define AuthorNameKey		@"name"
#define AuthorTwitterKey	@"twitter"

typedef enum	SocialButtonTags
{
	SocialButtonTagFacebook,
	SocialButtonTagSinaWeibo,
	SocialButtonTagTwitter
}				SocialButtonTags;

@interface SocialController () {}

@property (nonatomic, weak)	IBOutlet	UIButton	*actionButton;
@property (nonatomic, weak)	IBOutlet	UIView		*authorBackgroundView;
@property (nonatomic, weak)	IBOutlet	UIImageView	*authorImageView;
@property (nonatomic, strong)			NSArray		*authorsArray;
@property (nonatomic, assign)			BOOL		deviceWasShaken;
@property (nonatomic, weak)	IBOutlet	UIButton	*facebookButton;
@property (nonatomic, weak)	IBOutlet	UITextView	*factTextView;
@property (nonatomic, weak)	IBOutlet	UILabel		*factTitleLabel;
@property (nonatomic, weak)	IBOutlet	UILabel		*nameLabel;
@property (nonatomic, weak)	IBOutlet	UIButton	*twitterButton;
@property (nonatomic, weak)	IBOutlet	UILabel		*twitterLabel;
@property (nonatomic, weak)	IBOutlet	UIButton	*weiboButton;

@end

@implementation SocialController {}

#pragma mark - Accessibility Methods

/**
 *	performs a salient action
 */
- (BOOL)accessibilityPerformMagicTap
{
	[self generateRandomFact];
	
	return YES;
}

#pragma mark - Action & Selector Methods

- (IBAction)actionTapped
{
	if (self.deviceWasShaken)
	{
		FunActivity *funActivity						= [[FunActivity alloc] init];
		
		NSString *initialTextString						= [NSString stringWithFormat:@"Fun Fact: %@", self.factTextView.text];
		UIActivityViewController *activityController	= [[UIActivityViewController alloc]
														   initWithActivityItems:@[initialTextString, self.authorImageView.image]
														   applicationActivities:@[funActivity]];
		
		[self presentViewController:activityController animated:YES completion:nil];
	}
	
	else
	{
		[[[UIAlertView alloc] initWithTitle:@"Shake The Device"
									message:@"Before you can share you must shake the device to get a random fact."
								   delegate:nil
						  cancelButtonTitle:@"Dismiss"
						  otherButtonTitles:nil] show];
	}
}

- (IBAction)socialTapped:(UIButton *)sender
{
	if (self.deviceWasShaken)
	{
		//	create a variable to track th service type
		NSString *serviceType			= @"";
		
		//	check the tag of the button to find out which service is being used
		switch (sender.tag)
		{
			case SocialButtonTagFacebook:	serviceType	= SLServiceTypeFacebook;	break;
			case SocialButtonTagSinaWeibo:	serviceType	= SLServiceTypeSinaWeibo;	break;
			case SocialButtonTagTwitter:	serviceType	= SLServiceTypeTwitter;		break;
			default:																break;
		}
		
		//	if the requested service is not available on thsi device we display an alert
		if (![SLComposeViewController isAvailableForServiceType:serviceType])
			[self showUnavailableAlertForServiceType:serviceType];
		
		//	otherwise we display the service view controller with the author image and fact
		else
		{
			SLComposeViewController *composeController	= [SLComposeViewController composeViewControllerForServiceType:serviceType];
			[composeController addImage:self.authorImageView.image];
			NSString *initialTextString					= [NSString stringWithFormat:@"Fun Fact: %@", self.factTextView.text];
			[composeController setInitialText:initialTextString];
			[self presentViewController:composeController animated:YES completion:nil];
		}
	}
	
	else
	{
		[[[UIAlertView alloc] initWithTitle:@"Shake The Device"
									message:@"Before you can share you must shake the device to get a random fact."
								   delegate:nil
						  cancelButtonTitle:@"Dismiss"
						  otherButtonTitles:nil] show];
	}
}

#pragma mark - Convenience & Helper Methods

/**
 *
 */
- (void)generateRandomFact
{
	//	use the size of our authors array to get a random index within that array
	NSUInteger authorRandomSize		= self.authorsArray.count;
	NSUInteger authorRandomIndex	= (arc4random() % ((unsigned)authorRandomSize));
	
	//	use the random index to get a random author dictionary from the array
	NSDictionary *authorDictionary	= self.authorsArray[authorRandomIndex];
	
	//	get the properties of the author dictionary
	NSArray *facts					= authorDictionary[AuthorFactsKey];
	NSString *image					= authorDictionary[AuthorImageKey];
	NSString *name					= authorDictionary[AuthorNameKey];
	NSString *twitter				= authorDictionary[AuthorTwitterKey];
	
	//	from the facts array belonging to this author, get a random index for any fact
	NSUInteger factsRandomSize		= facts.count;
	NSUInteger factsRandomIndex		= (arc4random() % (unsigned)factsRandomSize);
	
	//	set the appropriate ui properties with our new randomly selected information
	self.authorImageView.image		= [UIImage imageNamed:image];
	self.factTitleLabel.hidden		= NO;
	self.factTextView.text			= facts[factsRandomIndex];
	self.nameLabel.text				= name;
	self.twitterLabel.text			= twitter;
	
	//	set the accessibility of these views
	self.authorImageView.isAccessibilityElement	= YES;
	self.factTitleLabel.isAccessibilityElement	= YES;
	self.nameLabel.isAccessibilityElement		= YES;
	self.twitterLabel.isAccessibilityElement	= YES;
	
	self.authorImageView.accessibilityLabel		= name;
	self.factTitleLabel.accessibilityLabel		= [NSString stringWithFormat:@"%@: %@", self.factTitleLabel.text, name];
	self.nameLabel.accessibilityLabel			= [NSString stringWithFormat:@"Author Name: %@", name];
	self.twitterLabel.accessibilityLabel		= [NSString stringWithFormat:@"Twitter Username: %@", twitter];
	
	
	//	notify the accebility manager that the layout of the ui has changed
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.factTextView);
}

- (void)showUnavailableAlertForServiceType:(NSString *)serviceType
{
	NSString *serviceName		= @"";
	
	if (serviceType == SLServiceTypeFacebook)
		serviceName				= @"Facebook";
	else if (serviceType == SLServiceTypeSinaWeibo)
		serviceName				= @"Sina Weibo";
	else if (serviceType == SLServiceTypeTwitter)
		serviceName				= @"Twitter";
	
	NSString *serviceAlert		= [NSString stringWithFormat:@"Please go to the device settings and add a %@ account in order to share through %@.", serviceName, serviceName];
	
	[[[UIAlertView alloc] initWithTitle:@"Missing Account"
								message:serviceAlert
							   delegate:nil
					  cancelButtonTitle:@"Dismiss"
					  otherButtonTitles:nil] show];
}

#pragma mark - Setter & Getter Methods

- (NSArray *)authorsArray
{
	if (!_authorsArray)
	{
		NSString *authorsArrayPath		= [[NSBundle mainBundle] pathForResource:@"FactsList" ofType:@"plist"];
		self.authorsArray				= [NSArray arrayWithContentsOfFile:authorsArrayPath];
	}
	
	return _authorsArray;
}

#pragma mark - View Lifecycle

/**
 *	notifies the view controller that its view was added to a view hierarchy
 */
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self becomeFirstResponder];
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.authorBackgroundView.layer.borderWidth		= 1.0f;
	self.authorBackgroundView.layer.borderColor		= [UIColor colorWithWhite:0.2 alpha:1.0].CGColor;
	self.authorBackgroundView.layer.cornerRadius	= 10.0f;
	self.authorBackgroundView.layer.masksToBounds	= YES;
	
	self.authorImageView.contentMode				= UIViewContentModeScaleAspectFit;
	self.authorImageView.image						= [UIImage imageNamed:@"funfacts"];
	self.authorImageView.layer.borderWidth			= 1.0f;
	self.authorImageView.layer.borderColor			= [UIColor colorWithWhite:0.2 alpha:1.0].CGColor;
	self.authorImageView.layer.shadowColor			= [UIColor colorWithWhite:0.75 alpha:1.0].CGColor;
	self.authorImageView.layer.shadowOffset			= CGSizeMake(-1.0f, -1.0f);
	self.authorImageView.layer.shadowOpacity		= 0.5f;
	
	self.factTextView.text							= @"Shake to get a Fun Fact from a random iOS 6 by Tutorials author or editor.";
	self.factTextView.layer.borderWidth				= 1.0f;
	self.factTextView.layer.borderColor				= [UIColor colorWithWhite:0.2 alpha:1.0].CGColor;
	self.factTextView.layer.cornerRadius			= 10.0f;
	self.factTextView.layer.masksToBounds			= YES;
	self.factTextView.layer.shadowColor				= [UIColor colorWithWhite:0.75 alpha:1.0].CGColor;
	self.factTextView.layer.shadowOffset			= CGSizeMake(-1.0f, -1.0f);
	self.factTextView.layer.shadowOpacity			= 0.5f;
	
	self.factTitleLabel.hidden						= YES;
	
	self.nameLabel.text								= self.twitterLabel.text	= @"";
	
	[self.actionButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)]
								 forState:UIControlStateNormal];
	[self.facebookButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)]
								   forState:UIControlStateNormal];
	[self.twitterButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)]
								  forState:UIControlStateNormal];
	[self.weiboButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)]
								forState:UIControlStateNormal];
	
	self.view.backgroundColor						= [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
}	

#pragma mark - UIResponder Methods

/**
 *	returns whether the receiver can become first responder
 */
- (BOOL)canBecomeFirstResponder
{
	return YES;
}

/**
 *	tells the receiver that a motion event has ended
 *
 *	@param	motion					event-subtype constant indicating the kind of motion
 *	@param	event					object representing the event associated with the motion
 */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (motion == UIEventSubtypeMotionShake)
	{
		//	register the fact that the device has been shaken at least once
		self.deviceWasShaken			= YES;
		
		[self generateRandomFact];
	}
}

@end