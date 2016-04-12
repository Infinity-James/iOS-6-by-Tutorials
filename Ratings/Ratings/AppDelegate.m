
#import "AppDelegate.h"
#import "Player.h"
#import "PlayersViewController.h"
#import "RankingsViewController.h"
#import "RatePlayerViewController.h"

@implementation AppDelegate
{
	NSMutableArray						*_players;
}

#pragma mark - UIApplicationDelegate Methods

/**
 *	tells the delegate that the launch process is almost done and the app is almost ready to run
 *
 *	@param	application					the delegating application object
 *	@param	launchOptions				dictionary indicating the reason the application was launched (if any)
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	return YES;
}

/**
 *	asks the delegate whether the app’s saved state information should be restored
 *
 *	@param	application					delegating application object
 *	@param	coder						keyed archiver containing the app’s previously saved state information
 */
- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
	return YES;
}

/**
 *	asks the delegate whether the app’s state should be preserved
 *
 *	@param	application					delegating application object
 *	@param	coder						keyed archiver into which you can put high-level state information
 */
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
	return YES;
}

/**
 *	tells the delegate that the launch process has begun but that state restoration has not yet occurred
 *
 *	@param	application					the delegating application object
 *	@param	launchOptions				dictionary indicating the reason the application was launched (if any)
 */
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self loadPlayers];
	
	self.playersViewController.players	= _players;
	self.rankingsViewController.players	= _players;
	
	[self.window makeKeyAndVisible];
	return YES;
}

/**
 *	tells the delegate that the application is now in the background
 *
 *	@param	application					the delegating application object
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[self savePlayers];
}

/**
 *	tells the delegate when the application is about to terminate
 *
 *	@param	application					the delegating application object
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
	[self savePlayers];
}

/**
 *	asks the delegate to provide the specified view controller
 *
 *	@param	application					delegating application object
 *	@param	identifierComponents		array of nsstrings corresponding to the restoration identifiers of desired view controller & ancestors
 *	@param	coder						keyed archiver containing the app’s saved state information
 */
- (UIViewController *)			application:(UIApplication *)application
viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
									  coder:(NSCoder *)coder
{
	UIViewController *viewController;
	NSString *identifier				= identifierComponents.lastObject;
	
	if ([identifier isEqualToString:@"RatePlayerViewController"])
	{
		UIStoryboard *storyboard		= [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
		
		if (storyboard)
		{
			viewController				= [storyboard instantiateViewControllerWithIdentifier:identifier];
			
			if (viewController)
			{
				RatePlayerViewController *ratePlayerController	= (RatePlayerViewController *)viewController;
				NSString *playerID		= [coder decodeObjectForKey:kPlayerIDKey];
				
				if (playerID)
					ratePlayerController.player					= [self playerWithID:playerID];
			}
		}
	}
	
	return viewController;
}

#pragma mark - Convenience & Helper Methods

- (PlayersViewController *)playersViewController
{
	UITabBarController *tabBarController			= (UITabBarController *)self.window.rootViewController;
	UINavigationController *navigationController	= [tabBarController viewControllers][0];
	PlayersViewController *playersViewController	= [navigationController viewControllers][0];
	return playersViewController;
}

- (RankingsViewController *)rankingsViewController
{
	UITabBarController *tabBarController			= (UITabBarController *)self.window.rootViewController;
	UINavigationController *navigationController	= [tabBarController viewControllers][1];
	RankingsViewController *rankingsViewController	= [navigationController viewControllers][0];
	return rankingsViewController;
}

#pragma mark - Saving & Loading Data

- (NSString *)dataFilePath
{
    NSArray *paths						= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory		= paths[0];
    return [documentsDirectory stringByAppendingPathComponent:@"Players.plist"];
}

- (void)loadPlayers
{
    NSString *path						= [self dataFilePath];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		NSData *data					= [[NSData alloc] initWithContentsOfFile:path];
		NSKeyedUnarchiver *unarchiver	= [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		_players						= [unarchiver decodeObjectForKey:@"Players"];
		[unarchiver finishDecoding];
	}
	
	else
	{
		_players						= [NSMutableArray arrayWithCapacity:20];
		[self addDefaultPlayers];
	}
}

- (Player *)playerWithID:(NSString *)playerID
{
	for (Player *player in _players)
		if ([player.playerID isEqualToString:playerID])
			return player;
	
	return nil;
}

- (void)savePlayers
{
	NSMutableData *data					= [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver			= [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:_players forKey:@"Players"];
	[archiver finishEncoding];
	[data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)addDefaultPlayers
{
	Player *player;

	player = [[Player alloc] init];
	player.name = @"Bill Evans";
	player.game = @"Tic-Tac-Toe";
	player.rating = 4;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Oscar Peterson";
	player.game = @"Spin the Bottle";
	player.rating = 5;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Dave Brubeck";
	player.game = @"Texas Hold'em Poker";
	player.rating = 2;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Slim Pickens";
	player.game = @"Texas Hold'em Poker";
	player.rating = 1;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Tom Waits";
	player.game = @"Russian Roulette";
	player.rating = 5;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Chet Baker";
	player.game = @"Mahjong";
	player.rating = 3;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Duke Ellington";
	player.game = @"Hide and Seek";
	player.rating = 3;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Bill Evans";
	player.game = @"Hide and Seek";
	player.rating = 2;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Miles Davis";
	player.game = @"Yahtzee";
	player.rating = 5;
	[_players addObject:player];

	player = [[Player alloc] init];
	player.name = @"Nina Simone";
	player.game = @"Tic-Tac-Toe";
	player.rating = 1;
	[_players addObject:player];
}

@end
