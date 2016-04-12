//
//  LikeController.m
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "AppDelegate.h"
#import "LikeController.h"

#define kPhotoGraphURL		@"https://graph.facebook.com/408881369146835/likes"
#define kPhotoURL			@"http://farm9.staticflickr.com/8017/7102072135_2fc80291da.jpg"

@interface LikeController ()

@property (nonatomic, weak) IBOutlet	UIImageView		*coverImageView;
@property (nonatomic, weak) IBOutlet	UILabel			*infoLabel;
@property (nonatomic, weak) IBOutlet	UIButton		*likeButton;
@property (atomic, strong)				NSString		*userID;
@property (atomic, assign)				BOOL			userLikesPhoto;

@end

@implementation LikeController

#pragma mark - Action & Selector Methods

- (IBAction)likeTapped
{
	self.likeButton.enabled		= NO;
	
	AppDelegate *appDelegate	= [UIApplication sharedApplication].delegate;
	
	SLRequestMethod requestMethod;
	
	NSString *errorMessage;
	NSString *infoText;
	NSString *likeButtonText;
	
	if (self.userLikesPhoto)
	{
		requestMethod			= SLRequestMethodDELETE;
		errorMessage			= @"There we an error unliking the photo: %@";
		infoText				= @"Tap the button to like this picture.";
		likeButtonText			= @"Like This Photo";
	}
	
	else
	{
		requestMethod			= SLRequestMethodPOST;
		errorMessage			= @"There we an error liking the photo: %@";
		infoText				= @"You have already liked this picture.";
		likeButtonText			= @"Unlike This Photo";
	}
		
	SLRequest *request		= [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:requestMethod URL:[NSURL URLWithString:kPhotoGraphURL] parameters:nil];
	
	request.account			= appDelegate.facebookAccount;
	
	[request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
	{
		dispatch_sync(dispatch_get_main_queue(),
		^{
			self.likeButton.enabled	= YES;
		});
		
		if (error)
			[appDelegate presentErrorWithMessage:[NSString stringWithFormat:errorMessage,
												  error.localizedDescription]];
		else
		{
			NSError *jsonError;
			
			id responseJSON	= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
			
			if (jsonError)
				[appDelegate presentErrorWithMessage:[NSString stringWithFormat:errorMessage,
													  jsonError.localizedDescription]];
			
			else
			{
				if ([responseJSON intValue] == 1)
				{
					self.userLikesPhoto		= !self.userLikesPhoto;
					dispatch_sync(dispatch_get_main_queue(),
					^{
						self.infoLabel.text	= infoText;
						[self.likeButton setTitle:likeButtonText forState:UIControlStateNormal];
					});
				}
			}
		}
			
	}];
}

#pragma mark - Facebook Connections

- (void)downloadImage
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
	^{
		NSURL *imageURL			= [NSURL URLWithString:kPhotoURL];
		
		__block NSData *imageData;
		
		dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
		^{
			imageData			= [NSData dataWithContentsOfURL:imageURL];
			UIImage *image		= [UIImage imageWithData:imageData];
			
			NSLog(@"LIKE - Fetching photo: %@", image);
			
			dispatch_sync(dispatch_get_main_queue(),
			^{
				NSLog(@"LIKE - Setting photo");
				self.coverImageView.image	= image;
			});
		});
	});
	
	NSURL *requestURL			= [NSURL URLWithString:@"https://graph.facebook.com/me"];
	
	SLRequest *request			= [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET
														URL:requestURL parameters:nil];
	
	AppDelegate *appDelegate	= [UIApplication sharedApplication].delegate;
	request.account				= appDelegate.facebookAccount;
	
	[request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
	{
		if (error)
			[appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There we an error getting the user's ID: %@",
												  error.localizedDescription]];
		
		else
		{
			NSError *jsonError;
			
			NSDictionary *responseJSON	= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
			
			if (jsonError)
				[appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There we an error getting the user's ID: %@",
													  jsonError.localizedDescription]];
			
			else
				self.userID				= responseJSON[@"id"];
		}
	}];
}

- (void)updatePhotoStatus
{
	SLRequest *request		= [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:kPhotoGraphURL] parameters:nil];
	
	AppDelegate *appDelegate		= [UIApplication sharedApplication].delegate;
	
	request.account					= appDelegate.facebookAccount;
	
	[request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
	{
		if (error)
			[appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There we an error getting the status of photo's likes: %@",
												  error.localizedDescription]];
		
		else
		{
			NSError *jsonError;
			NSDictionary *responseJSON	= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
			
			if (jsonError)
				[appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There we an error getting the status of photo's likes: %@",
													  jsonError.localizedDescription]];
			
			else
			{
				NSString *userID	= self.userID;
				NSArray *likes		= responseJSON[@"data"];
				
				for (NSDictionary *user in likes)
					if ([user[@"id"] isEqualToString:userID])
					{
						self.userLikesPhoto	= YES;
						break;
					}
				
				self.likeButton.enabled		= YES;
				
				if (self.userLikesPhoto)
				{
					dispatch_sync(dispatch_get_main_queue(),
					^{
						self.infoLabel.text	= @"You have already liked this picture.";
						[self.likeButton setTitle:@"Unlike This Photo" forState:UIControlStateNormal];
					});
				}
				
				else
				{
					dispatch_sync(dispatch_get_main_queue(),
					^{
						self.infoLabel.text	= @"Tap the button to like this picture.";
						[self.likeButton setTitle:@"Like This Photo" forState:UIControlStateNormal];
					});
				}
			}
		}
	}];
}

#pragma mark - View Lifecycle

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self downloadImage];
}

/**
 *	notifies the view controller that its view is about to be added to a view hierarchy
 *
 *	@param	animated					whether the view needs to be added to the window with an animation
 */
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhotoStatus) name:kFacebookAccountAccessGranted object:nil];
	
	AppDelegate *appDelegate		= [UIApplication sharedApplication].delegate;
	
	if (appDelegate.facebookAccount)
		[self updatePhotoStatus];
	else
	{
		self.likeButton.enabled	= NO;
		[appDelegate getFacebookAccount];
	}
}

/**
 *	notifies the view controller that its view is about to be removed from the view hierarchy
 *
 *	@param	animated					whether the view needs to be removed from the window with an animation
 */
- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super viewWillDisappear:animated];
}

@end










































































