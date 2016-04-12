//
//  AppDelegate.m
//  iSocial
//
//  Created by James Valaitis on 07/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "AppDelegate.h"
#import "iSocialTabController.h"

#define kTwitterAccountSelectedIdentifier	@"TwitterAccountSelectedIdentifier"

@interface AppDelegate () <UIAlertViewDelegate>

@end

@implementation AppDelegate

/**
 *	tells the delegate that the launch process is almost done and the app is almost ready to run
 *
 *	@param	application					the delegating application object
 *	@param	launchOptions				dictionary indicating the reason the application was launched (if any)
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window						= [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.accountStore				= [[ACAccountStore alloc] init];
	
	self.iSocialTabController		= [[iSocialTabController alloc] init];
    
	self.window.rootViewController	= self.iSocialTabController;
	
    self.window.backgroundColor		= [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)getFacebookAccount
{
	//	retrieve the facebook acaccount type from our account store
	ACAccountType *facebookAccountType	= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
	
	//	retrieve the user's facebook account on a separate thread to not black the main thread
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
	^{
		//	clarify what we expect to get from the facebook account
		NSArray *facebookPermissions	= @[@"email", @"read_stream", @"user_relationships", @"user_website"];
		
		NSDictionary *facebookOptions	= @{ACFacebookAppIdKey : kFacebookAPIKey,
											ACFacebookPermissionsKey :facebookPermissions,
											ACFacebookAudienceKey : ACFacebookAudienceEveryone};
		
		//	perform the actual request to access and retrieve the user's system account
		[self.accountStore requestAccessToAccountsWithType:facebookAccountType
												   options:facebookOptions
												completion:^(BOOL granted, NSError *error)
		{
			//	if everything went smoothly we call another method to get access to the publish stream
			if (granted)
				[self getPublishStream];
			
			//	otherwise we didn't get access, and show a relevant alert depending on the reasons as to why
			else
			{
				if (error)
				{
					dispatch_async(dispatch_get_main_queue(),
					^{
						NSString *facebookErrorMessage	= @"There was an error whilst retieving your Facebook account. Please make sure that you have an account set up in Setting and you have granted iSocial access to it.";
						
						[[[UIAlertView alloc] initWithTitle:@"Facebook Account"
													message:facebookErrorMessage
												   delegate:nil
										  cancelButtonTitle:@"Dismiss"
										  otherButtonTitles:nil] show];
					});
				}
				
				else
				{
					dispatch_async(dispatch_get_main_queue(),
					^{
						NSString *facebookErrorMessage	= @"Access to your Facebook accoutn has not been granted for iSocial. You can change this in Settings.";
									   
						[[[UIAlertView alloc] initWithTitle:@"Facebook Account"
													message:facebookErrorMessage
												   delegate:nil
										  cancelButtonTitle:@"Dismiss"
										  otherButtonTitles:nil] show];
					});
				}
			}
		}];
	});
}

- (void)getPublishStream
{
	//	retrieve the facebook acaccount type from our account store
	ACAccountType *facebookAccountType	= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
	
	//	retrieve the user's facebook account on a separate thread to not black the main thread
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
	^{
		//	clarify what we expect to get from the facebook account
		NSArray *facebookPermissions	= @[@"publish_stream"];
		   
		NSDictionary *facebookOptions	= @{ACFacebookAppIdKey : kFacebookAPIKey,
											ACFacebookPermissionsKey : facebookPermissions,
											ACFacebookAudienceKey : ACFacebookAudienceEveryone};
		
		//	perform the actual request to access and retrieve the user's system account
		[self.accountStore requestAccessToAccountsWithType:facebookAccountType
												   options:facebookOptions
												completion:^(BOOL granted, NSError *error)
		{
			//	if everything went smoothly we store the facebook account and post a notification that we now have the account
			if (granted)
			{
				self.facebookAccount	= [self.accountStore accountsWithAccountType:facebookAccountType].lastObject;
				dispatch_async(dispatch_get_main_queue(),
				^{
					[[NSNotificationCenter defaultCenter] postNotificationName:kFacebookAccountAccessGranted object:nil];
				});
			}
			
			//	otherwise we didn't get access, and show a relevant alert depending on the reasons as to why
			else
			{
				if (error)
				{
					dispatch_async(dispatch_get_main_queue(),
					^{
						NSString *facebookErrorMessage	= @"There was an error whilst retrieving your Facebook account. Please make sure that you have an account set up in Setting and you have granted iSocial access to it.";
										   
						[[[UIAlertView alloc] initWithTitle:@"Facebook Account"
													message:facebookErrorMessage
												   delegate:nil
										  cancelButtonTitle:@"Dismiss"
										  otherButtonTitles:nil] show];
					});
				}
					
				else
				{
					dispatch_async(dispatch_get_main_queue(),
					^{
						NSString *facebookErrorMessage	= @"Access to your Facebook account has not been granted for iSocial. You can change this in Settings.";
										   
						[[[UIAlertView alloc] initWithTitle:@"Facebook Account"
													message:facebookErrorMessage
												   delegate:nil
										  cancelButtonTitle:@"Dismiss"
										  otherButtonTitles:nil] show];
					});
				}
			}
		}];
	});
}

- (void)getTwitterAccount
{
	ACAccountType *twitterAccountType	= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
	^{
		[self.accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
		{
			if (granted)
			{
				NSArray *twitterAccounts			= [self.accountStore accountsWithAccountType:twitterAccountType];
				
				NSString *twitterAccountIdentifier	= [[NSUserDefaults standardUserDefaults] objectForKey:kTwitterAccountSelectedIdentifier];
				self.twitterAccount					= [self.accountStore accountWithIdentifier:twitterAccountIdentifier];
				
				if (self.twitterAccount)
					dispatch_async(dispatch_get_main_queue(),
					^{
						[[NSNotificationCenter defaultCenter] postNotificationName:kTwitterAccountAccessGranted object:nil];
					});
				else
				{
					[[NSUserDefaults standardUserDefaults] removeObjectForKey:kTwitterAccountSelectedIdentifier];
					[[NSUserDefaults standardUserDefaults] synchronize];
					
					if (twitterAccounts.count > 1)
					{
						UIAlertView *alertView	= [[UIAlertView alloc] initWithTitle:@"Twitter"
																			 message:@"Select a Twitter account."
																		    delegate:self
																   cancelButtonTitle:@"Nah"
																   otherButtonTitles: nil];
						
						for (ACAccount *account in twitterAccounts)
							[alertView addButtonWithTitle:account.accountDescription];
						
						dispatch_async(dispatch_get_main_queue(),
						^{
							[alertView show];
						});
					}
					
					else
					{
						self.twitterAccount		= twitterAccounts.lastObject;
						dispatch_async(dispatch_get_main_queue(),
						^{
							[[NSNotificationCenter defaultCenter] postNotificationName:kTwitterAccountAccessGranted object:nil];
						});
					}
				}
			}
			
			//	otherwise we didn't get access, and show a relevant alert depending on the reasons as to why
			else
			{
				if (error)
				{
					dispatch_async(dispatch_get_main_queue(),
					^{
						NSString *twitterErrorMessage	= @"There was an error whilst retrieving your Twitter account. Please make sure that you have an account set up in Setting and you have granted iSocial access to it.";
									   
						[[[UIAlertView alloc] initWithTitle:@"Twitter Account"
													message:twitterErrorMessage
												   delegate:nil
										  cancelButtonTitle:@"Dismiss"
										  otherButtonTitles:nil] show];
					});
				}
				
				else
				{
					dispatch_async(dispatch_get_main_queue(),
				   ^{
					   NSString *twitterErrorMessage	= @"Access to your Facebook account has not been granted for iSocial. You can change this in Settings.";
					   
					   [[[UIAlertView alloc] initWithTitle:@"Facebook Account"
												   message:twitterErrorMessage
												  delegate:nil
										 cancelButtonTitle:@"Dismiss"
										 otherButtonTitles:nil] show];
				   });
				}
			}
		}];
	});
}

- (void)presentErrorWithMessage:(NSString *)errorMessage
{
	dispatch_async(dispatch_get_main_queue(),
	^{
		[[[UIAlertView alloc] initWithTitle:@"Error"
									message:errorMessage
								   delegate:nil
						  cancelButtonTitle:@"Dismiss"
						  otherButtonTitles:nil] show];
	});
}

#pragma mark - UIAlertViewDelegate Methods

/**
 *	sent to the delegate when the user clicks a button on an alert view
 *
 *	@param	alertView				alert view containing the button
 *	@param	buttonIndex				index of the button that was clicked
 */
- (void)   alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex)		return;

	ACAccountType *twitterAccountType		= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	NSArray *twitterAccounts				= [self.accountStore accountsWithAccountType:twitterAccountType];
	self.twitterAccount						= twitterAccounts[buttonIndex - 1];
	
	[[NSUserDefaults standardUserDefaults] setObject:self.twitterAccount forKey:kTwitterAccountSelectedIdentifier];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kTwitterAccountAccessGranted object:nil];
}

@end































































