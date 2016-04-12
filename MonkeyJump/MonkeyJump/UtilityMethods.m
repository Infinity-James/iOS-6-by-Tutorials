//
//  UtilityMethods.m
//  MonkeyJump
//
//  Created by James Valaitis on 14/01/2013.
//
//

#import "GameConstants.h"
#import "UtilityMethods.h"

@implementation UtilityMethods

+ (void)reportAchievementsForDistance:(int64_t)distance
{
	//	get the file path of the achievements plist either directly or finding it in the main bundle
	NSString *rootPath			= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	NSString *plistPath			= [rootPath stringByAppendingPathComponent:kAchievementsFileName];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
		plistPath				= [[NSBundle mainBundle] pathForResource:kAchievementsResourceName ofType:@"plist"];
	
	//	grab array of achievements from plist and then for each achievement we report the percentage complete
	NSArray *achievements		= [NSArray arrayWithContentsOfFile:plistPath];
	
	if (!achievements)			{ CCLOG(@"Error reading the plist: %@", kAchievementsFileName); return; }
	
	for (NSDictionary *achievement in achievements)
	{
		NSString *achievementID	= achievement[@"achievementID"];
		NSNumber *distanceToRun	= achievement[@"distanceToRun"];
		
		CGFloat percentComplete	= (distance * 1.0f / distanceToRun.intValue) * 100;
		
		if (percentComplete > 100)	percentComplete	= 100;
		
		[[GameKitHelper sharedGameKitHelper] reportAchievementWithID:achievementID andPercentageComplete:percentComplete];
	}
}

+ (void)runOnMainThreadSync:(EmptyBlock)anEmptyBlock
{
	if ([NSThread isMainThread])
		anEmptyBlock();
	else
		dispatch_sync(dispatch_get_main_queue(), anEmptyBlock);
}

@end
