//
//  ProfileController.m
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileController.h"
#import "WebController.h"

@interface ProfileController ()

@property (nonatomic, weak) IBOutlet	UITextView		*bioTextView;
@property (nonatomic, weak) IBOutlet	UILabel			*birthdayLabel;
@property (nonatomic, weak) IBOutlet	UIImageView		*coverImageView;
@property (nonatomic, weak) IBOutlet	UILabel			*emailLabel;
@property (nonatomic, weak) IBOutlet	UIButton		*facebookButton;
@property (nonatomic, weak) IBOutlet	UILabel			*genderLabel;
@property (nonatomic, weak) IBOutlet	UILabel			*hometownLabel;
@property (nonatomic, weak) IBOutlet	UILabel			*languagesLabel;
@property (nonatomic, weak) IBOutlet	UILabel			*locationLabel;
@property (nonatomic, weak) IBOutlet	UILabel			*nameLabel;
@property (nonatomic, weak) IBOutlet	UIImageView		*pictureImageView;
@property (atomic, strong)				NSDictionary	*profileDictionary;
@property (nonatomic, weak) IBOutlet	UILabel			*relationshipStatusLabel;
@property (nonatomic, weak) IBOutlet	UILabel			*usernameLabel;
@property (nonatomic, weak) IBOutlet	UIButton		*websiteButton;

@end

@implementation ProfileController

#pragma mark - Action & Selector Methods

- (IBAction)viewOnFacebookTapped
{
	NSString *urlString				= self.profileDictionary[@"link"];
	
	WebController *webController	= [[WebController alloc] initWithNibName:@"WebView" bundle:nil];
	webController.initialURLString	= urlString;
	
	[self presentViewController:webController animated:YES completion:nil];
}

- (IBAction)viewWebsiteTapped
{
	NSString *urlString				= self.profileDictionary[@"website"];
	
	WebController *webController	= [[WebController alloc] initWithNibName:@"WebView" bundle:nil];
	webController.initialURLString	= urlString;
	
	[self presentViewController:webController animated:YES completion:nil];
}

#pragma mark - Convenience Methods

- (void)getPictures
{
	//	make sure we do not block the main thread
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
	^{
		//	get the url which holds the picture data
		NSString *picturesURLString	= self.profileDictionary[@"picture"][@"data"][@"url"];
		NSURL *picturesURL			= [NSURL URLWithString:picturesURLString];
		
		__block NSData *pictureData;
		
		//	we do it synchronously to make sure we only fetch one picture at a time
		dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
		^{
			pictureData				= [NSData dataWithContentsOfURL:picturesURL];
			
			UIImage *pictureImage	= [UIImage imageWithData:pictureData];
			
			dispatch_sync(dispatch_get_main_queue(),
			^{
				self.pictureImageView.image		= pictureImage;
			});
		});
	});
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
	^{
		//	get the cover image data url
		NSString *coverURLString	= self.profileDictionary[@"cover"][@"source"];
		NSURL *coverURL				= [NSURL URLWithString:coverURLString];
		
		__block NSData *coverData;
		
		//	synchronously get the image so we only do one at a time
		dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
		^{
			coverData				= [NSData dataWithContentsOfURL:coverURL];
			UIImage *coverImage		= [UIImage imageWithData:coverData];
			
			//	use the main thread to update with image we have fetched
			dispatch_sync(dispatch_get_main_queue(),
			^{
				self.coverImageView.image		= coverImage;
			});
		});
	});
}

- (void)reloadProfile
{
	//	create a request for the users facebook profile details
	NSDictionary *facebookParameters	= @{@"fields" : @"bio,birthday,cover,email,first_name,gender,hometown,languages,last_name,link,location,picture,relationship_status,security_settings,username,website"};
	
	SLRequest *request					= [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET
											URL:[NSURL URLWithString:@"https://graph.facebook.com/me"] parameters:facebookParameters];
	
	//	use the facebook profile we have fetched to authorise the request
	AppDelegate *appDelegate			= [UIApplication sharedApplication].delegate;
	
	request.account						= appDelegate.facebookAccount;
	
	//	perform teh authorised and confgured request on a different queue
	[request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
	{
		//	if something went wrong alert the user
		if (error)
			[appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error reading your Facebook feed: %@",
												  error.localizedDescription]];
		
		//	otherwise pare the json response data
		else
		{
			NSError *jsonError;
			NSDictionary *responseJSON	= [NSJSONSerialization JSONObjectWithData:responseData
																		  options:NSJSONReadingAllowFragments
																		    error:&jsonError];
			
			if (jsonError)
				[appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error reading your Facebook feed: %@",
													  jsonError.localizedDescription]];
			//	store the parsed json and get the user pictures
			else
			{
				self.profileDictionary	= responseJSON;
				
				NSLog(@"Profile Dictionary: %@", self.profileDictionary);
				
				[self getPictures];
				
				//	on the main queue configure the ui with the user data we fetched and parsed
				dispatch_async(dispatch_get_main_queue(),
				^{
					self.bioTextView.text				= self.profileDictionary[@"bio"];
					self.birthdayLabel.text				= self.profileDictionary[@"birthday"];
					self.emailLabel.text				= self.profileDictionary[@"email"];
					self.genderLabel.text				= self.profileDictionary[@"gender"];
					self.hometownLabel.text				= self.profileDictionary[@"hometown"][@"name"];
					
					NSArray *languages					= self.profileDictionary[@"languages"];
					NSMutableString *languagesString	= [@"" mutableCopy];
					
					for (int i = 0; i < languages.count; i++)
					{
						NSDictionary *language			= languages[i];
						
						[languagesString appendString:language[@"name"]];
						
						if (i < language.count - 1)
							[languagesString appendString:@", "];
					}
					
					self.languagesLabel					= [NSString stringWithString:languagesString];
					
					self.locationLabel.text				= self.profileDictionary[@"location"][@"name"];
					self.nameLabel.text					= [NSString stringWithFormat:@"%@ %@",
														   self.profileDictionary[@"first_name"], self.profileDictionary[@"last_name"]];
					self.usernameLabel.text				= self.profileDictionary[@"username"];
					self.relationshipStatusLabel.text	= self.profileDictionary[@"relationship_status"];
					
					if (!self.profileDictionary[@"website"])
						self.websiteButton.hidden		= YES;
					else
						self.websiteButton.hidden		= NO;
					
					self.facebookButton.hidden			= NO;
				});
			}
		}
	}];
}

#pragma mark - View Lifecycle

/**
 *	notifies the view controller that its view is about to be added to a view hierarchy
 *
 *	@param	animated					whether the view needs to be added to the window with an animation
 */
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProfile) name:kFacebookAccountAccessGranted object:nil];
	
	AppDelegate *appDelegate	= [UIApplication sharedApplication].delegate;
	
	if (appDelegate.facebookAccount)
		[self reloadProfile];
	else
		[appDelegate getFacebookAccount];
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





























































