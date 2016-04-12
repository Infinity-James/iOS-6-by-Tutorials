//
//  AppDelegate.h
//  iSocial
//
//  Created by James Valaitis on 07/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#define kCellNIBFile					@"Cells"
#define kFacebookAccountAccessGranted	@"FacebookAccountAccesGranted"
#define kFacebookAPIKey					@"467573653305545"
#define kFacebookAPISecret				@"c7a8ecfc787b15fecee612b7c2c5933d"
#define kTwitterAccountAccessGranted	@"TwitterAccountAccessGranted"

@class iSocialTabController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong)	ACAccountStore			*accountStore;
@property (nonatomic, strong)	ACAccount				*facebookAccount;
@property (nonatomic, strong)	iSocialTabController	*iSocialTabController;
@property (nonatomic, strong)	ACAccount				*twitterAccount;
@property (nonatomic, strong)	UIWindow				*window;

- (void)getFacebookAccount;
- (void)getTwitterAccount;
- (void)presentErrorWithMessage:(NSString *)errorMessage;

@end
