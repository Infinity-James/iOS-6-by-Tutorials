//
//  UtilityMethods.h
//  MonkeyJump
//
//  Created by James Valaitis on 14/01/2013.
//
//

typedef void(^EmptyBlock)(void);

@interface UtilityMethods : NSObject

+ (void)reportAchievementsForDistance:(int64_t)distance;

+ (void)runOnMainThreadSync:(EmptyBlock)anEmptyBlock;

@end
