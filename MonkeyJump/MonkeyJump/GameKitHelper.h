//
//  GameKitHelper.h
//  MonkeyJump
//
//  Created by James Valaitis on 11/01/2013.
//
//

#import <GameKit/GameKit.h>

@class GameTrackingObject;

@protocol GameKitHelperProtocol <NSObject>

@optional

- (void)onAchievementsLoaded:	(NSDictionary *)	achievements;
- (void)onAchievementReported:	(GKAchievement *)	achievement;
- (void)onChallengesReceived:	(NSArray *)			challenges;
- (void)onFriendsScoresReceived:(NSArray *)			scores;
- (void)onPlayerInfoRecieved:	(NSArray *)			players;
- (void)onScoresSubmitted:		(BOOL)				success;

@end

@interface GameKitHelper : NSObject

@property (nonatomic, weak)		id<GameKitHelperProtocol>	delegate;
@property (nonatomic, assign)	BOOL						includeLocalPlayerScore;
@property (nonatomic, readonly)	NSError						*lastError;
@property (nonatomic, readonly)	NSMutableDictionary			*achievements;

+ (id)sharedGameKitHelper;

- (void)authenticateLocalPlayer;
- (void)findScoresOfFriendsToChallenge;
- (void)getPlayerInfo:(NSArray *)playerList;
- (void)loadChallenges;
- (void)reportAchievementWithID:(NSString *)identifier
		  andPercentageComplete:(CGFloat)	percent;
- (void)sendPlayers:(NSArray *)players
	scoreChallenges:(int64_t)score
		withMessage:(NSString *)message;
- (void)sendPlayers:(NSArray *)players
	scoreChallenges:(int64_t)score
		withMessage:(NSString *)message
andGameTrackingObject:(GameTrackingObject *)gameTrackingObject;
- (void)shareScore:(int64_t)	score
	   forCategory:(NSString *)	category;
- (void)showChallengePickerController;
- (void)showFriendsPickerControllerForScore:(NSNumber *)score
					 withGameTrackingObject:(GameTrackingObject *)gameTrackingObject;
- (void)showGameCenterViewController;
- (void)submitScore:(int64_t)	score
		 inCategory:(NSString *)category;

@end
