//
//  GameKitHelper.m
//  MonkeyJump
//
//  Created by James Valaitis on 11/01/2013.
//
//

#import "ChallengesPickerViewController.h"
#import "FriendsPickerController.h"
#import "GameConstants.h"
#import "GameKitHelper.h"
#import "GameScene.h"
#import "GameTrackingEngine.h"

@interface GameKitHelper () <GKGameCenterControllerDelegate>
{
	BOOL	_gameCenterFeaturesEnabled;
}

@property (nonatomic, readwrite)	NSMutableDictionary			*achievements;
@property (nonatomic, readwrite)	NSError						*lastError;

@end

@implementation GameKitHelper

#pragma mark - Convenience Methods

- (GKAchievement *)getAchievementByID:(NSString *)identifier
{
	GKAchievement *achievement		= self.achievements[identifier];
	
	if (!achievement)
	{
		achievement									= [[GKAchievement alloc] initWithIdentifier:identifier];
		achievement.showsCompletionBanner			= YES;
		self.achievements[achievement.identifier]	= achievement;
	}
	
	return achievement;
}

- (void)shareScore:(int64_t)score
	   forCategory:(NSString *)category
{
	GKScore *gkScore						= [[GKScore alloc] initWithCategory:category];
	gkScore.value							= score;
	
	UIActivityViewController *activityController;
	activityController						= [[UIActivityViewController alloc] initWithActivityItems:@[gkScore] applicationActivities:nil];
	activityController.completionHandler	= ^(NSString *activityType, BOOL completed)
	{
		if (completed)						[self dismissModalViewController];
	};
	
	[self presentViewController:activityController];
}

#pragma mark - Game Center Handling Methods

- (void)findScoresOfFriendsToChallenge
{
	//	 get the leaderboard friend scores and get no more than 100
	GKLeaderboard *leaderboard		= [[GKLeaderboard alloc] init];
	leaderboard.category			= kHighScoreLeaderboardCategory;
	leaderboard.playerScope			= GKLeaderboardPlayerScopeFriendsOnly;
	leaderboard.range				= NSMakeRange(1, 100);
	
	[leaderboard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error)
	 {
		 self.lastError				= error;
		 
		 BOOL success				= (!error);
		 
		 if (success)
		 {
			 if (!self.includeLocalPlayerScore)
			 {
				 NSMutableArray *friendsScores	= @[].mutableCopy;
				 
				 for (GKScore *score in scores)
					 if (![score.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID])
						 [friendsScores addObject:score];
				 
				 scores				= friendsScores;
			 }
			 
			 if ([self.delegate respondsToSelector:@selector(onFriendsScoresReceived:)])
				 [self.delegate onFriendsScoresReceived:scores];
		 }
	 }];
}

- (void)getPlayerInfo:(NSArray *)playerList
{
	if (!_gameCenterFeaturesEnabled || !playerList.count)		return;
	
	[GKPlayer loadPlayersForIdentifiers:playerList withCompletionHandler:^(NSArray *players, NSError *error)
	 {
		 self.lastError		= error;
		 
		 if ([self.delegate respondsToSelector:@selector(onPlayerInfoRecieved:)])
			 [self.delegate onPlayerInfoRecieved:players];
	 }];
}

- (void)loadAchievements
{
	if (!_gameCenterFeaturesEnabled)	{ CCLOG(@"Player has not been authenticated."); return; }
	
	//	load achievements for this app and store them for future tracking
 	[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *loadedAchievements, NSError *error)
	{
		self.lastError									= error;
		
		if (self.achievements)	[self.achievements removeAllObjects];
		
		for (GKAchievement *achievement in loadedAchievements)
		{
			achievement.showsCompletionBanner			= YES;
			self.achievements[achievement.identifier]	= achievement;
		}
		
		//	if there's a delegate that we can talk to, tell it we've loaded the achievements
		if ([self.delegate respondsToSelector:@selector(onAchievementsLoaded:)])
			[self.delegate onAchievementsLoaded:self.achievements];
	}];
}

- (void)loadChallenges
{
	if (!_gameCenterFeaturesEnabled)	return;
	
	[GKChallenge loadReceivedChallengesWithCompletionHandler:^(NSArray *challenges, NSError *error)
	{
		self.lastError					= error;
		BOOL success					= (!error);
		
		if (success && [self.delegate respondsToSelector:@selector(onChallengesReceived:)])
			[self.delegate onChallengesReceived:challenges];
	}];
}

- (void)reportAchievementWithID:(NSString *)identifier
		  andPercentageComplete:(CGFloat)percent
{
	if (!_gameCenterFeaturesEnabled)	{ CCLOG(@"Player not authenticated."); return; }
	
	//	grab the relevant achievement
	GKAchievement *achievement			= [self getAchievementByID:identifier];
	
	//	of the achievement has not already been complete by this much, it is set accordingly and we report it
	if (achievement && achievement.percentComplete < percent)
	{
		achievement.percentComplete		= percent;
		
		[achievement reportAchievementWithCompletionHandler:^(NSError *error)
		{
			self.lastError				= error;
			
			if ([self.delegate respondsToSelector:@selector(onAchievementReported:)])
				[self.delegate onAchievementReported:achievement];
		}];
	}
}

- (void)sendPlayers:(NSArray *)players
	scoreChallenges:(int64_t)score
		withContext:(uint64_t)context
		 andMessage:(NSString *)message
{
	GKScore *gkScore		= [[GKScore alloc] initWithCategory:kHighScoreLeaderboardCategory];
	gkScore.context			= context;
	gkScore.value			= score;
	
	[gkScore issueChallengeToPlayers:players message:message];
}

- (void)sendPlayers:(NSArray *)players
	scoreChallenges:(int64_t)score
		withMessage:(NSString *)message
{
	GKScore *gkScore		= [[GKScore alloc] initWithCategory:kHighScoreLeaderboardCategory];
	gkScore.value			= score;
	
	[gkScore issueChallengeToPlayers:players message:message];
}

- (void)submitScore:(int64_t)score
		 inCategory:(NSString *)category
{
	if (!_gameCenterFeaturesEnabled)	{ CCLOG(@"Player not authenticated."); return; }
	
	//	initialise game kit score object with passed in category and score
	GKScore *gkScore		= [[GKScore alloc] initWithCategory:category];
	gkScore.value			= score;
	
	CCLOG(@"About to report the score");
	
	//	submit the score to game centre
	[gkScore reportScoreWithCompletionHandler:^(NSError *error)
	{
		self.lastError		= error;
		
		BOOL success		= (!error);
		
		CCLOG(@"Reported score.");
		
		if ([self.delegate respondsToSelector:@selector(onScoresSubmitted:)])
			[self.delegate onScoresSubmitted:success];
	}];
}

- (void)  sendPlayers:(NSArray *)players
	  scoreChallenges:(int64_t)score
		  withMessage:(NSString *)message
andGameTrackingObject:(GameTrackingObject *)gameTrackingObject
{
	//	if fameplay information is beign sent we genereate a random challenge id
	if (gameTrackingObject)
	{
		NSNumber *challengeID		= @(arc4random() % 10000 + 1);
		NSLog(@"Challenge ID: %d", challengeID.integerValue);
		
		//	we send the game play information to the server and if we're successful we send the challenge with the id
		[[GameTrackingEngine sharedClient] sendGameTrackingInfo:gameTrackingObject
												withChallengeID:challengeID
													  onSuccess:
		^{
			//	the context is a means of sending the challenge id with certainty that it will be the same on the receiving end
			[self sendPlayers:players scoreChallenges:score withContext:challengeID.integerValue andMessage:message];
		}
													orOnFailure:^(NSError *error)
		{
			[self sendPlayers:players scoreChallenges:score withContext:0 andMessage:message];
		}];
	}
	
	else
		[self sendPlayers:players scoreChallenges:score withContext:0 andMessage:message];
}

#pragma mark - GKGameCenterControllerDelegate Methods

/**
 *	called when the player is done interacting with the view controller’s content
 *
 *	@param	gameCenterViewController		view controller that the player has finished interacting with
 */
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
	[self dismissModalViewController];	
}

#pragma mark - Navigation Methods

- (void)dismissModalViewController
{
	[[self getRootController] dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)getRootController
{
	return [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
{
	[[self getRootController] presentViewController:viewControllerToPresent animated:YES completion:nil];
}

- (void)showChallengePickerController
{
	//	create the challenge picker controller and assign the success and failure completion blocks
	ChallengesPickerViewController *challengesPickerViewController;
	challengesPickerViewController		= [[ChallengesPickerViewController alloc] initWithNibName:@"ChallengesPickerViewController" bundle:nil];
	challengesPickerViewController.cancelButtonPressedBlock	=
	^{
		[self dismissModalViewController];
	};
	challengesPickerViewController.challengeSelectedBlock	= ^(GKScoreChallenge *challenge)
	{
		[self dismissModalViewController];
		
		if (challenge.score.context)
		{
			[[GameTrackingEngine sharedClient] retrieveGameTrackingDetailsForKey:@(challenge.score.context)
																	   onSuccess:^(GameTrackingObject *gameTrackingObject)
			{
				[[CCDirector sharedDirector] replaceScene:
				 [CCTransitionProgressRadialCCW transitionWithDuration:1.0f scene:
				  [[GameScene alloc] initWithGameTrackingObject:gameTrackingObject]]];
			}
																	 orOnFailure:^(NSError *error)
			{
				[[CCDirector sharedDirector] replaceScene: [CCTransitionProgressRadialCCW transitionWithDuration:1.0f
																										   scene:[[GameScene alloc] init]]];
			}];
		}
		
		else
			[[CCDirector sharedDirector] replaceScene: [CCTransitionProgressRadialCCW transitionWithDuration:1.0f
																									   scene:[[GameScene alloc] init]]];
	};
	
	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:challengesPickerViewController]];
}

- (void)showFriendsPickerControllerForScore:(NSNumber *)score
					 withGameTrackingObject:(GameTrackingObject *)gameTrackingObject
{
	FriendsPickerController *friendsPickerController	= [[FriendsPickerController alloc] initWithScore:score
																				   andGameTrackingObject:gameTrackingObject];
	friendsPickerController.cancelButtonBlock			=
	^{
		[self dismissModalViewController];
	};
	friendsPickerController.challengeButtonBlock		=
	^{
		[self dismissModalViewController];
	};
	
	UINavigationController *navigationController		= [[UINavigationController alloc] initWithRootViewController:friendsPickerController];
	
	[self presentViewController:navigationController];
}

- (void)showGameCenterViewController
{
	//	create instance of game center view controller and set ourselves as the delegate
	GKGameCenterViewController *gameCenterViewController	= [[GKGameCenterViewController alloc] init];
	gameCenterViewController.gameCenterDelegate				= self;
	
	//	present the default view to the user
	gameCenterViewController.viewState						= GKGameCenterViewControllerStateDefault;
	[self presentViewController:gameCenterViewController];
}

#pragma mark - Player Authentication

- (void)authenticateLocalPlayer
{
	GKLocalPlayer *localPlayer			= [GKLocalPlayer localPlayer];
	
	localPlayer.authenticateHandler		= ^(UIViewController *viewController, NSError *error)
	{
		self.lastError					= error;
		
		if ([CCDirector sharedDirector].isPaused)
			[[CCDirector sharedDirector] resume];
		
		if (localPlayer.authenticated)
			_gameCenterFeaturesEnabled	= YES, [self loadAchievements];
		else if (viewController)
			[[CCDirector sharedDirector] pause], [self presentViewController:viewController];
		else
			_gameCenterFeaturesEnabled	= NO;
	};
}

#pragma mark - Setter & Getter Methods

- (NSMutableDictionary *)achievements
{
	if (!_achievements)
		_achievements					= @{}.mutableCopy;
	
	return _achievements;
}

- (void)setLastError:(NSError *)lastError
{
	_lastError	= lastError.copy;
	
	if (_lastError)
		NSLog(@"Game Kit Helper Error: %@", _lastError.userInfo.description);
}

#pragma mark - Singleton Methods

+ (id)sharedGameKitHelper
{
	static GameKitHelper *gameKitHelper;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken,
	^{
		gameKitHelper	= [[GameKitHelper alloc] init];
	});
	
	return gameKitHelper;
}

@end
