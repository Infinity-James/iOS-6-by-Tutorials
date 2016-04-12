//
//  GameTrackingObject.h
//  MonkeyJump
//
//  Created by James Valaitis on 18/01/2013.
//
//

@interface GameTrackingObject : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, strong)	NSMutableArray		*jumpTimingSinceStartOfGame;
@property (nonatomic, strong)	NSMutableArray		*hitTimingSinceStartOfGame;
@property (nonatomic, assign)	long				seed;

- (void)addJumpTime:(double)jumpTime;
- (void)addHitTime:(double)hitTime;

@end
